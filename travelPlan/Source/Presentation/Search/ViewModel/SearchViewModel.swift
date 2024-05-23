//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

protocol SearchViewModel: ViewModelable
where Input == SearchViewModelInput,
      State == SearchViewModelState,
      Output == AnyPublisher<State, Never> { }

// MARK: - Input
struct SearchViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapView: PassthroughSubject<Void, Never> = .init()
  let didTapSearchButton: PassthroughSubject<String, Never> = .init()
  let didTapStarButton: PassthroughSubject<IndexPath, Never> = .init()
  let didTaplookingMoreButton: PassthroughSubject<Int, Never> = .init()
}

// MARK: - State
enum SearchViewModelState {
  case goDownKeyboard
  case gotoSearch
  case none
  case showSearchMoreDetail(_ sectionType: SearchSectionType)
  case reloadItems(IndexPath)
}

final class DefaultSearchViewModel {
  // MARK: - Properties
  private var dataSource = [SearchSectionModel]()
}

// MARK: - ViewModelCase
extension DefaultSearchViewModel: SearchViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCollectionViewStream(input),
      didTapSearchButtonStream(input),
      didTaplookingMoreButtonStream(input),
      didTapStarButtonStream(input)
    ]).eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ in
        self?.fetchData()
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapCollectionViewStream(_ input: Input) -> Output {
    return input.didTapView
      .map { State.goDownKeyboard }
      .eraseToAnyPublisher()
  }
  
  private func didTapSearchButtonStream(_ input: Input) -> Output {
    return input.didTapSearchButton
      .map { text in
        print("DEBUG: '\(text)' search")
        return State.gotoSearch
      }
      .eraseToAnyPublisher()
  }
  
  private func didTaplookingMoreButtonStream(_ input: Input) -> Output {
    return input.didTaplookingMoreButton
      .map { sectionIndex in
        return State.showSearchMoreDetail(SearchSectionType(rawValue: sectionIndex) ?? .festival)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .flatMap { [weak self] indexPath in
        guard let self = self else {
          return Just(State.none).eraseToAnyPublisher()
        }
        return self.saveButtonState(indexPath: indexPath)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension DefaultSearchViewModel {
  func getCellViewModels(in section: Int) -> SearchItemType {
    return dataSource[section].itemType
  }
  
  func fetchHeaderTitle(in section: Int) -> String {
    return dataSource[section].headerTitle
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch dataSource[section].itemType {
    case let .festival(viewModels):
      return viewModels.count
    case let .leports(viewModels):
      return viewModels.count
    }
  }
  
  func numberOfSections() -> Int {
    dataSource.count
  }
}

// TODO: - imageData를 사용하기 위해 잠시 import UIKit을 사용함.. usecase 완성되면 지울 예정
import UIKit

// MARK: - Private Helpers
extension DefaultSearchViewModel {
  private func fetchData() {
    // 네트워크 요청을 수행해서 데이터를 가져옵니다.
    let festivalHeader = "베스트 축제 🎡"
    let image = UIImage(named: "tempThumbnail1")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    let searchFestivalInfo = SearchFestivalInfo(title: "대관령눈꽃축제", period: "24.05.11~24.05.20",
                                                        imageData: imageData, isSelectedButton: true)
    dataSource.append(
      SearchSectionModel(
        itemType: .festival([searchFestivalInfo, searchFestivalInfo, searchFestivalInfo]),
        headerTitle: festivalHeader
      )
    )
    
    let letportsHeader = "야영 레포츠 어떠세요?🏕️"
    let leportsInfo = TravelDestinationItemInfo(
      place: "수상 스키",
      category: "레포츠",
      location: "강원도 동해",
      isButtonSelected: false,
      imageData: imageData,
      id: 123
    )
    dataSource.append(
      SearchSectionModel(
        itemType: .leports([leportsInfo, leportsInfo, leportsInfo]),
        headerTitle: letportsHeader
      )
    )
  }
  
  /// 서버에 저장 요청.
  /// 성공 시 UI 변환, 실패 시, 변화 없음
  private func saveButtonState(indexPath: IndexPath) -> AnyPublisher<State, Never> {
    // TODO: - id값을 통해 서버에 데이터 저장을 요청하고, 성공 시 하트버튼의 색깔을 변경해야 합니다.
    return Future { promise in
      // fake network. 추후 네트워크 통신 이후, promise로 값을 방출해야 합니다.
      DispatchQueue.global().asyncAfter(wallDeadline: .now() + 0.5) { [weak self] in
        DispatchQueue.main.async {
          print("DEBUG: FakeNetwork 통신 성공!")
          guard let self = self else {
            promise(.success(.none))
            return
          }
          
          switch self.dataSource[indexPath.section].itemType {
          case .festival(var infos):
            infos[indexPath.item].isSelectedButton.toggle()
            self.dataSource[indexPath.section].itemType = .festival(infos)
            
          case .leports(var infos):
            infos[indexPath.item].isButtonSelected.toggle()
            self.dataSource[indexPath.section].itemType = .leports(infos)
          }
          promise(.success(.reloadItems(indexPath)))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

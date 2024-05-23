//
//  SearchMoreDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import Foundation
import Combine

protocol SearchMoreDetailViewModel: ViewModelable
where Input == SearchMoreDetailViewModelInput,
      State == SearchMoreDetailViewModelState,
      Output == AnyPublisher<State, Never> {}

struct SearchMoreDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<SearchSectionType, Never> = .init()
  let didSelectItem: PassthroughSubject<IndexPath, Never> = .init()
  let didTapStarButton: PassthroughSubject<IndexPath, Never> = .init()
}

enum SearchMoreDetailViewModelState {
  case setNavigationTitle(title: String?)
  case showDetail
  case reloadItems(IndexPath)
  case none
}

final class DefaultSearchMoreDetailViewModel {
  // MARK: - Properties
  private(set) var headerInfo: SearchDetailHeaderInfo?
  private(set) var itemInfos: [TravelDestinationInfo]?
}

// MARK: - ViewModelCase
extension DefaultSearchMoreDetailViewModel: SearchMoreDetailViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      didSelecetItemStream(input),
      didTapStarButtonStream(input)
    ).eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    input.viewDidLoad
      .map { [weak self] type in
        self?.fetchData(type: type)
        let title = self?.navigationTitle()
        return .setNavigationTitle(title: title)
      }
      .eraseToAnyPublisher()
  }
  
  private func didSelecetItemStream(_ input: Input) -> Output {
    input.didSelectItem
      .map { [weak self] indexPath in
        // TODO: - 해당 item을 기반으로 상세페이지로 이동합니다.
        print("DEBUG: [\(indexPath.section)], [\(indexPath.item)] clicked")
        return State.showDetail
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

// TODO: - imageData를 사용하기 위해 잠시 import UIKit을 사용함.. usecase 완성되면 지울 예정
import UIKit

// MARK: - Private Helpers
extension DefaultSearchMoreDetailViewModel {
  private func fetchData(type: SearchSectionType) {
    switch type {
    case .festival:
      fetchFestivalModel()
    case .leports:
      fetchLeportsModel()
    }
  }
  
  private func fetchFestivalModel() {
    let image = UIImage(named: "tempThumbnail1")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    self.itemInfos = [
      TravelDestinationInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isButtonSelected: false, imageData: imageData, id: 12345456),
      TravelDestinationInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isButtonSelected: false, imageData: imageData, id: 12345456),
      TravelDestinationInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isButtonSelected: false, imageData: imageData, id: 12345456),
      TravelDestinationInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isButtonSelected: false, imageData: imageData, id: 12345456),
      TravelDestinationInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isButtonSelected: false, imageData: imageData, id: 12345456)
    ]
    self.headerInfo = SearchDetailHeaderInfo.festivalMock
  }
  
  private func fetchLeportsModel() {
    let image = UIImage(named: "tempThumbnail1")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    self.itemInfos = [
      TravelDestinationInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isButtonSelected: false, imageData: imageData, id: 12344),
      TravelDestinationInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isButtonSelected: false, imageData: imageData, id: 12344),
      TravelDestinationInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isButtonSelected: false, imageData: imageData, id: 12344),
      TravelDestinationInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isButtonSelected: false, imageData: imageData, id: 12344),
      TravelDestinationInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isButtonSelected: false, imageData: imageData, id: 12344)
    ]
  }
  
  private func navigationTitle() -> String? {
    return headerInfo?.title
  }
  
  private func saveButtonState(indexPath: IndexPath) -> AnyPublisher<State, Never> {
    // TODO: - id값을 통해 서버에 데이터 저장을 요청하고, 성공 시 하트버튼의 색깔을 변경해야 합니다.
    return Future { promise in
      // fake network. 추후 네트워크 통신 이후, promise로 값을 방출해야 합니다.
      DispatchQueue.global().asyncAfter(wallDeadline: .now() + 0.5) { [weak self] in
        DispatchQueue.main.async {
          guard let self = self else {
            promise(.success(.none))
            return
          }
          self.itemInfos?[indexPath.item].isButtonSelected.toggle()
          promise(.success(.reloadItems(indexPath)))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension DefaultSearchMoreDetailViewModel {
  func numberOfItems(type: SearchSectionType) -> Int {
    switch type {
    case .festival, .leports:
      return itemInfos?.count ?? .zero
    }
  }
}

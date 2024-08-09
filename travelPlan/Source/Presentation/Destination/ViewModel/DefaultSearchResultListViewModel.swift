//
//  DefaultSearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 5/23/24.
//

import Foundation
import Combine

struct SearchResultListViewModelActions {
  let pop: () -> Void
  let showDestinationDetail: (DestinationIdEntity) -> Void
}

enum SearchResultSectionModel {
  case category([TravelDestinationCategoryInfo])
  case destination([TravelDestinationInfo])
}

enum SearchResultSectionIndex: Int {
  case category
  case destination
}

struct SearchResultListViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<(IndexPath, Int, Bool), Never> = .init()
  let didTapSearchButton: PassthroughSubject<String, Never> = .init()
  let didChangeSearchTextField: AnyPublisher<String, Never>
  let didTapCategoryItem: PassthroughSubject<(Int, Int), Never> = .init()
}

enum SearchResultListViewModelState {
  case none
  case firstReloadData(String)
  case reloadSection(Int)
  case reloadItems(IndexPath)
  case changeButtonColor(Bool)
  case reloadDataWithKeyboardDown
}

final class DefaultSearchResultListViewModel: SearchResultListViewModel {
  // MARK: - Dependencies
  private let actions: SearchResultListViewModelActions
  private let useCase: any DestinationSearchResultUseCase
  private var searchKeyword: String
  
  // MARK: - Properties
  var dataSource = [SearchResultSectionModel]()
  private var originalDestinationInfos = [TravelDestinationInfo]()
  
  // MARK: - LifeCycle
  init(
    actions: SearchResultListViewModelActions,
    searchKeyword: String,
    useCase: any DestinationSearchResultUseCase
  ) {
    self.actions = actions
    self.useCase = useCase
    self.searchKeyword = searchKeyword
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Transform
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapStarButtonStream(input),
      didChangeSearchTextFieldStream(input),
      didTapSearchButtonStream(input),
      didTapCategoryItem(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultSearchResultListViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    // TODO: - 네트워크 결과 보이기 전까지 인디케이터 작동시키기
    return input.viewDidLoad.flatMap { [weak self] _ in
      guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
      
      return self.useCase.fetchDestinationList(keyword: searchKeyword, page: nil, perPage: nil)
        .map { (thumbnailDestinations: [ThumbnailDestination]) -> SearchResultListViewModelState in
          self.dataSource.append(.category(
            [TravelDestinationCategoryInfo(contentTypeId: nil, title: "전체")] +
            TourType.allCases.map { TravelDestinationCategoryInfo(contentTypeId: $0.rawValue, title: $0.toString) }
          ))
          
          let travelDestinationInfos = thumbnailDestinations.map {
            TravelDestinationInfo(place: $0.title,
                                  contentTypeId: $0.id.contentTypeId,
                                  category: $0.category.largeCategory,
                                  location: $0.address,
                                  isButtonSelected: $0.isScraped,
                                  imageData: $0.thumbnailImageData,
                                  id: $0.id.id)
          }
          
          self.dataSource.append(.destination(travelDestinationInfos))
          return State.firstReloadData(self.searchKeyword)
        }
        .catch { _ in return Just(State.none).eraseToAnyPublisher() }
        .eraseToAnyPublisher()
    }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .flatMap { [weak self] indexPath, id, isSelected in
        
        print("이전에 버튼이 눌려져있었는가?: \(isSelected)")
        // TODO: - isSelected를 기반으로 아래 주석상태를 구현해야함.
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        return self.saveButtonState(indexPath: indexPath, id: id)
      }
      .eraseToAnyPublisher()
  }
  
  private func saveButtonState(indexPath: IndexPath, id: Int) -> AnyPublisher<State, Never> {
  // 버튼의 눌림 여부에 의해 로직 정의
    // 버튼이 눌려져 있지 않은 경우
     // 디렉토리를 설정해야하므로, folderName이름을 정의해주고 useCase 호출
    
    // 버튼이 눌려져 있는 경우
     // 디렉토리를 설정하지 않으므로, folderName을 nil로 주고 useCase 호출
    
    
    // TODO: - id값을 통해 서버에 데이터 저장을 요청하고, 성공 시 스타버튼의 색깔을 변경해야 합니다.
    return Future { [weak self] promise in
      // fake network. 추후 네트워크 통신 이후, promise로 값을 방출해야 합니다.
      DispatchQueue.global().asyncAfter(wallDeadline: .now() + 0.5) {
        DispatchQueue.main.async {
          print("DEBUG: FakeNetwork 통신 성공!")
          guard let self = self else {
            promise(.success(.none))
            return
          }
          
          if case .destination(var infos) = self.dataSource[indexPath.section] {
            infos[indexPath.item].isButtonSelected.toggle()
            for (i, _) in self.originalDestinationInfos.enumerated()
            where self.originalDestinationInfos[i].id == id {
              self.originalDestinationInfos[i].isButtonSelected.toggle()
              break
            }
    
            self.dataSource[indexPath.section] = .destination(infos)
            
            promise(.success(.reloadItems(indexPath)))
          }
          promise(.success(.none))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  private func didChangeSearchTextFieldStream(_ input: Input) -> Output {
    return input.didChangeSearchTextField
      .map { [weak self] in
        State.changeButtonColor(self?.isValueChanged(text: $0) ?? false)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapSearchButtonStream(_ input: Input) -> Output {
    return input.didTapSearchButton
      .flatMap { [weak self] text in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        return self.useCase.fetchDestinationList(keyword: text, page: nil, perPage: nil)
          .map { (thumbnailDestinations: [ThumbnailDestination]) -> SearchResultListViewModelState in
            let travelDestinationInfos = thumbnailDestinations.map {
              TravelDestinationInfo(place: $0.title,
                                    contentTypeId: $0.id.contentTypeId,
                                    category: $0.category.largeCategory,
                                    location: $0.address,
                                    isButtonSelected: $0.isScraped,
                                    imageData: $0.thumbnailImageData,
                                    id: $0.id.id)
            }
            let destinationIndex = SearchResultSectionIndex.destination.rawValue
            self.dataSource[destinationIndex] = SearchResultSectionModel.destination(travelDestinationInfos)
            return State.reloadDataWithKeyboardDown
          }
          .catch { _ in return Just(State.none).eraseToAnyPublisher() }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapCategoryItem(_ input: Input) -> Output {
    return input.didTapCategoryItem
      .map { [weak self] item, contentTypeId in
        let destinationIndex = SearchResultSectionIndex.destination.rawValue
        
        if case .destination(let infos) = self?.dataSource[destinationIndex] {
          guard let self = self else { return State.none }
          
          if item == .zero {
            self.dataSource[destinationIndex] = .destination(originalDestinationInfos)
          } else {
            self.dataSource[destinationIndex] = .destination(
              originalDestinationInfos.filter {
                $0.contentTypeId == contentTypeId
              }
            )
          }
          return State.reloadSection(destinationIndex)
        }
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func isValueChanged(text: String) -> Bool {
    if text.count > 0 {
      return true
    } else { return false }
  }
}

// MARK: - SearchResultListViewModelPageDelegate
extension DefaultSearchResultListViewModel {
  func pop() {
    actions.pop()
  }
  
  func showDestinationDetailPage(id: Int, contentTypeId: Int) {
    let destinationId = DestinationIdEntity(id: id, contentTypeId: contentTypeId)
    actions.showDestinationDetail(destinationId)
  }
}

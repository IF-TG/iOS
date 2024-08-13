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

@frozen enum SearchResultSectionModel {
  case category([TravelDestinationCategoryInfo])
  case destination([TravelDestinationInfo])
  
  func getId(itemIndex: Int) -> Int? {
    if case .destination(let infos) = self {
      return infos[itemIndex].id
    }
    return nil
  }
}

enum SearchResultSectionIndex: Int {
  case category
  case destination
}

enum SearchResultCategoryItemIndex: Int {
  case all
  case `else`
}

struct SearchResultListViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<(IndexPath, Bool), Never> = .init()
  let didTapSearchButton: PassthroughSubject<String, Never> = .init()
  let didChangeSearchTextField: AnyPublisher<String, Never>
  let didTapCategoryItem: PassthroughSubject<(Int, Int?), Never> = .init()
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
      didTapCategoryItemStream(input)
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
          var categoryInfos = [TravelDestinationCategoryInfo]()
          
          categoryInfos.append(TravelDestinationCategoryInfo(contentTypeId: nil, title: "전체"))
          
          for tourType in TourType.allCases {
            if tourType != TourType.course && tourType != TourType.accommodation {
              categoryInfos.append(
                TravelDestinationCategoryInfo(contentTypeId: tourType.rawValue, title: tourType.toString)
              )
            }
          }
          self.dataSource.append(.category(categoryInfos))
          
          let travelDestinationInfos = thumbnailDestinations.map { destination in
            TravelDestinationInfo(place: destination.title,
                                  contentTypeId: destination.id.contentTypeId,
                                  category: destination.category.largeCategory,
                                  location: destination.address,
                                  isButtonSelected: destination.isScraped,
                                  imageData: destination.thumbnailImageData,
                                  id: destination.id.id)
          }
          self.originalDestinationInfos = travelDestinationInfos
          
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
      .flatMap { [weak self] (indexPath, isSelected) -> AnyPublisher<State, Never> in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        if isSelected {
          return buttonUpdatePublisher(indexPath: indexPath, folderName: nil)
        } else {
          return buttonUpdatePublisher(indexPath: indexPath, folderName: "전체")
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
  
  private func didTapCategoryItemStream(_ input: Input) -> Output {
    return input.didTapCategoryItem
      .map { [weak self] (itemIndex, contentTypeId) -> State in
        guard let self = self else { return State.none }
        
        let destinationIndex = SearchResultSectionIndex.destination.rawValue
        let isAllItemIndexAtCategorySection = itemIndex == SearchResultCategoryItemIndex.all.rawValue
        
        if isAllItemIndexAtCategorySection {
          dataSource[destinationIndex] = .destination(originalDestinationInfos)
        } else {
          let filterdInfos = originalDestinationInfos.filter { $0.contentTypeId == contentTypeId }
          dataSource[destinationIndex] = .destination(filterdInfos)
        }
        return State.reloadSection(destinationIndex)
      }
      .eraseToAnyPublisher()
  }
  
  private func isValueChanged(text: String) -> Bool {
    if text.count > 0 {
      return true
    } else { return false }
  }
  
  private func buttonUpdatePublisher(
    indexPath: IndexPath,
    folderName: String?
  ) -> AnyPublisher<State, Never> {
    guard
      let id = dataSource[indexPath.section].getId(itemIndex: indexPath.item)
    else { return Just(State.none).eraseToAnyPublisher()}
    
    return useCase.toggleScrap(id: id, folderName: folderName)
      .map { [weak self] toggler -> State in
        guard let self = self else { return State.none }
        
        if case .destination(var infos) = self.dataSource[indexPath.section] {
          infos[indexPath.item].isButtonSelected = toggler.isSelected
          self.dataSource[indexPath.section] = .destination(infos)
          
          // update originInfo
          for index in originalDestinationInfos.indices
          where originalDestinationInfos[index].id == infos[indexPath.item].id {
            originalDestinationInfos[index].isButtonSelected = toggler.isSelected
          }
        }
        return State.reloadItems(indexPath)
      }
      .catch { _ in return Just(State.none).eraseToAnyPublisher() }
      .eraseToAnyPublisher()
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

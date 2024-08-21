//
//  DefaultSearchMoreDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import Foundation
import Combine

struct SearchMoreDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<(IndexPath, Bool), Never> = .init()
}

enum SearchMoreDetailViewModelState {
  case reloadDataAndSetHeaderTitle(String)
  case reloadItems(IndexPath)
  case none
}

struct SearchMoreDetailViewModelActions {
  let showDestinationDetail: (DestinationIdEntity) -> Void
  let pop: () -> Void
}

struct SearchMoreDetailInfo {
  var destinations: [TravelDestinationInfo]
  let title: String
  let searchSection: SearchSectionIndex
}

final class DefaultSearchMoreDetailViewModel {
  private var dataSource: SearchMoreDetailInfo
  
  // MARK: - Dependencies
  private let actions: SearchMoreDetailViewModelActions
  private let scrapRepository: any DestinationScrapRepository
  
  // MARK: - LifeCycle
  init(
    actions: SearchMoreDetailViewModelActions,
    destinations: [TravelDestinationInfo],
    title: String,
    scrapRepository: any DestinationScrapRepository,
    searchSection: SearchSectionIndex
  ) {
    self.actions = actions
    let dataSource = SearchMoreDetailInfo(
      destinations: destinations,
      title: title,
      searchSection: searchSection
    )
    self.dataSource = dataSource
    self.scrapRepository = scrapRepository
  }
}

// MARK: - SearchMoreDetailViewModelable
extension DefaultSearchMoreDetailViewModel: SearchMoreDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapStarButtonStream(input)
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultSearchMoreDetailViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    input.viewDidLoad
      .map { [weak self] in
        guard let self else { return State.none }
        
        return State.reloadDataAndSetHeaderTitle(dataSource.title) }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .flatMap { [weak self] (indexPath, isButtonSelected) in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        if isButtonSelected {
          return self.updateScrapState(indexPath: indexPath, folderName: nil)
        } else {
          return self.updateScrapState(indexPath: indexPath, folderName: "전체")
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func updateScrapState(
    indexPath: IndexPath,
    folderName: String?
  ) -> AnyPublisher<State, Never> {
    return scrapRepository.toggleDestinationScrap(
      id: dataSource.destinations[indexPath.item].id,
      folderName: folderName
    ).map { [weak self] in
      self?.dataSource.destinations[indexPath.item].isButtonSelected = $0.isSelected
      
      return State.reloadItems(indexPath)
    }
    .catch { _ in Just(State.none).eraseToAnyPublisher() }
    .eraseToAnyPublisher()
  }
}

// MARK: - SearchMoreDetailViewModelDataSourceable
extension DefaultSearchMoreDetailViewModel: SearchMoreDetailViewModelDataSourceable {
  func numberOfItemsInSection() -> Int {
    return dataSource.destinations.count
  }
  
  func destinationInfo(indexPath: IndexPath) -> TravelDestinationInfo {
    return dataSource.destinations[indexPath.item]
  }
  
  func headerInfo() -> SearchDetailHeaderInfo {
    return SearchDetailHeaderInfo(title: dataSource.title, searchSection: dataSource.searchSection)
  }
}

// MARK: - SearchMoreDetailViewModelPageDelegate
extension DefaultSearchMoreDetailViewModel: SearchMoreDetailViewModelPageDelegate {
  func showDestinationDetail(indexPath: IndexPath) {
    let info = dataSource.destinations[indexPath.item]
    let destinationId = DestinationIdEntity(id: info.id, contentTypeId: info.contentTypeId)
    
    actions.showDestinationDetail(destinationId)
  }
  
  func pop() {
    actions.pop()
  }
}

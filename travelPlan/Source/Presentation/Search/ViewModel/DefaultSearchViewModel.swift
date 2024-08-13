//
//  DefaultSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

struct SearchViewModelActions {
  let showSearchDetail: (SearchSectionType) -> Void
  let showDetail: (_ destinationId: DestinationIdEntity) -> Void
  let showSearchHistory: () -> Void
}

// MARK: - Input
struct SearchViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapView: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<(IndexPath, Bool), Never> = .init()
  let didTaplookingMoreButton: PassthroughSubject<Int, Never> = .init()
  let textFieldDidBeginEditing: PassthroughSubject<Void, Never> = .init()
}

// MARK: - State
enum SearchViewModelState {
  case goDownKeyboard
  case none
  case reloadItems(IndexPath)
  case reloadData
}

final class DefaultSearchViewModel {
  // MARK: - Dependencies
  private let actions: SearchViewModelActions
  private let useCase: any DestinationRecommendUseCase
  
  // MARK: - Properties
  private var dataSource = [SearchSectionModel]()
  
  // MARK: - LifeCycle
  init(useCase: any DestinationRecommendUseCase, actions: SearchViewModelActions) {
    self.useCase = useCase
    self.actions = actions
  }
}

// MARK: - SearchViewModel
extension DefaultSearchViewModel: SearchViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCollectionViewStream(input),
      didTaplookingMoreButtonStream(input),
      didTapStarButtonStream(input),
      textFieldDidBeginEditingStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - SearchViewModelDataSourceable
extension DefaultSearchViewModel: SearchViewModelDataSourceable {
  func getCellViewModels(in section: Int) -> SearchItemType {
    return dataSource[section].itemType
  }
  
  func fetchHeaderTitle(in section: Int) -> String {
    return dataSource[section].headerTitle
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch dataSource[section].itemType {
    case let .festival(infos):
      return infos.count
    case let .else(infos):
      return infos.count
    }
  }
  
  func numberOfSections() -> Int {
    dataSource.count
  }
}

// MARK: - Private Helpers
extension DefaultSearchViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] _ in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        return self.useCase.fetchDestinationList(page: nil, perPage: nil)
          .map { [weak self] recommendSections in
            for (index, recommendSection) in recommendSections.enumerated() {
              if index == .zero {
                let festivalInfos = recommendSection.destinations.map {
                  return SearchFestivalInfo(
                    title: $0.title,
                    location: $0.address,
                    imageData: $0.thumbnailData,
                    contentTypeId: $0.destinationId.contentTypeId,
                    id: $0.destinationId.id,
                    isSelectedButton: $0.isScaped
                  )
                }
                self?.dataSource.append(.init(
                  itemType: .festival(festivalInfos),
                  headerTitle: recommendSection.title
                ))
              } else {
                let infos = recommendSection.destinations.map {
                  return TravelDestinationInfo(
                    place: $0.title,
                    contentTypeId: $0.destinationId.contentTypeId,
                    category: $0.category.large,
                    location: $0.address,
                    isButtonSelected: $0.isScaped,
                    imageData: $0.thumbnailData,
                    id: $0.destinationId.id
                  )
                }
                self?.dataSource.append(.init(
                  itemType: .else(infos),
                  headerTitle: recommendSection.title
                ))
              }
            }
            return State.reloadData
          }
          .catch { _ in return Just(State.none).eraseToAnyPublisher() }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapCollectionViewStream(_ input: Input) -> Output {
    return input.didTapView
      .map { State.goDownKeyboard }
      .eraseToAnyPublisher()
  }
  
  private func didTaplookingMoreButtonStream(_ input: Input) -> Output {
    return input.didTaplookingMoreButton
      .map { [weak self] sectionIndex in
        self?.actions.showSearchDetail(SearchSectionType(rawValue: sectionIndex) ?? .festival)
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .flatMap { [weak self] indexPath, isSelected in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        if isSelected {
          return self.saveButtonState(indexPath: indexPath, folderName: nil)
        } else {
          return self.saveButtonState(indexPath: indexPath, folderName: "전체")
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func textFieldDidBeginEditingStream(_ input: Input) -> Output {
    return input.textFieldDidBeginEditing
      .map { [weak self] in
        self?.actions.showSearchHistory()
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func saveButtonState(indexPath: IndexPath, folderName: String?) -> AnyPublisher<State, Never> {
    let id = self.dataSource[indexPath.section].itemType.getId(itemIndex: indexPath.item)
    
    return useCase.toggleDestinationScrap(id: id, folderName: folderName)
      .map { [weak self] toggler in
        guard let self = self else { return State.none }
        
        switch dataSource[indexPath.section].itemType {
        case .festival(var infos):
          infos[indexPath.item].isSelectedButton = toggler.isSelected
          dataSource[indexPath.section].itemType = .festival(infos)
        case .else(var infos):
          infos[indexPath.item].isButtonSelected = toggler.isSelected
          dataSource[indexPath.section].itemType = .else(infos)
        }
        return State.reloadItems(indexPath)
      }
      .catch { _ in return Just(State.none).eraseToAnyPublisher() }
      .eraseToAnyPublisher()
  }
}

// MARK: - SearchViewModelPageDelegate
extension DefaultSearchViewModel {
  func showDetailPage(indexPath: IndexPath) {
    switch dataSource[indexPath.section].itemType {
    case .festival(let infos):
      let info = infos[indexPath.item]
      let destinationId = DestinationIdEntity(id: info.id, contentTypeId: info.contentTypeId)
      actions.showDetail(destinationId)
    case .else(let infos):
      let info = infos[indexPath.item]
      let destinationId = DestinationIdEntity(id: info.id, contentTypeId: info.contentTypeId)
      actions.showDetail(destinationId)
    }
  }
}

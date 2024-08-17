//
//  DefaultSearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import Foundation
import Combine

struct SearchViewModelActions {
  let showSearchMoreDetail: (_ destinationInfos: [TravelDestinationInfo],
                             _ headerTitle: String,
                             _ searchSection: SearchSectionIndex) -> Void
  let showDestinationDetail: (_ destinationId: DestinationIdEntity) -> Void
  let showSearchHistory: () -> Void
}

// MARK: - Input
struct SearchViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapView: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<(IndexPath, Bool), Never> = .init()
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
  
  // MARK: - SearchViewModelDataSourceable
  private var dataSource = [SearchSectionModel]()
  
  // MARK: - LifeCycle
  init(useCase: any DestinationRecommendUseCase, actions: SearchViewModelActions) {
    self.useCase = useCase
    self.actions = actions
  }
}

// MARK: - SearchViewModel
extension DefaultSearchViewModel: SearchViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCollectionViewStream(input),
      didTapStarButtonStream(input),
      textFieldDidBeginEditingStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - SearchViewModelDataSourceable
extension DefaultSearchViewModel: SearchViewModelDataSourceable {
  func getCellViewModels(in section: Int) -> SearchSectionType {
    return dataSource[section].itemType
  }
  
  func fetchHeaderTitle(in section: Int) -> String {
    return dataSource[section].headerTitle
  }
  
  func numberOfItemsInSection(in section: Int) -> Int {
    switch dataSource[section].itemType {
    case let .festival(infos), let .leports(infos), let .cultureFacility(infos):
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
            guard let self = self else {return State.none }
            
            for (sectionIndex, recommendSection) in recommendSections.enumerated() {
              let itemType: SearchSectionType
              
              let infos = makeTravelDestinationInfos(destinationRecommendSection: recommendSection)
              if sectionIndex == SearchSectionIndex.festival.rawValue {
                itemType = .festival(infos)
              } else if sectionIndex == SearchSectionIndex.leports.rawValue {
                itemType = .leports(infos)
              } else if sectionIndex == SearchSectionIndex.cultureFacility.rawValue {
                itemType = .cultureFacility(infos)
              } else { return State.none }
              
              dataSource.append(SearchSectionModel(itemType: itemType, headerTitle: recommendSection.title))
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
    let id = self.dataSource[indexPath.section].itemType.getId(from: indexPath.item)
    
    return useCase.toggleDestinationScrap(id: id, folderName: folderName)
      .map { [weak self] toggler in
        guard let self = self else { return State.none }
        
        let searchSectionType: SearchSectionType
        switch dataSource[indexPath.section].itemType {
        case .festival(var infos):
          infos[indexPath.item].isButtonSelected = toggler.isSelected
          searchSectionType = .festival(infos)
        case .leports(var infos):
          infos[indexPath.item].isButtonSelected = toggler.isSelected
          searchSectionType = .leports(infos)
        case .cultureFacility(var infos):
          infos[indexPath.item].isButtonSelected = toggler.isSelected
          searchSectionType = .cultureFacility(infos)
        }
        dataSource[indexPath.section].itemType = searchSectionType
        return State.reloadItems(indexPath)
      }
      .catch { _ in return Just(State.none).eraseToAnyPublisher() }
      .eraseToAnyPublisher()
  }
  
  func makeTravelDestinationInfos(
    destinationRecommendSection: DestinationRecommendSection
  ) -> [TravelDestinationInfo] {
    return destinationRecommendSection.destinations.map {
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
  }
}

// MARK: - SearchViewModelPageDelegate
extension DefaultSearchViewModel: SearchViewModelPageDelegate {
  func showDestinationDetailPage(indexPath: IndexPath) {
    switch dataSource[indexPath.section].itemType {
    case .festival(let infos), .leports(let infos), .cultureFacility(let infos):
      let info = infos[indexPath.item]
      let destinationId = DestinationIdEntity(id: info.id, contentTypeId: info.contentTypeId)
      actions.showDestinationDetail(destinationId)
    }
  }
  
  func showMoreDetailPage(sectionIndex: Int) {
    let section: SearchSectionIndex
    let destinations: [TravelDestinationInfo]
    
    switch dataSource[sectionIndex].itemType {
    case .festival(let infos):
      destinations = infos
      section = .festival
    case .leports(let infos):
      destinations = infos
      section = .leports
    case .cultureFacility(let infos):
      destinations = infos
      section = .cultureFacility
    }
    
    actions.showSearchMoreDetail(
      destinations,
      dataSource[sectionIndex].headerTitle,
      section
    )
  }
}

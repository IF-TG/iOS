//
//  DefaultDestinationDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation
import Combine

enum DestinationDetailSection {
  case main(Main)
  case content([Content])
  
  struct Main {
    let title: String
    let address: String
    var isSelectedHeart: Bool
    var heartCount: Int
    let headerInfo: Header
    
    struct Header {
      let imageDatas: [Data?]
    }
  }
  
  struct Content {
    let title: String
    let description: String
  }
}

enum DestinationDetailSectionIndex: Int {
  case main
  case content
}

struct DestinationDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapCopyAddressButton: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<Bool, Never> = .init()
  let didTapHeartButton: PassthroughSubject<IndexPath, Never> = .init()
}

enum DestinationDetailViewModelState {
  case updateScrap(isSelected: Bool)
  case none
  case loadData(isScraped: Bool)
  case reloadItem(indexPath: IndexPath)
  case appearCopyAlert
  case unexpectedError(description: String)
}

struct DestinationDetailViewModelActions {
  let pop: () -> Void
}

final class DefaultDestinationDetailViewModel {
  // MARK: - Dependencies
  private let useCase: any DestinationDetailUseCase
  private let destinationId: DestinationIdEntity
  private let actions: DestinationDetailViewModelActions
  
  // MARK: - Properties
  private var dataSource = [DestinationDetailSection]()
  
  private let emptyInfoString = "해당 데이터를 제공하지 않습니다."
  private let destinationMapper = DestinationDetailContentMapper()
  
  // MARK: - LifeCycle
  init(
    useCase: any DestinationDetailUseCase,
    destinationId: DestinationIdEntity,
    actions: DestinationDetailViewModelActions
  ) {
    self.useCase = useCase
    self.destinationId = destinationId
    self.actions = actions
  }
}

// MARK: - DestinationDetailViewModelable
extension DefaultDestinationDetailViewModel: DestinationDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCopyAddressButtonStream(input),
      didTapStarButtonStream(input),
      didTapHeartButtonStream(input)
    ])
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultDestinationDetailViewModel {
  private func didTapStarButtonStream(_ input: Input) -> Output {
    input.didTapStarButton
      .flatMap { [weak self] isSelected in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        return isSelected
        ? toggleScrapPublisher(id: destinationId.id, folderName: nil)
        : toggleScrapPublisher(id: destinationId.id, folderName: "전체")
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapHeartButtonStream(_ input: Input) -> Output {
    input.didTapHeartButton
      .flatMap { [weak self] indexPath in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        return useCase.toggleLike(id: destinationId.id)
          .map { [weak self] in
            guard let self = self else { return State.none }
            
            if case .main(var mainDataSource) = dataSource[indexPath.section] {
              mainDataSource.isSelectedHeart = $0.isSelected
              
              if $0.isSelected {
                mainDataSource.heartCount += 1
              } else {
                mainDataSource.heartCount -= 1
              }
              dataSource[DestinationDetailSectionIndex.main.rawValue] = .main(mainDataSource)
              
              return State.reloadItem(indexPath: indexPath)
            }
            return State.none
          }
          .catch { _ in return Just(State.none).eraseToAnyPublisher() }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapCopyAddressButtonStream(_ input: Input) -> Output {
    return input.didTapCopyAddressButton
      .map { _ in
        // todo 여기에 주소 text 넣기
        return State.appearCopyAlert
      }
      .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] () -> AnyPublisher<State, Never> in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        return self.useCase.fetchDetail(destinationId: self.destinationId)
          .map { (destinationEntity: DestinationEntity) -> State in
            let firstSection = DestinationDetailSection.main(DestinationDetailSection.Main(
              title: destinationEntity.title,
              address: destinationEntity.address.address1,
              isSelectedHeart: destinationEntity.liked,
              heartCount: destinationEntity.likeCount,
              headerInfo: DestinationDetailSection.Main.Header(imageDatas: destinationEntity.imageDatas)
            ))
            self.dataSource.append(firstSection)
            let contents = self.destinationMapper.makeDestinationDetail(detail: destinationEntity.detail)
            self.dataSource.append(contents)
            
            return State.loadData(isScraped: destinationEntity.isScraped)
          }
          .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func toggleScrapPublisher(id: Int, folderName: String?) -> AnyPublisher<State, Never> {
    return useCase.toggleScrap(id: destinationId.id, folderName: nil)
      .map { toggler in
        return State.updateScrap(isSelected: toggler.isSelected)
      }
      .catch { _ in return Just(State.none).eraseToAnyPublisher() }
      .eraseToAnyPublisher()
  }
}

// MARK: - DestinationDetailViewModelPageDelegate
extension DefaultDestinationDetailViewModel: DestinationDetailViewModelPageDelegate {
  func pop() {
    actions.pop()
  }
}

extension DefaultDestinationDetailViewModel: DestinationDetailViewModelDataSourceable {
  func numberOfSections() -> Int {
    return dataSource.count
  }
  
  func numberOfItemsInSection(sectionIndex: Int) -> Int {
    switch dataSource[sectionIndex] {
    case .main:
      return 1
    case .content(let infos):
      return infos.count
    }
  }
  
  func destinationDetailSection(sectionIndex: Int) -> DestinationDetailSection {
    return dataSource[sectionIndex]
  }
}

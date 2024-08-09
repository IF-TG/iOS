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
  case temp
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

struct DestinationDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapCopyAddressButton: PassthroughSubject<Void, Never> = .init()
}

enum DestinationDetailViewModelState {
  case none
  case reloadData
  case appearCopyAlert
  case unexpectedError(description: String)
}

final class DefaultDestinationDetailViewModel {
  // MARK: - Dependencies
  private let useCase: any DestinationDetailUseCase
  // TODO: - destinationId를 통해서 usecase 호출
  private let destinationId: DestinationIdEntity
  
  // MARK: - Properties
  var dataSource = [DestinationDetailSection]()
  private let emptyInfoString = "해당 데이터를 제공하지 않습니다."
  private let destinationMapper = DestinationDetailContentMapper()
  
  // MARK: - LifeCycle
  init(
    useCase: any DestinationDetailUseCase,
    destinationId: DestinationIdEntity
  ) {
    self.useCase = useCase
    self.destinationId = destinationId
  }
}

// MARK: - DestinationDetailViewModel
extension DefaultDestinationDetailViewModel: DestinationDetailViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCopyAddressButtonStream(input)
    ])
      .eraseToAnyPublisher()
    
  }
}

// MARK: - Private Helpers
extension DefaultDestinationDetailViewModel {
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
              headerInfo: DestinationDetailSection.Main.Header(imageDatas: [destinationEntity.imageData])
            ))
            self.dataSource.append(firstSection)
            
            let contents = self.destinationMapper.makeDestinationDetail(detail: destinationEntity.detail)
            self.dataSource.append(contents)
            
            return State.reloadData
          }
          .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}

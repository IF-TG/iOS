//
//  TravelDestinationCellViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/10.
//

import Foundation
import Combine

final class TravelDestinationCellViewModel {
  typealias Output = AnyPublisher<State, ErrorType>

  // MARK: - Properties
  let contentModel: LeftAlignThreeLabelsView.Model
  var isSelectedButton: Bool
  let imagePath: String?
  let id: Int
  
  // MARK: - LifeCycle
  init(model: TravelDestinationModel) {
    self.contentModel = LeftAlignThreeLabelsView.Model(
      place: model.place,
      category: model.secondText,
      location: model.thirdText
    )
    
    self.isSelectedButton = model.isSelectedButton
    self.imagePath = model.imagePath
    self.id = model.id
  }
  
  // MARK: - Input
  struct Input {
    let didTapStarButton: PassthroughSubject<Void, ErrorType>
    
    init(didTapStarButton: PassthroughSubject<Void, ErrorType> = .init()) {
      self.didTapStarButton = didTapStarButton
    }
  }
  
  // MARK: - State
  enum State {
    case changeButtonColor
    case none
  }
  
  // MARK: - ErrorType
  enum ErrorType: Error {
    case fatalError
    case unexpected
    case networkError
  }
}

// MARK: - ViewModelCase
extension TravelDestinationCellViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    // 서버 저장 요청 후 응답에 따라 output이 달라집니다.
    return input.didTapStarButton
      .flatMap { [weak self] _ in
        guard let self = self else {
          return Fail<State, ErrorType>(error: .unexpected)
            .eraseToAnyPublisher()
        }
        return self.saveButtonState(id: self.id)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension TravelDestinationCellViewModel {
  /// 서버에 저장 요청.
  /// 성공 시 UI 변환, 실패 시, 변화 없음
  private func saveButtonState(id: Int) -> Future<State, ErrorType> {
    // networkTODO: - id값을 통해 서버에 데이터 저장을 요청하고, 성공 시 하트버튼의 색깔을 변경해야 합니다.
    return Future { promise in
      // fake network. 추후 네트워크 통신 이후, promise로 값을 방출해야 합니다.
      DispatchQueue.global().asyncAfter(wallDeadline: .now() + 0.5) { [weak self] in
        print("DEBUG: FakeNetwork 통신 성공!")
        self?.isSelectedButton.toggle()
        promise(.success(.changeButtonColor))
      }
    }
  }
}
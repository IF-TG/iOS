//
//  SearchFestivalCellViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/08.
//

import Combine
import Foundation

final class SearchFestivalCellViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  struct Input {
    let didTapStarButton: PassthroughSubject<Void, ErrorType>
    
    init(
      didTapStarButton: PassthroughSubject<Void, ErrorType> = .init()
    ) {
      self.didTapStarButton = didTapStarButton
    }
  }
  
  enum State {
    case changeButtonColor
    case none
  }
  
  enum ErrorType: Error {
    case fatalError
    case unexpected
    case networkError
  }
  
// MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // TODO: - Cell.Model 타입으로 struct 정의
  var id: Int
  var imagePath: String?
  var title: String
  var periodString: String
  var isSelectedButton: Bool
  
  // MARK: - LifeCycle
  init(model: SearchFestivalModel) {
    id = model.id
    title = model.title
    periodString = model.makePeriod()
    isSelectedButton = model.isSelectedButton
    imagePath = model.imagePath
  }
}

// MARK: - ViewModelCase
extension SearchFestivalCellViewModel: ViewModelCase {
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
extension SearchFestivalCellViewModel {
  /// 서버에 저장 요청.
  /// 성공 시 UI 변환, 실패 시, 변화 없음
  private func saveButtonState(id: Int) -> Future<State, ErrorType> {
    // TODO: - id값을 통해 서버에 데이터 저장을 요청하고, 성공 시 하트버튼의 색깔을 변경해야 합니다.
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
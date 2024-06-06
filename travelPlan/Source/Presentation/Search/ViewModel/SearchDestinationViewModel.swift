//
//  SearchDestinationViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation
import Combine

enum SearchDestinationSection {
  case main(Main)
  case temp
  case content([Content])
  
  struct Main {
    let title: String
    let address: String
    var isSelectedHeart: Bool
    var heartCount: Int
  }
  
  struct Content {
    let title: String
    let description: String
  }
}

protocol SearchDestinationViewModelDataSourceable {
  var dataSource: [SearchDestinationSection] { get }
}

protocol SearchDestinationViewModel: ViewModelable, SearchDestinationViewModelDataSourceable
where Input == SearchDestinationViewModelInput,
      State == SearchDestinationViewModelState,
      Output == AnyPublisher<State, Never> { }

struct SearchDestinationViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapCopyAddressButton: PassthroughSubject<Void, Never> = .init()
}

enum SearchDestinationViewModelState {
  case none
  case reloadData(thumbnailData: Data)
//  case setupContent(type: DestinationType)
}

final class DefaultSearchDestinationViewModel {
  // MARK: - Properties
  var dataSource = [SearchDestinationSection]()
}

// MARK: - SearchDestinationViewModel
extension DefaultSearchDestinationViewModel: SearchDestinationViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCopyAddressButtonStream(input)
    ])
      .eraseToAnyPublisher()
    
  }
}

// MARK: - Private Helpers
extension DefaultSearchDestinationViewModel {
  private func didTapCopyAddressButtonStream(_ input: Input) -> Output {
    return input.didTapCopyAddressButton
      .map { _ in
        print("복사 버튼 클릭")
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    // TODO: - type에 따라서 type에 맞게 data fetch 후, vc의 type에 맞게 content view구조를 보여주어야합니다.
    return input.viewDidLoad
      .delay(for: 0.5, scheduler: DispatchQueue.global(qos: .userInitiated))
      .map { [weak self] _ in
        let section1 = SearchDestinationSection.main(
          .init(
            title: "서문수육애국밥서문수육애국밥서문수육애국밥",
            address: "대전 동구 대학로 37대전 동구 대학로 37대전 동구 대학로 37대전 동구 대학로 37대전 동구 대학로 37",
            isSelectedHeart: true,
            heartCount: 10
          )
        )
        
        self?.dataSource.append(section1)
        self?.dataSource.append(.temp) // temp Section2
        
        let section2 = SearchDestinationSection.content([
          .init(title: "🕐영업시간", description: """
                월 09:00 ~ 18:00
                화 09:00 ~ 18:00
                수 09:00 ~ 18:00
                목 09:00 ~ 18:00
                금 09:00 ~ 18:00
                """),
          .init(title: "⛔️휴무일", description: "둘째 넷째 화요일"),
          .init(title: "🍱대표 메뉴", description: """
              수육국밥:     7,000원
              머리고기국밥:  8,000원
              순대국밥:     8,000원
              특 모듬국밥:   8,000원
              """),
          .init(title: "🅿️주차요금", description: "무료"),
          .init(title: "📞️전화번호", description: "042-282-5954"),
          .init(title: "✔️️서비스", description: "주차 가능 / 포장 가능"),
          .init(title: "타이틀2", description: "설명2"),
          .init(title: "타이틀2", description: "설명2"),
          .init(title: "타이틀2", description: "설명2")
        ])
        self?.dataSource.append(section2)
        
        let thumbnailData = TempSource.imageData
        return State.reloadData(thumbnailData: thumbnailData)
      }
      .eraseToAnyPublisher()
  }
}

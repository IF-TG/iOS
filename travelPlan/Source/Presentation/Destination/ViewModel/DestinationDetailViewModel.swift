//
//  DestinationDetailViewModel.swift
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
      let imageDatas: [Data]
    }
  }
  
  struct Content {
    let title: String
    let description: String
  }
}

protocol DestinationDetailViewModelDataSourceable {
  var dataSource: [DestinationDetailSection] { get }
}

protocol DestinationDetailViewModel: ViewModelable, DestinationDetailViewModelDataSourceable
where Input == DestinationDetailViewModelInput,
      State == DestinationDetailViewModelState,
      Output == AnyPublisher<State, Never> { }

struct DestinationDetailViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapCopyAddressButton: PassthroughSubject<Void, Never> = .init()
}

enum DestinationDetailViewModelState {
  case none
  case reloadData
  case appearCopyAlert
}

final class DefaultDestinationDetailViewModel {
  // MARK: - Properties
  var dataSource = [DestinationDetailSection]()
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
    // TODO: - type에 따라서 type에 맞게 data fetch 후, vc의 type에 맞게 content view구조를 보여주어야합니다.
    return input.viewDidLoad
      .delay(for: 0.5, scheduler: DispatchQueue.global(qos: .userInitiated))
      .map { [weak self] _ in
        
        let thumbnailDatas = [TempSource.imageData,
                             TempSource.imageData2,
                             TempSource.imageData,
                             TempSource.imageData2]
        
        let section1 = DestinationDetailSection.main(
          .init(
            title: "서문수육애국밥서문수육애국밥서문수육애국밥",
            address: "대전 동구 대학로 37대전 동구 대학로 37대전 동구 대학로 37대전 동구 대학로 37대전 동구 대학로 37",
            isSelectedHeart: true,
            heartCount: 10,
            headerInfo: DestinationDetailSection.Main.Header(imageDatas: thumbnailDatas)
          )
        )
        
        self?.dataSource.append(section1)
        self?.dataSource.append(.temp) // temp Section2
        
        let section2 = DestinationDetailSection.content([
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
      
        return State.reloadData
      }
      .eraseToAnyPublisher()
  }
}

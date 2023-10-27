//
//  MockPostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 10/17/23.
//

import Alamofire
import Combine
import Foundation

// 임시
struct MockPostUseCase: PostUseCase {
  func fetchPosts() -> Future<[PostEntity], AFError> {
    return Future { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        promise(.success(PostEntity.mockData))
      }
    }
  }
}

// 임시
extension PostEntity {
  private static func postThumbnailPath(_ index: Int) -> String { return "tempThumbnail\(index)" }
  private static func profilePath(_ index: Int) -> String { return "tempProfile\(index)" }
  private static var titles: [String] {
    ["Capturing the Beauty of Ocean Bliss", "영롱한 바다",
     "거, 갈땐 가더라도 커피 한잔 정도는 괜찮잖나.. ", "맛과 향의 여행", 
     "또 가고 싶다.."]
  }
  private static var userNames: [String] {
    ["Wanderlust_Journey", "SoulRebel", "용감한모험가", "커피맨", "모던스타일"]
  }
  private static var durationArray: [String] {
    ["한달", "7일", "3일", "12일", "60일"]
  }
  private static var ymdArray: [String] {
    ["2023.03.16 ~ 2023.04.15", "2023.04.03 ~ 2023.04.09", "2023.04.17 ~ 2023.04.19",
     "2023.03.19 ~ 2023.03.30", "2023.03.15 ~ 2023.05.13"]
  }
  private static var postContentTexts: [String] {
    ["여름 여름 여름 여름~~~~ ",
     "발리의 푸른 바다와 화려한 저녁 일몰은 정말로 멋있었어요. 휴양의 천국입니다! 대박 다음에 또 와야겠어요",
     "이번 여행에서는 평소에 느끼지 못한 여유와 힐링을 느낄 수 있었습니다.",
     "수영 하며 시원한 바다 즐겼는데, 특히 파도가 너무 작아서 안전하게 즐길 수 있었어요. 오랜만에 파스타 먹으니 대박 맛있어요. 따봉 따봉 강추!!",
     "여행 중 발견한 빙수 가게의 특별한 토핑과 시럽 조합은 따봉"]
  }
  private static var postContentThumbnails: [[String]] {
    [[1].map { postThumbnailPath($0) },
     [2, 3].map { postThumbnailPath($0) },
     (4...6).map { postThumbnailPath($0) },
     (7...10).map { postThumbnailPath($0) },
     (11...15).map { postThumbnailPath($0) }]
  }
  private static var postHearts: [Int] {
    [0, 1040, 41, 548, 7]
  }
  private static var postComments: [Int] {
    [0, 2, 10, 1, 38]
  }
  static var mockData: [Self] {
    (0..<5).map {
      PostEntity(
        id: $0,
        profileImageURL: profilePath($0+1), 
        title: titles[$0],
        userName: userNames[$0],
        duration: durationArray[$0],
        yearMonthDayRange: ymdArray[$0],
        thumbnailImageURls: postContentThumbnails[$0],
        contentText: postContentTexts[$0],
        heartCount: postHearts[$0],
        commentCount: postComments[$0])
    }
  }
}

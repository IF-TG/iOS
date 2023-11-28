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
  private static func profilePath(_ index: Int) -> String { return "tempProfile\(index+1)" }
  private static var titles: [String] {
    ["Capturing the Beauty of Ocean Bliss", "영롱한 바다",
     "거, 갈땐 가더라도 커피 한잔 정도는 괜찮잖나.. ", "맛과 향의 여행", 
     "또 가고 싶다..", "떠나요 둘이서", "신나는 여행~~", "여수 밤바다", "분위기 좋은 카페~",
    
     "Capturing the Beauty of Ocean Bliss", "영롱한 바다",
     "거, 갈땐 가더라도 커피 한잔 정도는 괜찮잖나.. ", "맛과 향의 여행",
     "또 가고 싶다..", "떠나요 둘이서", "신나는 여행~~", "여수 밤바다", "분위기 좋은 카페~"]
  }
  private static var userNames: [String] {
    ["Wanderlust_Journey", "SoulRebel", "용감한모험가", "커피맨", "모던스타일",
     "네트워킹마스터", "알고리즘 전문가", "concurrency Master", "자 가보자고~",
    
     "Wanderlust_Journey", "SoulRebel", "용감한모험가", "커피맨", "모던스타일",
     "네트워킹마스터", "알고리즘 전문가", "concurrency Master", "자 가보자고~"]
  }
  private static var durationArray: [String] {
    ["한달", "7일", "3일", "12일", "60일",
     "7일", "14일", "20일", "2일",
    
     "한달", "7일", "3일", "12일", "60일",
     "7일", "14일", "20일", "2일"]
  }
  private static var ymdArray: [String] {
    ["2023.03.16 ~ 2023.04.15", "2023.04.03 ~ 2023.04.09", "2023.04.17 ~ 2023.04.19",
     "2023.03.19 ~ 2023.03.30", "2023.03.15 ~ 2023.05.13",
     "2023.03.18 ~ 2023.03.24", "2023.03.07 ~ 2023.03.20", "2023.04.03 ~ 2023.04.22", "2023.04.11 ~ 2023.04.12",
    
     "2023.03.16 ~ 2023.04.15", "2023.04.03 ~ 2023.04.09", "2023.04.17 ~ 2023.04.19",
     "2023.03.19 ~ 2023.03.30", "2023.03.15 ~ 2023.05.13",
     "2023.03.18 ~ 2023.03.24", "2023.03.07 ~ 2023.03.20", "2023.04.03 ~ 2023.04.22", "2023.04.11 ~ 2023.04.12"]
  }
  private static var postContentTexts: [String] {
    ["여름 여름 여름 여름~~~~ ",
     "발리의 푸른 바다와 화려한 저녁 일몰은 정말로 멋있었어요. 휴양의 천국입니다! 대박 다음에 또 와야겠어요",
     "이번 여행에서는 평소에 느끼지 못한 여유와 힐링을 느낄 수 있었습니다.",
     "수영 하며 시원한 바다 즐겼는데, 특히 파도가 너무 작아서 안전하게 즐길 수 있었어요. 오랜만에 파스타 먹으니 대박 맛있어요. 따봉 따봉 강추!!",
     "여행 중 발견한 빙수 가게의 특별한 토핑과 시럽 조합은 따봉",
     "여행하기 정말 좋은 날씨!!! 여름은 봄에가야죠: )",
     "출발전 모로코 지진소식으로 가족과 지인들의 우려속에 불안한 마음으로 출발했는데" +
     "민선예 인솔자님과 유범상 현지가이드님 덕분에 안전하고 편한하게 여행을 마무리할수 있었습니다",
     "시작된 하노이, 최고의 바다 여행은 만족스럽고 행복한 일정 이었습니다.",
     "공항에 가이드를 처음 대면했을때 참 쉽지 않은 여행이 되겠구나 라는 느낌을 가졌습니다. 그래도 비행기에 타니 여행이 기대가 됬었어요.",
     
     "여름 여름 여름 여름~~~~ ",
     "발리의 푸른 바다와 화려한 저녁 일몰은 정말로 멋있었어요. 휴양의 천국입니다! 대박 다음에 또 와야겠어요",
     "이번 여행에서는 평소에 느끼지 못한 여유와 힐링을 느낄 수 있었습니다.",
     "수영 하며 시원한 바다 즐겼는데, 특히 파도가 너무 작아서 안전하게 즐길 수 있었어요. 오랜만에 파스타 먹으니 대박 맛있어요. 따봉 따봉 강추!!",
     "여행 중 발견한 빙수 가게의 특별한 토핑과 시럽 조합은 따봉",
     "여행하기 정말 좋은 날씨!!! 여름은 봄에가야죠: )",
     "출발전 모로코 지진소식으로 가족과 지인들의 우려속에 불안한 마음으로 출발했는데" +
     "민선예 인솔자님과 유범상 현지가이드님 덕분에 안전하고 편한하게 여행을 마무리할수 있었습니다",
     "시작된 하노이, 최고의 바다 여행은 만족스럽고 행복한 일정 이었습니다.",
     "공항에 가이드를 처음 대면했을때 참 쉽지 않은 여행이 되겠구나 라는 느낌을 가졌습니다. 그래도 비행기에 타니 여행이 기대가 됬었어요."
    ]
  }
  private static var postContentThumbnails: [[String]] {
    [[1].map { postThumbnailPath($0) },
     [2, 3].map { postThumbnailPath($0) },
     (4...6).map { postThumbnailPath($0) },
     (7...10).map { postThumbnailPath($0) },
     (11...15).map { postThumbnailPath($0) },
     [4, 9, 12, 2].map { postThumbnailPath($0)},
     [6, 4, 3].map { postThumbnailPath($0) },
     [11, 8].map { postThumbnailPath($0) },
     [4, 6, 12, 15, 3].map { postThumbnailPath($0) },
    
     [1].map { postThumbnailPath($0) },
     [2, 3].map { postThumbnailPath($0) },
     (4...6).map { postThumbnailPath($0) },
     (7...10).map { postThumbnailPath($0) },
     (11...15).map { postThumbnailPath($0) },
     [4, 9, 12, 2].map { postThumbnailPath($0)},
     [6, 4, 3].map { postThumbnailPath($0) },
     [11, 8].map { postThumbnailPath($0) },
     [4, 6, 12, 15, 3].map { postThumbnailPath($0) }]
  }
  private static var postHearts: [Int] {
    [0, 1040, 41, 548, 7, 2, 10, 4, 1,
    
     0, 1040, 41, 548, 7, 2, 10, 4, 1]
  }
  private static var postComments: [Int] {
    [0, 2, 10, 1, 38, 2, 4, 22, 10,
    
     0, 2, 10, 1, 38, 2, 4, 22, 10]
  }
  static var mockData: [Self] {
    let data = (0..<9*2).map {
      PostEntity(
        id: $0,
        profileImageURL: profilePath($0%5),
        title: titles[$0],
        userName: userNames[$0],
        duration: durationArray[$0],
        yearMonthDayRange: ymdArray[$0],
        thumbnailImageURls: postContentThumbnails[$0],
        contentText: postContentTexts[$0],
        heartCount: postHearts[$0],
        commentCount: postComments[$0])
    }
    
    return data + data + data + data
  }
}

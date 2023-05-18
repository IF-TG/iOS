//
//  MockPostModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

final class MockPostModel {
  private lazy var mockHeader = initMockHeader()
  
  private lazy var mockContent = initMockContent()
  
  private lazy var mockFooter = initMockFooter()
  
  func initMockData() -> [PostModel] {
    return (0..<5).map { i -> PostModel in
      return PostModel(
        header: mockHeader[i],
        content: mockContent[i],
        footer: mockFooter[i])
    }
  }
}

// MARK: - Helpers
private extension MockPostModel {
  func tempThumb(_ index: Int) -> String {
    return "tempThumbnail\(index)"
  }
  
  func tempProf(_ index: Int) -> String {
    return "tempProfile\(index)"
  }
  
  func compressThumbImg(_ index: Int) -> UIImage {
    return UIImage(named: tempThumb(index))!.compressJPEGImage(with: 0.0005)!
  }
  
  func compressProfImg(_ index: Int) -> UIImage {
    return UIImage(named: tempProf(index))!.compressJPEGImage(with: 0.0003)!
  }
  
  func initMockHeader() -> [PostHeaderModel] {
    let mockHeaderSubInfo = initMockHeaderSubInfo()
    return [
      ("Capturing the Beauty of Ocean Bliss",
       compressProfImg(1),
       mockHeaderSubInfo[0]),
      ("영롱한 바다",
       compressProfImg(2),
       mockHeaderSubInfo[1]),
      ("거, 갈땐 가더라도 커피 한잔 정도는 괜찮잖나.. ",
       compressProfImg(3),
       mockHeaderSubInfo[2]),
      ("맛과 향의 여행",
       compressProfImg(4),
       mockHeaderSubInfo[3]),
      ("또 가고 싶다..",
       compressProfImg(5),
       mockHeaderSubInfo[4])].map {
         PostHeaderModel(title: $0, image: $1, subInfo: $2)
       }
  }
  
  func initMockHeaderSubInfo() -> [PostHeaderSubInfoModel] {
    return [
      ("Wanderlust_Journey", "한달", "2023.03.16 ~ 2023.04.15"),
      ("SoulRebel", "7일", "2023.04.03 ~ 2023.04.09"),
      ("용감한모험가", "3일", "2023.04.17 ~ 2023.04.19"),
      ("커피맨", "12일", "2023.03.19 ~ 2023.03.30"),
      ("모던스타일", "60일", "2023.03.15 ~ 2023.05.13")]
      .map {
        PostHeaderSubInfoModel(userName: $0, duration: $1, yearMonthDayRange: $2)
      }
  }
  
  func initMockContent() -> [PostContentAreaModel] {
    let tempStr = "특히 파도가 너무 작아서 안전하게 즐길 수 있었어요."
    let tempString = " 오랜만에 파스타 먹으니 대박 맛있어요. 따봉 따봉 강추!!"
    return [
      (" 여름 여름 여름 여름~~~~ ",
       [compressThumbImg(1)]),
     ("발리의 푸른 바다와 화려한 저녁 일몰은 정말로 멋있었어요. 휴양의 천국입니다! 대박 다음에 또 와야겠어요",
      (2...3).map { i -> UIImage in compressThumbImg(i) }),
      ("이번 여행에서는 평소에 느끼지 못한 여유와 힐링을 느낄 수 있었습니다.",
       (4...6).map { i -> UIImage in compressThumbImg(i) }),
      ("수영 하며 시원한 바다 즐겼는데, \(tempStr)\(tempString)",
       (7...10).map { i -> UIImage in compressThumbImg(i) }),
      ("여행 중 발견한 빙수 가게의 특별한 토핑과 시럽 조합은 따봉", (11...15).map { i -> UIImage in compressThumbImg(i)})
    ].map {
        PostContentAreaModel(text: $0, thumbnailImages: $1)
      }
  }
  
  func initMockFooter() -> [PostFooterModel] {
    return [
      (0, false, 0), (1040, false, 23),
      (41, false, 2), (548, false, 0), (7, false, 0)].map {
        PostFooterModel(heartCount: $0, heartState: $1, commentCount: $2)
      }
  }
}

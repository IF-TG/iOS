//
//  DestinationScrapRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/11/24.
//

import Foundation
import Combine

protocol DestinationScrapRepository {
  /// 폴더이름에 해당하는 스크랩된 여행지 리스트를 가져옵니다.
  func getDestinationScrapList(
    folderName: String,
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[DestinationScrapDetail], any Error>
  
  /// 여행지 스크랩 추가/삭제를 요청합니다.
  /// 
  /// 스크랩 추가 시, folderName이 필수로 요구됩니다.
  /// 반면 스크랩 삭제 시, folderName을 요구하지 않습니다.
  func toggleDestinationScrap(
    id: Int,
    folderName: String?
  ) -> AnyPublisher<DestinationScrapToggler, any Error>
  
  /// 특정 스크랩 폴더 이름에 해당하는 여행지를 업데이트합니다.
  ///
  /// folderName으로 objectIdList를 옮깁니다.
  func updateDestinationScrap(
    objectIdList: [Int],
    folderName: String
  ) -> AnyPublisher<[UpdatedDestinationScrap], any Error>
}

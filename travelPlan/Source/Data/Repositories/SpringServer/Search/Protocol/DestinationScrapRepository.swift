//
//  DestinationScrapRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/11/24.
//

import Foundation
import Combine

protocol DestinationScrapRepository {
  func getDestinationScrapList(
    folderName: String,
    page: Int32?,
    perPage: Int32?
  ) -> AnyPublisher<[DestinationScrapDetail], any Error>
  
  func toggleDestinationScrap(
    id: Int64,
    folderName: String
  ) -> AnyPublisher<DestinationScrapToggler, any Error>
  
  func updateDestinationScrap(
    objectIdList: [Int64],
    folderName: String
  ) -> AnyPublisher<[UpdatedDestinationScrap], any Error>
}

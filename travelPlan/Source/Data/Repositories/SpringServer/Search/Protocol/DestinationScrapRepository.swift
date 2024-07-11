//
//  DestinationScrapRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/11/24.
//

import Foundation
import Combine

protocol DestinationScrapRepository {
  func getDestinationScrapList(folderName: String) -> AnyPublisher<DestinationScrapList, any Error>
  
  func toggleDestinationScrap(
    id: Int64,
    forderName: String
  ) -> AnyPublisher<DestinationScrapToggler, any Error>
  
  func updateDestinationScrap(
    objectIdList: [Int64],
    forderName: String
  ) -> AnyPublisher<[UpdatedDestinationScrap], any Error>
}

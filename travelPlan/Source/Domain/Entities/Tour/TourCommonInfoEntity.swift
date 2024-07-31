//
//  TourDestinationDetailCommonEntity.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourCommonInfoEntity<T> {
  let id: TourContentId
  let address: DestinationAddress
  let contact: DestinationContact
  let coordinate: DestinationCoordinate<T>
  let image: DestinationImage
  let overview: String
  let title: String
}

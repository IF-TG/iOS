//
//  TourDestinationDetailCommonEntity.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourCommonInfoEntity<T> {
  let id: TourContentId
  let address: TourAddress
  let contact: TourContact
  let coordinate: TourCoordinate<T>
  let image: TourImage
  let overview: String
  let title: String
}

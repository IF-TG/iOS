//
//  AccommodationEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation

struct AccommodationEntity {
  let tourContentId: TourContentId
  let checkinTime: String
  let checkoutTime: String
  let roomType: String
  let canCook: String
  let internalFacilities: String
  let telNumber: String
  let reservationNumber: String
  let canPark: String
  let address: String
  let title: String
  let overview: String
  let imageDataList: [Data?]
}

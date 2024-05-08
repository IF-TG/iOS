//
//  TourFestivalResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

/// 행사정보조회 API
struct TourFestivalResponseDTO: Decodable {
  let startDateString: String
  let endDateString: String
  let title: String
  let imageURL: String
  let address: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case startDateString = "eventstartdate"
    case endDateString = "eventenddate"
    case address = "addr1"
    case imageURL = "firstimage"
  }
}

extension TourFestivalResponseDTO {
  func toFestivalThumbnailEntity(imageData: Data) -> FestivalThumbnailEntity {
    let formattedStartDate = DateTimeConverter.toDate(from: startDateString, dateFormat: "yyyyMMdd")
    let formattedEndDate = DateTimeConverter.toDate(from: endDateString, dateFormat: "yyyyMMdd")
    
    return .init(
      title: title,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      imageData: imageData
    )
  }
}

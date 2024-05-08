//
//  TourFestivalResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

/// 행사정보조회 API
struct TourFestivalResponseDTO: Decodable {
  let startDate: String
  let endDate: String
  let title: String
  let imageURL: String
  let address: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case startDate = "eventstartdate"
    case endDate = "eventenddate"
    case address = "addr1"
    case imageURL = "firstimage"
  }
}

extension TourFestivalResponseDTO {
  func toFestivalThumbnailEntity(imageData: Data) -> FestivalThumbnailEntity {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    let formattedStartDate = dateFormatter.date(from: startDate)
    let formattedEndDate = dateFormatter.date(from: endDate)
    
    return .init(
      title: title,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      imageData: imageData
    )
  }
}

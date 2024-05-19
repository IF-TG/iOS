//
//  TourApiCommonResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourApiResponseDTO<T: Decodable>: Decodable {
  let header: TourApiHeaderResponseDTO
  let body: TourApiBodyResponseDTO<T>
}

struct TourApiHeaderResponseDTO: Decodable {
  let resultCode: String
  let resultMsg: String
}

struct TourApiBodyResponseDTO<T: Decodable>: Decodable {
  let items: TourApiItems<T>?
  let numOfRows: Int
  let pageNo: Int
  let totalCount: Int
  
  enum CodingKeys: CodingKey {
    case items
    case numOfRows
    case pageNo
    case totalCount
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: TourApiBodyResponseDTO<T>.CodingKeys.self)
    
    if let _ = try? container.decode(String.self, forKey: .items) {
      self.items = nil
    } else {
      self.items = try container.decode(TourApiItems.self, forKey: .items)
    }
    
    self.numOfRows = try container.decode(Int.self, forKey: TourApiBodyResponseDTO<T>.CodingKeys.numOfRows)
    self.pageNo = try container.decode(Int.self, forKey: TourApiBodyResponseDTO<T>.CodingKeys.pageNo)
    self.totalCount = try container.decode(Int.self, forKey: TourApiBodyResponseDTO<T>.CodingKeys.totalCount)
  }
}

struct TourApiItems<T: Decodable>: Decodable {
  let item: [T]
}

struct TourApiCommonResponseDTO<T: Decodable>: Decodable {
  let response: TourApiResponseDTO<T>
}

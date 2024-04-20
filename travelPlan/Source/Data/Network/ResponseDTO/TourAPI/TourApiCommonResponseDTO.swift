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
  let items: T
  let numOfRows: Int
  let pageNo: Int
  let totalCount: Int
}

struct TourApiCommonResponseDTO<T: Decodable>: Decodable {
  let response: TourApiResponseDTO<T>
}

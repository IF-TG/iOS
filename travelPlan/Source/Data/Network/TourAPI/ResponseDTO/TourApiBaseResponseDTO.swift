//
//  TourApiBaseResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

protocol TourApiBaseResponseDTO {
  var resultCode: String { get }
  var resultMsg: String { get }
  var numOfRows: Int { get }
  var pageNo: Int { get }
  var totalCount: Int { get }
  }

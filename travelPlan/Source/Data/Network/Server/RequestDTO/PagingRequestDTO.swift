//
//  PagingRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation

struct PagingRequestDTO: Encodable {
  let page: Int?
  let perPage: Int?
}

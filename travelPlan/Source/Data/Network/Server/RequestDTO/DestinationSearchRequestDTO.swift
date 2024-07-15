//
//  DestinationSearchRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation

struct DestinationSearchRequestDTO: Encodable {
  let keyword: String
  let page: Int32?
  let perPage: Int32?
}

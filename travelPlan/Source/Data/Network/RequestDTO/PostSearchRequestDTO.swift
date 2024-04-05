//
//  PostSearchRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/5/24.
//

import Foundation

struct PostSearchRequestDTO: Encodable {
  let keyword: String
  let isTitle: Bool
  let isContent: Bool
  let page: Int32
  let perPage: Int32
}

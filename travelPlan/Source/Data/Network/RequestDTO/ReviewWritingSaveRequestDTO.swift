//
//  ReviewWritingSaveRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/13/24.
//

import Foundation

struct ReviewWritingSaveRequestDTO: Codable {
  let postId: Int64?
  let post: Post
  
  struct Post: Codable {
    let title: String
    let content: String
    let startDate: String
    let endDate: String
    let themes: [String]
    let regions: [TravelRegion]
    let seasons: [Season]
    let partners: [TravelPartner]
  }
}

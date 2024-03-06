//
//  PostEntity.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct PostEntity {
  let liked: Bool
  let sort: Bool
  let post: Post
  let author: Author
}

// MARK: - Nested
extension PostEntity {
  struct Post {
    let postID: Int64
    let title: String
    let thumbnails: [Thumbnail]
    let content: String
    let likes: Int32
    let comments: Int32
    let location: Location
    let createAt: String
    let tripDate: TripDate
  }
  
  struct Thumbnail {
    let imageUri: String
    let sort: Int32
  }
  
  struct Author {
    let profileUri: String
    let nickname: String
  }
  
  struct TripDate {
    let start: String
    let end: String
  }
  
  struct Category {
    let themes: [TravelTheme]
    let regions: [TravelRegion]
    let seasons: [Season]
    let partners: [TravelPartner]
  }
  
  struct Location {
    let x: Double
    let y: Double
  }
}

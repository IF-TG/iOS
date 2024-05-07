//
//  PostEntity.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct Post {
  let liked: Bool?
  let detail: Detail<[PostContent]>
  let author: Author
  let highResolveImages: [PostImage]
  let category: Category
}

// MARK: - Nested
extension Post {
  struct Detail<ContentType> {
    let postID: String
    let title: String
    let content: ContentType
    let likes: Int32
    let comments: Int32
    let location: Location
    let createAt: Date
    let tripDate: TripDate
  }
  
  struct PostImage {
    let imageData: Data?
    let sort: Int32
  }
  
  struct PostContent {
    let sort: Int
    let text: String
  }
  
  struct Author {
    let profileImageData: Data?
    let nickname: String
    var authorId: String?
  }
  
  struct TripDate {
    let startDate: Date
    let endDate: Date
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

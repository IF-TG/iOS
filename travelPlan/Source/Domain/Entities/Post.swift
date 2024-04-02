//
//  PostEntity.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

protocol PostDetailProtocol {
  associatedtype CommentType
  var postID: Int64 { get }
  var title: String { get }
  var postImages: [Post.PostImage] { get }
  var content: String { get }
  var likes: Int32 { get }
  var comments: Int32 { get }
  var location: Post.Location { get }
  var createAt: String { get }
  var tripDate: Post.TripDate { get }
}

struct Post {
  let liked: Bool
  let detail: PostDetail
  let author: Author
}

// MARK: - Nested
extension Post {
  struct PostDetail: PostDetailProtocol {
    typealias CommentType = Int32
    let postID: Int64
    let title: String
    let postImages: [PostImage]
    let content: String
    let likes: Int32
    let comments: CommentType
    let location: Location
    let createAt: String
    let tripDate: TripDate
  }
  
  struct PostImage {
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

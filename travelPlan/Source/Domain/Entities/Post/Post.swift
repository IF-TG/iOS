//
//  PostEntity.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

public struct Post {
  public var liked: Bool?
  public var detail: Detail<[PostContent]>
  public let author: Author
  public let highResolveImages: [PostImage]
  public let category: Category
  
  public init(
    liked: Bool?,
    detail: Detail<[PostContent]>,
    author: Author,
    highResolveImages: [PostImage],
    category: Category
  ) {
    self.liked = liked
    self.detail = detail
    self.author = author
    self.highResolveImages = highResolveImages
    self.category = category
  }
  
  public init(
    liked: Bool,
    atomicPost: AtomicPost,
    postAuthor: Post.Author
  ) {
    self.liked = liked
    self.detail = atomicPost.detail
    self.author = postAuthor
    self.highResolveImages = atomicPost.highResolveImages
    self.category = atomicPost.category
  }
}

// MARK: - Nested
extension Post {
  public struct Detail<ContentType> {
    let postID: PostIdentifier
    let title: String
    let content: ContentType
    var likes: Int32
    var comments: Int32
    let location: Location
    let createAt: Date
    let tripDate: TripDate
  }
  
  public struct PostImage {
    let imageData: Data?
    let sort: Int32
  }
  
  public struct PostContent {
    let sort: Int
    let text: String
  }
  
  public struct Author {
    let profileImageData: Data?
    let nickname: String
    var authorId: UserIdentifier
  }
  
  public struct TripDate {
    let startDate: Date
    let endDate: Date
  }
  
  public struct Category {
    let themes: [TravelTheme]
    let regions: [TravelRegion]
    let seasons: [Season]
    let partners: [TravelPartner]
  }
  
  public struct Location {
    let x: Double
    let y: Double
  }
}

extension Post.PostContent: Equatable {
  public static func == (lhs: Post.PostContent, rhs: Post.PostContent) -> Bool {
    return lhs.sort == rhs.sort && lhs.text == rhs.text
  }
}

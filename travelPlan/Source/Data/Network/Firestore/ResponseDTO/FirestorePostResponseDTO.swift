//
//  FirestorePostResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/30/24.
//

import Foundation
import FirebaseFirestore

struct FirestorePostResponseDTO: Decodable {
  let authorId: String
  let postId: String

  let startDate: String
  let endDate: String
  
  let title: String
  let content: [FirestorePostContentResponseDTO]
  let postImageFiles: [FirestorePostImageFileResponseDTO]
  
  let createAt: Timestamp
  let likes: Int
  
  let mapX: Double
  let mapY: Double
  
  let themes: [String]
  let regions: [String]
  let seasons: [String]
  let partners: [String]
  
  enum CodingKeys: String, CodingKey {
    case authorId
    case postId
    case startDate
    case endDate
    case title
    case content
    case postImageFiles = "imgFileList"
    case createAt
    case likes = "likeNum"
    case mapX
    case mapY
    case themes
    case regions
    case seasons
    case partners = "companions"
  }
}

struct FirestorePostContentResponseDTO: Decodable {
  let sort: Int
  let text: String
}

struct FirestorePostImageFileResponseDTO: Decodable {
  let sort: Int
  let url: String
  let imageType: String
  let thumbnail: Bool
  
  enum CodingKeys: String, CodingKey {
    case sort
    case url = "img"
    case imageType
    case thumbnail
  }
}

//
//  TourRetrievedImageEntity.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

struct TourRetrievedImageEntity<ImageType> {
  let contentId: String
  let image: ImageType
  let copyright: TourRetrievedImageCopyrightEntity
}

struct TourRetrievedImageCopyrightEntity {
  let divisionCode: String
  let serialNumber: String
}

struct TourRetrievedAtomicImageEntity {
  let name: String
  let originalUrl: String
  let thumbnailUrl: String
}

struct TourRetrievedDataImageEntity {
  let name: String
  let original: Data
  let thumbnail: Data
}


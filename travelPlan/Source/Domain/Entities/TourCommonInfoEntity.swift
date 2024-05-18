//
//  TourDestinationDetailCommonEntity.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourCommonInfoEntity {
  let id: Id
  let address: addressInfo
  let contact: ContactInfo
  let coordinate: Coordinate
  let image: ImageInfo
  let overview: String
  let title: String
}

extension TourCommonInfoEntity {
  /// **기본 정보 조회**
  struct Id {
    let contentId: Int
    let contentTypeId: Int
  }
  
  /// **좌표 정보 조회**
  struct Coordinate {
    let mapX: String
    let mapY: String
  }
  
  /// **컨텐츠 연락 정보**
  struct ContactInfo {
    let telNumber: String
    let telName: String
  }
  
  /// **주소 정보 조회**
  struct addressInfo {
    let address1: String
    /// 상세 주소
    let address2: String
  }
  
  /// **이미지 정보 조회**
  struct ImageInfo {
    let originalImageData: Data?
    let thumbnailImageData: Data?
  }
}

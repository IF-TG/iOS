//
//  DestinationEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 7/25/24.
//

import Foundation

struct DestinationEntity {
  let destinationId: DestinationIdEntity
  let title: String
  let address: DestinationAddress
  let map: DestinationCoordinate<Double>
  let overview: String
  let category: DestinationCategory
  let zipcode: String
  let imageDatas: [Data?]
  let detail: DestinationEntity.Detail
  let isScraped: Bool
  let liked: Bool
  var likeCount: Int
  let tel: String
  
  @frozen enum Detail {
    case cultureFacility(CultureFacilityDetail)
    case attraction(AttractionDetail)
    case leports(LeportsDetail)
    case restaurant(RestaurantDetail)
    case shopping(ShoppingDetail)
    case festival(FestivalDetail)
  }
  
  struct CultureFacilityDetail {
    let capacity: String // 수용 인원
    let checkBabyStroller: String? // 유모차 대여 정보
    let checkPet: String?
    let discountInfo: String?
    let parking: String?
    let parkingFee: String?
    let scale: String
    let spendTime: String
    let usageFee: String?
    let usageTime: String?
  }
  
  struct AttractionDetail {
    let capacity: String
    let checkBabyStroller: String?
    let checkPet: String?
    let experienceGuide: String?
    let openDate: String?
    let restDate: String?
    let usageTime: String?
  }
  
  struct LeportsDetail {
    let capacity: String
    let checkBabyStroller: String?
    let checkPet: String?
    let openPeriod: String?
    let parking: String?
    let parkingFee: String?
    let recommendedAge: String?
    let usageFee: String?
    let usageTime: String?
  }
  
  struct RestaurantDetail {
    let featureMenu: String?
    let openDate: String
    let openTime: String?
    let packing: String?
    let parking: String?
    let restDate: String?
    let scale: String
    let seat: String
    let treatMenu: String?
  }
  
  struct ShoppingDetail {
    let checkBabyStroller: String?
    let checkPet: String?
    let fairDate: String?
    let openDate: String?
    let openTime: String?
    let restDate: String?
    let saleItem: String
    let scale: String
  }
  
  struct FestivalDetail {
    let ageLimit: String?
    let startDate: Date? // yyyy.MM.dd
    let endDate: Date? // yyyy.MM.dd
    let eventPlace: String?
    let program: String?
    let showTime: String?
    let spendTime: String
    let sponsor: String
    let usageFee: String?
  }
}

//
//  DestinationResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/25/24.
//

import Foundation

struct DestinationResponseDTO: Decodable {
  let destination: DestinationResponseDTO.Destination
  let detail: DestinationResponseDTO.Detail
  let liked: Bool
  let likeCount: Int
  
  enum CodingKeys: CodingKey {
    case destination
    case detail
    case liked
    case likeCount
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.destination = try container.decode(Destination.self, forKey: .destination)
    self.liked = try container.decode(Bool.self, forKey: .liked)
    self.likeCount = try container.decode(Int.self, forKey: .likeCount)
    
    switch destination.contentTypeId {
    case TourType.attraction.rawValue:
      self.detail = .attraction(
        try container.decode(Detail.AttractionResponseDTO.self, forKey: .detail)
      )
    case TourType.cultureFacility.rawValue:
      self.detail = .cultureFacility(
        try container.decode(Detail.CultureFacilityResponseDTO.self, forKey: .detail)
      )
    case TourType.festival.rawValue:
      self.detail = .festival(
        try container.decode(Detail.FestivalResponseDTO.self, forKey: .detail)
      )
    case TourType.leports.rawValue:
      self.detail = .leports(
        try container.decode(Detail.LeportsResponseDTO.self, forKey: .detail)
      )
    case TourType.shopping.rawValue:
      self.detail = .shopping(
        try container.decode(Detail.ShoppingResponseDTO.self, forKey: .detail)
      )
    case TourType.restaurant.rawValue:
      self.detail = .restaurant(
        try container.decode(Detail.RestaurantResponseDTO.self, forKey: .detail)
      )
    default:
      throw ConnectionError.missingRequiredData
    }
  }
}

// MARK: - DestinationResponseDTO's Nested
extension DestinationResponseDTO {
  struct Destination: Decodable {
    let id: Int
    let contentTypeId: Int
    let title: String
    let address: String
    let addressDetail: String
    let mapX: Double
    let mapY: Double
    let overview: String
    let tel: String
    let category: Category
    let zipCode: String
    let thumbnail: String
    let scraped: Bool
    
    enum CodingKeys: String, CodingKey {
      case id
      case contentTypeId
      case title
      case address
      case addressDetail
      case mapX
      case mapY
      case overview
      case tel
      case category
      case zipCode = "zipcode"
      case thumbnail
      case scraped
    }

    struct Category: Decodable {
      let largeCategory: String
      let middleCategory: String
      let smallCategory: String
    }
  }
  
  enum Detail {
    case cultureFacility(CultureFacilityResponseDTO)
    case attraction(AttractionResponseDTO)
    case leports(LeportsResponseDTO)
    case restaurant(RestaurantResponseDTO)
    case shopping(ShoppingResponseDTO)
    case festival(FestivalResponseDTO)
  }
}

// MARK: - DestinationResponseDTO.Detail's Nested
extension DestinationResponseDTO.Detail {
  /// 문화 시설
  struct CultureFacilityResponseDTO: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
      case capacity
      case checkBabyStroller
      case checkPet
      case discountInfo
      case parking
      case parkingFee = "parkingfee"
      case scale
      case spendTime
      case usageFee
      case usageTime
    }
  }
  
  /// 관광지
  struct AttractionResponseDTO: Decodable {
    let capacity: String
    let checkBabyStroller: String?
    let checkPet: String?
    let experienceGuide: String?
    let openDate: String?
    let restDate: String?
    let usageTime: String?
  }
  
  /// 레포츠
  struct LeportsResponseDTO: Decodable {
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
  
  /// 식당
  struct RestaurantResponseDTO: Decodable {
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
  
  /// 쇼핑
  struct ShoppingResponseDTO: Decodable {
    let checkBabyStroller: String?
    let checkPet: String?
    let fairDate: String?
    let openDate: String?
    let openTime: String?
    let restDate: String?
    let saleItem: String
    let scale: String
  }
  
  /// 페스티벌
  struct FestivalResponseDTO: Decodable {
    let ageLimit: String?
    let startDate: String? // yyyy.MM.dd
    let endDate: String? // yyyy.MM.dd
    let eventPlace: String?
    let program: String?
    let showTime: String?
    let spendTime: String
    let sponsor: String
    let usageFee: String?
    
    enum CodingKeys: String, CodingKey {
      case ageLimit
      case startDate
      case endDate
      case eventPlace
      case program
      case showTime = "showtime"
      case spendTime
      case sponsor
      case usageFee
    }
  }
}

// MARK: - Mappings to Domain
extension DestinationResponseDTO.Destination.Category {
  func toDomain() -> DestinationCategory {
    return .init(large: largeCategory, middle: middleCategory, small: smallCategory)
  }
}

extension DestinationResponseDTO.Detail {
  func toDomain() -> DestinationEntity.Detail {
    switch self {
    case .attraction(let responseDTO):
      return .attraction(makeAttractionDetail(responseDTO: responseDTO))
    case .cultureFacility(let responseDTO):
      return .cultureFacility(makeCultureFacilityDetail(responseDTO: responseDTO))
    case .festival(let responseDTO):
      return .festival(makeFestivalDetail(responseDTO: responseDTO))
    case .leports(let responseDTO):
      return .leports(makeLeportsDetail(responseDTO: responseDTO))
    case .restaurant(let responseDTO):
      return .restaurant(makeRestaurantDetail(responseDTO: responseDTO))
    case .shopping(let responseDTO):
      return .shopping(makeShoppingDetail(responseDTO: responseDTO))
    }
  }
  
  private func makeAttractionDetail(
    responseDTO: DestinationResponseDTO.Detail.AttractionResponseDTO
  ) -> DestinationEntity.AttractionDetail {
    return .init(
      capacity: responseDTO.capacity,
      checkBabyStroller: responseDTO.checkBabyStroller,
      checkPet: responseDTO.checkPet,
      experienceGuide: responseDTO.experienceGuide,
      openDate: responseDTO.openDate,
      restDate: responseDTO.restDate,
      usageTime: responseDTO.usageTime
    )
  }
  
  private func makeCultureFacilityDetail(
    responseDTO: DestinationResponseDTO.Detail.CultureFacilityResponseDTO
  ) -> DestinationEntity.CultureFacilityDetail {
    return .init(
      capacity: responseDTO.capacity,
      checkBabyStroller: responseDTO.checkBabyStroller,
      checkPet: responseDTO.checkPet,
      discountInfo: responseDTO.discountInfo,
      parking: responseDTO.parking,
      parkingFee: responseDTO.parkingFee,
      scale: responseDTO.scale,
      spendTime: responseDTO.spendTime,
      usageFee: responseDTO.usageFee,
      usageTime: responseDTO.usageTime
    )
  }
  
  private func makeFestivalDetail(
    responseDTO: DestinationResponseDTO.Detail.FestivalResponseDTO
  ) -> DestinationEntity.FestivalDetail {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    
    if let endDateString = responseDTO.endDate, let startDateString = responseDTO.startDate {
      let endDate = formatter.date(from: endDateString)
      let startDate = formatter.date(from: startDateString)
      
      return DestinationEntity.FestivalDetail(
        ageLimit: responseDTO.ageLimit,
        startDate: startDate,
        endDate: endDate,
        eventPlace: responseDTO.eventPlace,
        program: responseDTO.program,
        showTime: responseDTO.showTime,
        spendTime: responseDTO.spendTime,
        sponsor: responseDTO.sponsor,
        usageFee: responseDTO.usageFee
      )
    } else {
      return DestinationEntity.FestivalDetail(
        ageLimit: responseDTO.ageLimit,
        startDate: nil,
        endDate: nil,
        eventPlace: responseDTO.eventPlace,
        program: responseDTO.program,
        showTime: responseDTO.showTime,
        spendTime: responseDTO.spendTime,
        sponsor: responseDTO.sponsor,
        usageFee: responseDTO.usageFee
      )
    }
  }
  
  private func makeLeportsDetail(
    responseDTO: DestinationResponseDTO.Detail.LeportsResponseDTO
  ) -> DestinationEntity.LeportsDetail {
    return .init(
      capacity: responseDTO.capacity,
      checkBabyStroller: responseDTO.checkBabyStroller,
      checkPet: responseDTO.checkPet,
      openPeriod: responseDTO.openPeriod,
      parking: responseDTO.parking,
      parkingFee: responseDTO.parkingFee,
      recommendedAge: responseDTO.recommendedAge,
      usageFee: responseDTO.usageFee,
      usageTime: responseDTO.usageTime
    )
  }
  
  private func makeRestaurantDetail(
    responseDTO: DestinationResponseDTO.Detail.RestaurantResponseDTO
  ) -> DestinationEntity.RestaurantDetail {
    return .init(
      featureMenu: responseDTO.featureMenu,
      openDate: responseDTO.openDate,
      openTime: responseDTO.openTime,
      packing: responseDTO.packing,
      parking: responseDTO.parking,
      restDate: responseDTO.restDate,
      scale: responseDTO.scale,
      seat: responseDTO.seat,
      treatMenu: responseDTO.treatMenu
    )
  }
  
  private func makeShoppingDetail(
    responseDTO: DestinationResponseDTO.Detail.ShoppingResponseDTO
  ) -> DestinationEntity.ShoppingDetail {
    return .init(
      checkBabyStroller: responseDTO.checkBabyStroller,
      checkPet: responseDTO.checkPet,
      fairDate: responseDTO.fairDate,
      openDate: responseDTO.openDate,
      openTime: responseDTO.openTime,
      restDate: responseDTO.restDate,
      saleItem: responseDTO.saleItem,
      scale: responseDTO.scale
    )
  }
}

extension DestinationResponseDTO {
  func toDomain() -> DestinationEntity {
    return DestinationEntity(
      destinationId: .init(
        id: destination.id,
        contentTypeId: destination.contentTypeId
      ),
      title: destination.title,
      address: .init(
        address1: destination.address,
        address2: destination.addressDetail
      ),
      map: .init(
        mapX: destination.mapX,
        mapY: destination.mapY
      ),
      overview: destination.overview,
      category: destination.category.toDomain(),
      zipcode: destination.zipCode,
      imageData: Data(base64Encoded: destination.thumbnail),
      detail: detail.toDomain(),
      isScraped: destination.scraped,
      liked: liked,
      likeCount: likeCount,
      tel: destination.tel
    )
  }
}

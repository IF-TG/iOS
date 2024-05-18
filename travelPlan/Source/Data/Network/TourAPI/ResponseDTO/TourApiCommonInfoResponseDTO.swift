//
//  TourApiDetailCommonResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourApiCommonInfoResponseDTO: Decodable {
  /// **기본 정보 조화**
  let contentid: Int
  let contenttypeid: Int
  let title: String
  let tel: String
  let telname: String
  
  /// **주소 정보 조회**
  let addr1: String
  /// 상세 주소
  let addr2: String
  
  /// **좌표 정보 조회**
  let mapx: String
  let mapy: String
  
  /// 원본
  let firstimage: String
  /// 섬네일
  let firstimage2: String
  
  let overview: String
  
  enum CodingKeys: CodingKey {
    case contentid
    case contenttypeid
    case title
    case tel
    case telname
    case addr1
    case addr2
    case mapx
    case mapy
    case firstimage
    case firstimage2
    case overview
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let contentIdString = try container.decode(String.self, forKey: .contentid)
    let contentTypeIdString = try container.decode(String.self, forKey: .contenttypeid)
    
    guard let contentId = Int(contentIdString),
          let contentTypeId = Int(contentTypeIdString)
    else { throw TransformationError.stringToInt }
    
    self.contentid = contentId
    self.contenttypeid = contentTypeId
    
    self.title = try container.decode(String.self, forKey: .title)
    self.tel = try container.decode(String.self, forKey: .tel)
    self.telname = try container.decode(String.self, forKey: .telname)
    self.addr1 = try container.decode(String.self, forKey: .addr1)
    self.addr2 = try container.decode(String.self, forKey: .addr2)
    self.mapx = try container.decode(String.self, forKey: .mapx)
    self.mapy = try container.decode(String.self, forKey: .mapy)
    self.firstimage = try container.decode(String.self, forKey: .firstimage)
    self.firstimage2 = try container.decode(String.self, forKey: .firstimage2)
    self.overview = try container.decode(String.self, forKey: .overview)
  }
}

// MARK: - Mappings to Domain
extension TourApiCommonInfoResponseDTO {
  func toDomain(firstImageData: Data?, thumbnailImageDate: Data?) -> TourCommonInfoEntity {
    .init(
      id: .init(contentId: contentid, contentTypeId: contenttypeid),
      address: .init(address1: addr1, address2: addr2),
      contact: .init(telNumber: tel, telName: telname),
      coordinate: .init(mapX: mapx, mapY: mapy),
      image: .init(originalImageData: firstImageData, thumbnailImageData: thumbnailImageDate),
      overview: overview,
      title: title)
  }
}

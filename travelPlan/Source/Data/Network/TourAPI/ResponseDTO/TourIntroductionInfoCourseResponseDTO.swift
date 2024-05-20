//
//  TourIntroductionInfoCourseResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/18/24.
//

import Foundation

struct TourIntroductionInfoCourseResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let telNumber: String
  let distance: String
  let requiredTime: String
  
  private enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case telNumber = "infocentertourcourse"
    case distance = "distance"
    case requiredTime = "taketime"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let contentIdString = try container.decode(String.self, forKey: .contentId)
    let contentTypeIdString = try container.decode(String.self, forKey: .contentTypeId)
    
    guard let contentId = Int(contentIdString),
          let contentTypeId = Int(contentTypeIdString)
    else { throw TransformationError.stringToInt }
    
    self.contentId = contentId
    self.contentTypeId = contentTypeId
    self.telNumber = try container.decode(String.self, forKey: .telNumber)
    self.distance = try container.decode(String.self, forKey: .distance)
    self.requiredTime = try container.decode(String.self, forKey: .requiredTime)
  }
}

// MARK: - Mappings to Domain
extension TourIntroductionInfoCourseResponseDTO {
  func toDomain() -> IntroductionInfoCourseEntity {
    return IntroductionInfoCourseEntity(
      tourContentId: TourContentId(contentId: contentId, contentTypeId: contentTypeId),
      distance: distance,
      telNumber: telNumber,
      requiredTime: requiredTime
    )
  }
}

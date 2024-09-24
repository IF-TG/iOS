//
//  ReviewWritingSaveRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/13/24.
//

import Foundation

struct ReviewWritingSaveRequestDTO: Encodable {
  let title: String
  let content: String
  let startDate: String
  let endDate: String
  let themes: [String]
  let regions: [String]
  let seasons: [String]
  let companions: [String]
  var imgFileList: [ImageFileListDTO]
  let mapX: Double
  let mapY: Double
}

extension ReviewWritingSaveRequestDTO {
  struct ImageFileListDTO: Encodable {
    let sort: Int
    let imageType: String
    let thumbnail: Bool
    var img: String
  }
}

extension ReviewWritingSaveRequestDTO {
  static func makeRequestDTO(entity: ReviewWritingEntity) -> Self {
    var textContent = ""
    var countForTextAndImage = 0
    var imageCount = 0
    var imageDTOList = [ImageFileListDTO]()
    
    entity.contents.forEach { content in
      switch content {
      case .text(let textString):
        countForTextAndImage += 1
        textContent += textString
      case .image(let imageData):
        textContent += UUID().uuidString
        countForTextAndImage += 1
        imageCount += 1
        let isThumbnail = imageCount == 1 ? true : false
        imageDTOList.append(ImageFileListDTO(
          sort: countForTextAndImage,
          imageType: "jpeg",
          thumbnail: isThumbnail,
          img: imageData.base64EncodedString()
        ))
      }
    }
    
    return ReviewWritingSaveRequestDTO(
      title: entity.title, 
      content: textContent,
      startDate: DateTimeConverter.toString(from: entity.tripDate.startDate),
      endDate: DateTimeConverter.toString(from: entity.tripDate.endDate),
      themes: entity.category.themes.map { TravelThemeMapper.toDTO($0) },
      regions: entity.category.regions.map { TravelRegionMapper.toDTO($0) },
      seasons: entity.category.seasons.map { SeasonMapper.toDTO($0) },
      companions: entity.category.partners.map { TravelPartnerMapper.toDTO($0) },
      imgFileList: imageDTOList,
      mapX: entity.mapX,
      mapY: entity.mapY
    )
  }
}

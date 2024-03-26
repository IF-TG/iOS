//
//  PostsRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Foundation

struct PostsRequestDTO: Encodable {
  let page: Int32
  let perPage: Int32
  let orderMethod: String
  let mainCategory: String
  let subCategory: String?
  let userId: Int64
}

// MARK: - Helpers
extension PostsRequestDTO {
  static func makeRequestDTO(page: Int32, perPage: Int32, category: PostCategory, userId: Int64) -> Self {
    let orderByRequestDTO = TravelOrderTypeMapper.toDTO(category.orderBy)
    let mainCategoryRequestDTO = TravelMainThemeTypeMapper.toMainCategoryDTO(category.mainTheme)
    let subCategoryRequestDTO = TravelMainThemeTypeMapper.toSubCategoryDTO(category.mainTheme)
    return .init(
      page: page,
      perPage: perPage,
      orderMethod: orderByRequestDTO,
      mainCategory: mainCategoryRequestDTO,
      subCategory: subCategoryRequestDTO,
      userId: userId)
  }
}

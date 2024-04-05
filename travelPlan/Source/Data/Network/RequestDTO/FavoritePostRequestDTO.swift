//
//  FavoritePostRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import Foundation

struct FavoritePostRequestDTO: Encodable {
  let folderName: String
  let page: Int32
  let perPage: Int32
}

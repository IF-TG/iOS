//
//  FavoritePostDirectoryNameUpdateRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/5/24.
//

import Foundation

struct FavoritePostDirectoryNameUpdateRequestDTO: Encodable {
  let postIdList: [Int64]
  let folderName: String
}

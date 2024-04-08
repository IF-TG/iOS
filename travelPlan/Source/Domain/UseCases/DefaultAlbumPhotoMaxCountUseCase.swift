//
//  DefaultAlbumPhotoMaxCountUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/8/24.
//

import Foundation

struct DefaultAlbumPhotoMaxCountUseCase: AlbumPhotoMaxCountUseCase {
  // MARK: - Properties
  var selectMaxCount: Int {
    return 20
  }
}

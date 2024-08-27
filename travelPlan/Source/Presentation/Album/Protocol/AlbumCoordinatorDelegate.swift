//
//  AlbumCoordinatorDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 8/24/24.
//

import Foundation

protocol AlbumCoordinatorDelegate: AnyObject {
  /// AlbumPhotoDetailCoordinator의 finish 호출을 AlbumCoordinator에게 알리는 메소드입니다.
  func reloadDataByAlbumPhotoDetail()
}

//
//  AlbumUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Combine

protocol AlbumUseCase {
  func getAlbums(mediaType: MediaType) -> AnyPublisher<[AlbumInfo], Never>
}

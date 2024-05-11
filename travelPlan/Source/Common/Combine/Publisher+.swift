//
//  Publisher+.swift
//  travelPlan
//
//  Created by SeokHyun on 5/11/24.
//

import Foundation
import Combine

extension Publisher {
  func tryMapTourAPIError<T>() -> Publishers.TryMap<Self, T>
  where Output == TourApiCommonResponseDTO<T>,
          T: Decodable,
          Failure == Error {
    return tryMap {
      let resultCode = $0.response.header.resultCode
      
      guard resultCode == "0000" else {
        throw TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2))))
      }
      guard let item = $0.response.body.items.item.first else {
        throw TourAPIError.tourAPIProviderInstitutionError(.noDataError)
      }
      return item
    }
  }
}

//
//  TourRepositoryAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/12/24.
//

import Alamofire
import Swinject
import Foundation

final class TourRepositoryAssembly: Assembly {
  func assemble(container: Swinject.Container) {
    // MARK: - Common Tour API
    container.register(Sessionable.self) { r in
      let session = r.resolve(Session.self)!
      return TourApiSessionProvider(session: session)
    }
    
    container.register(Sessionable.self, name: .intercept) { r in
      let mockSession = r.resolve(Session.self, name: .intercept)!
      return TourApiSessionProvider(session: mockSession)
    }
    
    // TODO: - Tour Api Repository
    
  }
}

//
//  CoreAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject
import Alamofire

final class CoreAssembly: Swinject.Assembly {
  func assemble(container: Swinject.Container) {
    // MARK: - BackgroundTaskManager
    container.register(BackgroundTaskManager.self) { _ in
      BackgroundTaskManager.shared
    }
    
    // MARK: - XMLParser
    container.register(XMLParsingServiceProtocol.self) { (_, parser: XMLParser) in
      XMLParsingService(parser: parser)
    }
    
    // MARK: - FirebaseStorageService
    container.register(ImageStorageServiceProtocol.self, name: .firebase) { _ in
      FirebaseStorageService()
    }
    
    // MARK: - Authentication
    // TODO: - Authentication 디렉터리 내부 객체들 container에 register해야합니다.
    container.register(LoginStrategy.self, name: "googleWithFiresthre") { _ in
      GoogleLoginStrategyWithFirebase()
    }
    
    container.register(LoginStrategy.self, name: "apple") { _ in
      AppleLoginStrategy()
    }
    
    // MARK: - ImageIO
    container.register(ImageIO.self) { _ in
      ImageIO()
    }
    
    // MARK: - Cache
    container.register(ImageMemoryCachable.self) { _ in
      ImageMemoryCache()
    }
    
    container.register(ImageDiskCache.self) { _ in
      ImageDiskCache()
    }
    
    // MARK: - Network
    /// Session
    container.register(Session.self) { _ in
      Session()
    }
    
    container.register(Sessionable.self) { r in
      let session = r.resolve(Session.self)!
      return SessionProvider(session: session)
    }
    
    container.register(ImageSessionable.self) { r in
      let session = r.resolve(Session.self)!
      return ImageSessionProvider(session: session)
    }
  }
}

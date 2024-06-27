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
  // swiftlint:disable:next function_body_length
  func assemble(container: Swinject.Container) {
    // MARK: - BackgroundTaskManager
    container.register(BackgroundTaskManager.self, name: .implementation(.default)) { _ in
      BackgroundTaskManager.shared
    }
    
    // MARK: - XMLParser
    container.register(XMLParsingServiceProtocol.self, name: .implementation(.default)) { (_, parser: XMLParser) in
      XMLParsingService(parser: parser)
    }
    
    // MARK: - FirebaseStorageService
    container.register(ImageStorageServiceProtocol.self, name: .implementation(.firestore)) { _ in
      FirebaseStorageService()
    }
    
    // MARK: - Authentication
    // TODO: - Authentication 디렉터리 내부 객체들 container에 register해야합니다.
    container.register(LoginStrategy.self, name: "googleWithFiresthre") { _ in
      GoogleLoginStrategyWithFirebase()
    }
    
    container.register(AuthenticationService.self, name: .implementation(.default)) { r in
      let session = r.resolve(Sessionable.self, name: .implementation(.interceptedDefault))!
      return DefaultAuthenticationService(sessionProvider: session)
    }
    
    // MARK: - ImageIO
    container.register(ImageIO.self, name: .implementation(.default)) { _ in
      ImageIO()
    }
    
    // MARK: - Cache
    container.register(ImageMemoryCachable.self, name: .implementation(.default)) { _ in
      ImageMemoryCache()
    }
    
    container.register(ImageDiskCache.self, name: .implementation(.default)) { _ in
      ImageDiskCache()
    }
    
    // MARK: - Network
    /// Session
    container.register(Session.self, name: .implementation(.default)) { _ in
      Session()
    }
    
    container.register(Session.self, name: .implementation(.interceptedDefault)) { _ in
      MockSession.default
    }
    
    container.register(Sessionable.self, name: .implementation(.default)) { r in
      let session = r.resolve(Session.self, name: .implementation(.default))!
      return SessionProvider(session: session)
    }
    
    /// Mock 객체를 주입받은 구현체를 testDuble == mock 으로 지정합니다.
    /// 그러나 MockSession을 활용할 경우 implementation(.interceptedDefault)로 이름을 지정합니다.
    container.register(Sessionable.self, name: .implementation(.interceptedDefault)) { r in
      let mockSession = r.resolve(Session.self, name: .implementation(.interceptedDefault))!
      return SessionProvider(session: mockSession)
    }
    
    container.register(ImageSessionable.self, name: .implementation(.default)) { r in
      let session = r.resolve(Session.self, name: .implementation(.default))!
      return ImageSessionProvider(session: session)
    }
    
    container.register(ImageSessionable.self, name: .implementation(.interceptedDefault)) { r in
      let mockSession = r.resolve(Session.self, name: .testDouble(.mock))!
      return ImageSessionProvider(session: mockSession)
    }
  }
}

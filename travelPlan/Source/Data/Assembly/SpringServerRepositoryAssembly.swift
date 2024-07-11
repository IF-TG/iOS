//
//  SpringServerRepository.swift
//  travelPlan
//
//  Created by 양승현 on 6/12/24.
//

import Swinject
import Foundation
import SHFirestoreService

final class SpringServerRepositoryAssembly: Assembly {
  func assemble(container: Swinject.Container) {
    // MARK: - Session
    let defaultSession = container.resolve(Sessionable.self)!
    let mockSession = container.resolve(Sessionable.self, name: .intercept)!
    
    // MARK: - LoginRepository
    container.register(LoginRepository.self) { r in
      let authenticationService = r.resolve(AuthenticationService.self)!
      let loginResultStorage = r.resolve(LoginResultStorage.self)!
      let loggedInUserRepository = r.resolve(LoggedInUserRepository.self)!
      let userProfileRepository = r.resolve(UserProfileRepository.self)!
      let firestoreService = r.resolve(FirestoreServiceProtocol.self, name: .firebase)!
      
      return DefaultLoginRepository(
        authService: authenticationService,
        loginResultStorage: loginResultStorage,
        loggedInUserRepository: loggedInUserRepository,
        userProfileRepository: userProfileRepository,
        firestoreService: firestoreService
      )
    }
    
    // TODO: - SpringServer User
    
    // MARK: - Owner Repository
    container.register(LoggedInUserRepository.self) { _ in
      return DefaultLoggedInUserRepository(storage: Dependency())
    }
    
    // TODO: - UserProfile
    // TODO: - UserProfileSetting
    
    // MARK: UserBlockRepgository
    container.register(UserBlockRepository.self) { _ in
      return DefaultUserBlockRepository(service: defaultSession)
    }
    
    container.register(UserBlockRepository.self, name: .intercept) { _ in
      return DefaultUserBlockRepository(service: mockSession)
    }
    
    // MARK: - Post
    container.register(PostRepository.self) { r in
      let defaultOwnerStorage = r.resolve(OwnerStorage.self)!
      let defaultSessionProvider = r.resolve(Sessionable.self)!
      return DefaultPostRepository(service: defaultSessionProvider, ownerStorage: defaultOwnerStorage)
    }
    
    container.register(PostRepository.self, name: .intercept) { r in
      let stubOwnerStorage = StubOwnerStorage()
      let mockSessionProvider = r.resolve(Sessionable.self, name: .intercept)!
      return DefaultPostRepository(service: mockSessionProvider, ownerStorage: stubOwnerStorage)
    }
    
    // MARK: - PostComment
    container.register(PostCommentRepository.self) { _ in
      return DefaultPostCommentRepository(service: defaultSession)
    }
    
    // MARK: - PostNestedComment
    container.register(PostNestedCommentRepository.self) { _ in
      return DefaultPostNestedCommentRepository(service: defaultSession)
    }
    
    container.register(PostNestedCommentRepository.self, name: .intercept) { _ in
      return MockPostNestedCommentRepository()
    }
    
    // TODO: - ReviewWriting
    
    // MARK: - whatsNewNotification
    container.register(WhatsNewNotificationRepository.self) { _ in
      return DefaultWhatsNewNotificationRepository(service: defaultSession)
    }
    
    container.register(WhatsNewNotificationRepository.self, name: .intercept) { _ in
      return InterceptedWhatsNewNotificationRepository()
    }
  }
}

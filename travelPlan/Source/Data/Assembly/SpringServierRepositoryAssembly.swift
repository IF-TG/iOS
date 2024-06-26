//
//  SpringServierRepository.swift
//  travelPlan
//
//  Created by 양승현 on 6/12/24.
//

import Swinject
import Foundation

final class SpringServierRepositoryAssembly: Assembly {
  func assemble(container: Swinject.Container) {
    // MARK: - Session
    let defaultSession = container.resolve(Sessionable.self, name: .implementation(.default))!
    let mockSession = container.resolve(Sessionable.self, name: .implementation(.interceptedDefault))!
    
    // MARK: - Owner Repository
    container.register(LoggedInUserRepository.self, name: .implementation(.default)) { _ in
      return DefaultLoggedInUserRepository(storage: Dependency(name: .implementation(.default)))
    }
    
    container.register(LoggedInUserRepository.self, name: .testDouble(.stub)) { _ in
      return DefaultLoggedInUserRepository(storage: Dependency(name: .testDouble(.stub)))
    }
    
    // TODO: - UserProfile
    // TODO: - UserProfileSetting
    
    // MARK: UserBlockRepgository
    container.register(UserBlockRepository.self, name: .implementation(.default)) { _ in
      return DefaultUserBlockRepository(service: defaultSession)
    }
    
    container.register(UserBlockRepository.self, name: .implementation(.interceptedDefault)) { _ in
      return DefaultUserBlockRepository(service: mockSession)
    }
    
    container.register(UserBlockRepository.self, name: .testDouble(.mock)) { _ in
      return MockWrappedUserBlockRepository()
    }
    
    // MARK: - Post
    container.register(PostRepository.self, name: .implementation(.default)) { r in
      let defaultOwnerStorage = r.resolve(OwnerStorage.self, name: .implementation(.default))!
      let defaultSessionProvider = r.resolve(Sessionable.self, name: .implementation(.default))!
      return DefaultPostRepository(service: defaultSessionProvider, ownerStorage: defaultOwnerStorage)
    }
    
    container.register(PostRepository.self, name: .implementation(.interceptedDefault)) { r in
      let stubOwnerStorage = r.resolve(OwnerStorage.self, name: .testDouble(.stub))!
      let mockSessionProvider = r.resolve(Sessionable.self, name: .testDouble(.mock))!
      return DefaultPostRepository(service: mockSessionProvider, ownerStorage: stubOwnerStorage)
    }
    
    container.register(PostRepository.self, name: .testDouble(.mock)) { _ in
      return MockPostRepository()
    }
    
    // MARK: - PostComment
    container.register(PostCommentRepository.self, name: .implementation(.default)) { _ in
      return DefaultPostCommentRepository(service: defaultSession)
    }
    
    container.register(PostCommentRepository.self, name: .implementation(.interceptedDefault)) { _ in
      return MockPostCommentRepository()
    }
    
    // MARK: - PostNestedComment
    container.register(PostNestedCommentRepository.self, name: .implementation(.default)) { _ in
      return DefaultPostNestedCommentRepository(service: defaultSession)
    }
    
    container.register(PostNestedCommentRepository.self, name: .implementation(.interceptedDefault)) { _ in
      return MockPostNestedCommentRepository()
    }
    
    // TODO: - ReviewWriting
    
    // MARK: - whatsNewNotification
    container.register(WhatsNewNotificationRepository.self, name: .implementation(.default)) { _ in
      return DefaultWhatsNewNotificationRepository(service: defaultSession)
    }
    
    container.register(WhatsNewNotificationRepository.self, name: .implementation(.interceptedDefault)) { _ in
      return InterceptedWhatsNewNotificationRepository()
    }
  }
}

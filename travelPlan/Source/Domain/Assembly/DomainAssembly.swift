//
//  DomainAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import Foundation
import Swinject

final class DomainAssembly: Swinject.Assembly {
  // swiftlint:disable:next function_body_length
  func assemble(container: Container) {
    userUseCase(container: container)
    postUseCase(container: container)
    noticeUseCase(container: container)
    
    // TODO: - Tour Use Case
    
    // TODO: - Album Use Case
    
    // TODO: - PostReviewWriting Use Case
    
    // TODO: - PostComment Use Case
    
    // TODO: - PostNestedComment Use Case
    
    // TODO: - FavoriteDirectory Use Case
    
    // TODO: - Authentication Use Case
  }
}

// MARK: - Private Helpers
private extension DomainAssembly {
  func userUseCase(container: Container) {
    container.register(UserBlockUseCase.self, name: .implementation(.default)) { r in
      let defaultUserBlockRepository = r.resolve(UserBlockRepository.self, name: .implementation(.default))!
      return DefaultUserBlockUseCase(userBlockRepository: defaultUserBlockRepository)
    }
    
    container.register(UserBlockUseCase.self, name: .implementation(.firestore)) { r in
      let firestoreUserBlockRepository = r.resolve(UserBlockRepository.self, name: .implementation(.firestore))!
      return DefaultUserBlockUseCase(userBlockRepository: firestoreUserBlockRepository)
    }
    
    container.register(UserBlockUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedUserBlockRepository = r.resolve(
        UserBlockRepository.self,
        name: .implementation(.interceptedDefault))!
      return DefaultUserBlockUseCase(userBlockRepository: interceptedUserBlockRepository)
    }
    
    container.register(UserBlockUseCase.self, name: .testDouble(.mock)) { r in
      let mockUserBlockRepository = r.resolve(UserBlockRepository.self,name: .testDouble(.mock))!
      return DefaultUserBlockUseCase(userBlockRepository: mockUserBlockRepository)
    }
  }
  
  func postUseCase(container: Container) {
    container.register(PostFetchUseCase.self, name: .implementation(.default)) { r in
      let defaultPostRepository = r.resolve(PostRepository.self, name: .implementation(.default))!
      return DefaultPostFetchUseCase(postRepository: defaultPostRepository)
    }.inObjectScope(.transient)
    
    container.register(PostFetchUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedPostRepository = r.resolve(PostRepository.self, name: .implementation(.interceptedDefault))!
      return DefaultPostFetchUseCase(postRepository: interceptedPostRepository)
    }.inObjectScope(.transient)
    
    container.register(PostFetchUseCase.self, name: .testDouble(.mock)) { _ in
      MockPostFetchUseCase()
    }.inObjectScope(.transient)
  }
  
  func noticeUseCase(container: Container) {
    container.register(NoticeUseCase.self, name: .implementation(.default)) { r in
      let defaultWhatsNewRepo = r.resolve(WhatsNewNotificationRepository.self, name: .implementation(.default))!
      return DefaultNoticeUseCase(whatsNewNotificationRepository: defaultWhatsNewRepo)
    }
    
    container.register(NoticeUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedWhatsNewRepo = r.resolve(
        WhatsNewNotificationRepository.self,
        name: .implementation(.interceptedDefault))!
      return DefaultNoticeUseCase(whatsNewNotificationRepository: interceptedWhatsNewRepo)
    }
    
    container.register(NoticeUseCase.self, name: .implementation(.firestore)) { r in
      let firestoreWhatsNewRepo = r.resolve(WhatsNewNotificationRepository.self, name: .implementation(.firestore))!
      return DefaultNoticeUseCase(whatsNewNotificationRepository: firestoreWhatsNewRepo)
    }
  }
}

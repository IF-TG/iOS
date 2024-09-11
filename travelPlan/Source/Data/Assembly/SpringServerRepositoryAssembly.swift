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
    
    destinationSearchRepository(container: container)
    destinationScrapRepository(container: container)
    recentSearchHistoryRepository(container: container)
    recommendationSearchHistoryRepository(container: container)
    destinationRepository(container: container)
    destinationLikeRepository(container: container)
    destinationRecommendRepository(container: container)
    reviewWritingRepository(container: container)
    photoAuthorizationRepository(container: container)
    
    // MARK: - LoginRepository
    container.register(LoginRepository.self) { r in
    #if DEBUG
      let authenticationService = DefaultAuthenticationService(sessionProvider: SessionProvider())
      let loginResultStorage = r.resolve(LoginResultStorage.self)!
      let loggedInUserRepository = r.resolve(LoggedInUserRepository.self)!
      let userProfileRepository = StubUserProfileRepository()
      let firestoreService = r.resolve(FirestoreServiceProtocol.self, name: .firebase)!
    #else
      let authenticationService = r.resolve(AuthenticationService.self)!
      let loginResultStorage = r.resolve(LoginResultStorage.self)!
      let loggedInUserRepository = r.resolve(LoggedInUserRepository.self)!
      let userProfileRepository = r.resolve(UserProfileRepository.self)!
      let firestoreService = r.resolve(FirestoreServiceProtocol.self, name: .firebase)!
    #endif
      
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
    
    // MARK: - Post
    container.register(PostRepository.self) { r in
      let defaultOwnerStorage = r.resolve(OwnerStorage.self)!
      let defaultSessionProvider = r.resolve(Sessionable.self)!
      return DefaultPostRepository(service: defaultSessionProvider, ownerStorage: defaultOwnerStorage)
    }
    
    // MARK: - PostComment
    container.register(PostCommentRepository.self) { _ in
      return DefaultPostCommentRepository(service: defaultSession)
    }
    
    // MARK: - PostNestedComment
    container.register(PostNestedCommentRepository.self) { _ in
      return DefaultPostNestedCommentRepository(service: defaultSession)
    }
    
    // MARK: - whatsNewNotification
    container.register(WhatsNewNotificationRepository.self) { _ in
      return DefaultWhatsNewNotificationRepository(service: defaultSession)
    }
  }
}

// MARK: - Private Helpers
private extension SpringServerRepositoryAssembly {
  func destinationSearchRepository(container: Container) {
    container.register(DestinationSearchRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultDestinationSearchRepository(service: service)
    }
  }
  
  func destinationScrapRepository(container: Container) {
    container.register(DestinationScrapRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultDestinationScrapRepository(service: service)
    }
  }
  
  func recentSearchHistoryRepository(container: Container) {
    container.register(RecentSearchHistoryRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultRecentSearchHistoryRepository(service: service)
    }
  }
  
  func recommendationSearchHistoryRepository(container: Container) {
    container.register(RecommendationSearchHistoryRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultRecommendationSearchHistoryRepository(service: service)
    }
  }
  
  func destinationRepository(container: Container) {
    container.register(DestinationRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultDestinationRepository(service: service)
    }
  }
  
  func destinationLikeRepository(container: Container) {
    container.register(DestinationLikeRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultDestinationLikeRepository(service: service)
    }
  }
  
  func destinationRecommendRepository(container: Container) {
    container.register(DestinationRecommendRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultDestinationRecommendRepository(service: service)
    }
  }
  
  func reviewWritingRepository(container: Container) {
    
    container.register(ReviewWritingRepository.self) { r in
      let service = r.resolve(Sessionable.self)!
      return DefaultReviewWritingRepository(service: service)
    }
    
    container.register(ReviewWritingRepository.self, name: .jsonMock) { _ in
      return JsonMockReviewWritingRepository()
    }
  }
  
  func photoAuthorizationRepository(container: Container) {
    container.register(PhotoAuthorizationRepository.self) { _ in
      return DefaultPhotoAuthorizationRepository()
    }
  }
}

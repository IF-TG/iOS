//
//  DomainAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import Foundation
import Swinject

final class DomainAssembly: Swinject.Assembly {
  func assemble(container: Container) {
    userUseCase(container: container)
    postUseCase(container: container)
    postCommentUseCase(container: container)
    postNestedCommentUseCase(container: container)
    postCommentHeartUseCase(container: container)
    postNestedCommentHeartUseCase(container: container)
    noticeUseCase(container: container)
    loginUseCase(container: container)
    destinationSearchResultUseCase(container: container)
    searchHistoryUseCase(container: container)
    destinationDetailUseCase(container: container)
    destinationRecommendUseCase(container: container)
    settingRelatedUseCases(container: container)
    loggedInUserUseCase(container: container)
    reviewWritingUseCase(container: container)
    albumUseCase(container: container)
    
    // TODO: - Tour Use Case
    
    // TODO: - FavoriteDirectory Use Case
    
    // TODO: - Authentication Use Case
  }
}

// MARK: - Private Helpers
private extension DomainAssembly {
  func settingRelatedUseCases(container: Container) {
    container.register(UserProfileImageSettingUseCase.self) { r in
#if DEBUG
      return StubUserProfileImageSettingUseCase()
#else
      let userProfileSettingRepository = r.resolve(UserProfileSettingRepository.self, name: .firebase)!
      return DefaultUserProfileImageSettingUseCase(userProfileSettingRepository: userProfileSettingRepository)
#endif
    }
    
    container.register(UserNicknameSettingUseCase.self) { r in
#if DEBUG
      return StubUserNicknameSettingUseCase()
#else
      let userProfileSettingRepository = r.resolve(UserProfileSettingRepository.self, name: .firebase)!
      return DefaultUserNicknameSettingUseCase(userProfileSettingRepository: userProfileSettingRepository)
#endif
    }
    
    container.register(NicknameValidationUseCase.self) { r in
#if DEBUG
      return StubNicknameValidationUseCase()
#else
      let ownerStorage = r.resolve(OwnerStorage.self)!
      let userProfileSettingRepository = r.resolve(UserProfileSettingRepository.self, name: .firebase)!
      return DefaultNicknameValidationUseCase(
        userProfileSettingRepository: userProfileSettingRepository,
        ownerStorage: ownerStorage)
#endif
    }
  }
  
  func searchHistoryUseCase(container: Container) {
    container.register(SearchHistoryUseCase.self) { r in
      let recentRepository: RecentSearchHistoryRepository
      let recommendationRepository: RecommendationSearchHistoryRepository
      
#if DEBUG
      recentRepository = JsonMockRecentSearchHistoryRepository()
      recommendationRepository = r.resolve(RecommendationSearchHistoryRepository.self)!
      return DefaultSearchHistoryUseCase(
        recentRepository: recentRepository,
        recommendationRepository: recommendationRepository
      )
#else
      recentRepository = r.resolve(RecentSearchHistoryRepository.self)!
      recommendationRepository = r.resolve(RecommendationSearchHistoryRepository.self)!
      return DefaultSearchHistoryUseCase(
        recentRepository: recentRepository,
        recommendationRepository: recommendationRepository
      )
#endif
    }
  }
  
  func destinationSearchResultUseCase(container: Container) {
    container.register(DestinationSearchResultUseCase.self) { r in
      let searchRepository: any DestinationSearchRepository
      let scrapRepository: any DestinationScrapRepository
#if DEBUG
      searchRepository = JsonMockDestinationSearchRepository()
      scrapRepository = JsonMockDestinationScrapRepository()
      return DefaultDestinationSearchResultUseCase(
        destinationSearchRepository: searchRepository,
        destinationScrapRepository: scrapRepository
      )
#else
      seaerchRepository = r.resolve(DestinationSearchRepository.self)!
      scrapRepository = r.resolve(DestinationScrapRepository.self)!
      return DefaultDestinationSearchResultUseCase(
        destinationSearchRepository: searchRepository,
        destinationScrapRepository: scrapRepository
      )
#endif
    }
  }
  
  func userUseCase(container: Container) {
    container.register(UserBlockUseCase.self) { r in
#if DEBUG
      let wrappedRepo = MockWrappedUserBlockRepository()
      return DefaultUserBlockUseCase(userBlockRepository: wrappedRepo)
#else
      let defaultUserBlockRepository = r.resolve(UserBlockRepository.self)!
      return DefaultUserBlockUseCase(userBlockRepository: defaultUserBlockRepository)
#endif
    }
    
    container.register(UserBlockUseCase.self, name: .firebase) { r in
      let firestoreUserBlockRepository = r.resolve(UserBlockRepository.self, name: .firebase)!
      return DefaultUserBlockUseCase(userBlockRepository: firestoreUserBlockRepository)
    }
  }
  
  func postUseCase(container: Container) {
    container.register(PostFetchUseCase.self) { r in
#if DEBUG
      return MockPostFetchUseCase()
#else
      let defaultPostRepository = r.resolve(PostRepository.self)!
      return DefaultPostFetchUseCase(postRepository: defaultPostRepository)
#endif
    }.inObjectScope(.transient)
    
    container.register(PostFetchUseCase.self, name: .firebase) { r in
      let firestorePostFetchAtomicRepo = r.resolve(PostFetchAtomicRepository.self, name: .firebase)!
      let firestoreUserProfileRepository = r.resolve(UserProfileRepository.self, name: .firebase)!
      let firestorePostHeartRepository = r.resolve(PostHeartRepository.self, name: .firebase)!
      let firestoreOwnerHeartPostRepo = r.resolve(OwnerHeartPostRepository.self, name: .firebase)!
      return PostFetchUseCaseImpl(
        postFetchAtomicRepository: firestorePostFetchAtomicRepo,
        userProfileRepository: firestoreUserProfileRepository,
        postHeartRepository: firestorePostHeartRepository,
        ownerHeartPostRepository: firestoreOwnerHeartPostRepo)
    }
    
    container.register(PostHeartUseCase.self) { r in
#if DEBUG
      let mockPostRepoDecorator = JsonMockPostRepository()
      return DefaultPostHeartUseCase(postRepository: mockPostRepoDecorator)
#else
      let defaultPostRepository = r.resolve(PostRepository.self)!
      return DefaultPostHeartUseCase(postRepository: defaultPostRepository)
#endif

    }
  }
  
  func postCommentUseCase(container: Container) {
    container.register(PostCommentsAndPostLikeStateFetchUseCase.self) { r in
#if DEBUG
      let mockPostRepository = JsonMockPostRepository()
      return DefaultPostCommentsAndPostLikeStateFetchUseCase(postRepository: mockPostRepository)
#else
      let defaultPostRepository = r.resolve(PostRepository.self)!
      return DefaultPostCommentsAndPostLikeStateFetchUseCase(postRepository: defaultPostRepository)
#endif
    }
    
    container.register(PostCommentUseCase.self) { r in
#if DEBUG
      let mockPostCommentRepository = MockPostCommentRepository()
      return DefaultPostCommentUseCase(postCommentRepository: mockPostCommentRepository)
#else
      let defaultPostCommentRepository = r.resolve(PostCommentRepository.self)!
      return DefaultPostCommentUseCase(postCommentRepository: defaultPostCommentRepository)
#endif
    }
    
    container.register(PostCommentUseCase.self, name: .firebase) { r in
      let ownerRepository = r.resolve(LoggedInUserRepository.self)!
      let postAtomicCommentRepository = r.resolve(PostAtomicCommentRepository.self, name: .firebase)!
      let postAtomicNestedCommentRepo = r.resolve(
        PostAtomicNestedCommentRepository.self, name: .firebase)!
      let firestoreUserProfileRepository = r.resolve(UserProfileRepository.self, name: .firebase)!
      let postNestedCommentHeartRepository = r.resolve(PostNestedCommentHeartRepository.self, name: .firebase)!
      let postCommentHeartRepository = r.resolve(PostCommentHeartRepository.self, name: .firebase)!
      return PostCommentUseCaseImpl(
        ownerRepository: ownerRepository,
        postAtomicCommentRepository: postAtomicCommentRepository,
        postNestedCommentRepository: postAtomicNestedCommentRepo,
        userProfileRepository: firestoreUserProfileRepository,
        postNestedCommentHeartRepository: postNestedCommentHeartRepository,
        postCommentHeartRepository: postCommentHeartRepository,
        backgroundQueue: .init(label: "backgorundQUeue", qos: .userInitiated, attributes: .concurrent))
    }
  }
  
  func postNestedCommentUseCase(container: Container) {
    container.register(PostNestedCommentUseCase.self) { r in
#if DEBUG
      let wrappedRepository = MockPostNestedCommentRepository()
      return DefaultPostNestedCommentUseCase(postNestedCommentRepository: wrappedRepository)
#else
      let defaultPostNestedCommentRepository = r.resolve(PostNestedCommentRepository.self)!
      return DefaultPostNestedCommentUseCase(postNestedCommentRepository: defaultPostNestedCommentRepository)
#endif
    }
    
    container.register(PostNestedCommentUseCase.self, name: .firebase) { r in
      let firestoreNestedCommentRepository = r.resolve(PostAtomicNestedCommentRepository.self, name: .firebase)!
      let ownerRepository = r.resolve(LoggedInUserRepository.self)!
      let firestoreCommentRepository = r.resolve(PostAtomicCommentRepository.self, name: .firebase)!
      return PostNestedCommentUseCaseImpl(
        nestedCommentRepository: firestoreNestedCommentRepository,
        ownerRepository: ownerRepository,
        commentRepository: firestoreCommentRepository)
    }
  }
  
  func postCommentHeartUseCase(container: Container) {
    container.register(PostCommentHeartUseCase.self) { r in
#if DEBUG
      let mockPostCommentRepository = MockPostCommentRepository()
      return DefaultPostCommentHeartUseCase(postCommentRepository: mockPostCommentRepository)
#else
      let postCommentRepository = r.resolve(PostCommentRepository.self)!
      return DefaultPostCommentHeartUseCase(postCommentRepository: postCommentRepository)
#endif
    }
    
    container.register(PostCommentHeartUseCase.self, name: .firebase) { r in
      let firestorePostCommentHeartRepository = r.resolve(
        PostCommentHeartRepository.self, name: .firebase)!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self)!
      return PostCommentHeartUseCaseImpl(
        commentHeartRepository: firestorePostCommentHeartRepository,
        ownerRepository: defaultOwnerRepository)
    }
  }
  
  func postNestedCommentHeartUseCase(container: Container) {
    container.register(PostNestedCommentHeartUseCase.self) { r in
#if DEBUG
      let mockPostNestedCommentRepository = MockPostNestedCommentRepository()
      return DefaultPostNestedCommentHeartUseCase(postNestedCommentRepository: mockPostNestedCommentRepository)
#else
      let defaultPostCommentRepository = r.resolve(PostNestedCommentRepository.self)!
      return DefaultPostNestedCommentHeartUseCase(postNestedCommentRepository: defaultPostCommentRepository)
#endif
    }
    
    container.register(PostNestedCommentHeartUseCase.self, name: .firebase) { r in
      let firestoreNestedCommentHeartRepository = r.resolve(PostNestedCommentHeartRepository.self, name: .firebase)!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self)!
      return PostNestedCommentHeartUseCaseImpl(
        nestedCommentHeartRepository: firestoreNestedCommentHeartRepository,
        ownerRepository: defaultOwnerRepository)
    }
  }
  
  func noticeUseCase(container: Container) {
    container.register(NoticeUseCase.self) { r in
#if DEBUG
      let interceptedWhatsNewNotificationRepo = InterceptedWhatsNewNotificationRepository()
      return DefaultNoticeUseCase(whatsNewNotificationRepository: interceptedWhatsNewNotificationRepo)
#else
      let defaultWhatsNewRepo = r.resolve(WhatsNewNotificationRepository.self)!
      return DefaultNoticeUseCase(whatsNewNotificationRepository: defaultWhatsNewRepo)
#endif
    }
    
    container.register(NoticeUseCase.self, name: .firebase) { r in
#if DEBUG
      let interceptedWhatsNewNotificationRepo = InterceptedWhatsNewNotificationRepository()
      return DefaultNoticeUseCase(whatsNewNotificationRepository: interceptedWhatsNewNotificationRepo)
#else
      let firestoreWhatsNewRepo = r.resolve(WhatsNewNotificationRepository.self, name: .firebase)!
      return DefaultNoticeUseCase(whatsNewNotificationRepository: firestoreWhatsNewRepo)
#endif
    }
  }
  
  func loginUseCase(container: Container) {
    container.register(LoginUseCase.self) { r in
      let loginRepository = r.resolve(LoginRepository.self)!
      return DefaultLoginUseCase(loginRepository: loginRepository)
    }
  }
  
  func destinationDetailUseCase(container: Container) {
    container.register(DestinationDetailUseCase.self) { r in
#if DEBUG
      return DefaultDestinationDetailUseCase(
        likeRepository: JsonMockDestinationLikeRepository(),
        scrapRepository: JsonMockDestinationScrapRepository(),
        destinationRepository: JsonMockDestinationRepository()
      )
#else
      return DefaultDestinationDetailUseCase(
        likeRepository: r.resolve(DestinationLikeRepository.self)!,
        scrapRepository: r.resolve(DestinationScrapRepository.self)!,
        destinationRepository: r.resolve(DestinationRepository.self)!
      )
#endif
    }
  }
  
  func destinationRecommendUseCase(container: Container) {
    container.register(DestinationRecommendUseCase.self) { r in
#if DEBUG
      return DefaultDestinationRecommendUseCase(
        recommendRepository: JsonMockDestinationRecommendRepository(),
        scrapRepository: JsonMockDestinationScrapRepository()
      )
#else
      return DefaultDestinationRecommendUseCase(
        recommendRepository: r.resolve(DestinationRecommendRepository.self)!,
        scrapRepository: r.resolve(DestinationScrapRepository.self)!
      )
#endif
    }
  }
  
  func loggedInUserUseCase(container: Container) {
    container.register(LoggedInUserUseCase.self) { r in
      let loggedInUserRepository = r.resolve(LoggedInUserRepository.self)!
      return DefaultLoggedInUserUseCase(loggedInUserRepository: loggedInUserRepository)
    }
  }
  
  func reviewWritingUseCase(container: Container) {
    container.register(ReviewWritingUseCase.self) { r in
      let reviewWritingRepository = r.resolve(ReviewWritingRepository.self)!
      let photoAuthRepository = r.resolve(PhotoAuthorizationRepository.self)!
      
      return DefaultReviewWritingUseCase(
        reviewWritingRepository: reviewWritingRepository,
        photoAuthRepository: photoAuthRepository
      )
    }
  }
  
  func albumUseCase(container: Container) {
    container.register(AlbumUseCase.self) { _ in
      return DefaultAlbumUseCase()
    }
  }
}

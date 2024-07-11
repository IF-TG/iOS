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
    
    // TODO: - Tour Use Case
    
    // TODO: - Album Use Case
    
    // TODO: - PostReviewWriting Use Case
    
    // TODO: - FavoriteDirectory Use Case
    
    // TODO: - Authentication Use Case
  }
}

// MARK: - Private Helpers
private extension DomainAssembly {
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
  }
  
  func postCommentUseCase(container: Container) {
    container.register(PostCommentsAndPostLikeStateFetchUseCase.self) { r in
      let defaultPostRepository = r.resolve(PostRepository.self)!
      return DefaultPostCommentsAndPostLikeStateFetchUseCase(postRepository: defaultPostRepository)
    }
    
    container.register(PostCommentUseCase.self) { r in
      let defaultPostCommentRepository = r.resolve(PostCommentRepository.self)!
      return DefaultPostCommentUseCase(postCommentRepository: defaultPostCommentRepository)
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
      let postCommentRepository = r.resolve(PostCommentRepository.self)!
      return DefaultPostCommentHeartUseCase(postCommentRepository: postCommentRepository)
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
}

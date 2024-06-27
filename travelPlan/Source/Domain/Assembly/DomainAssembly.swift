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
      let mockUserBlockRepository = r.resolve(UserBlockRepository.self, name: .testDouble(.mock))!
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
    
    container.register(PostFetchUseCase.self, name: .implementation(.firestore)) { r in
      let firestorePostFetchAtomicRepo = r.resolve(PostFetchAtomicRepository.self, name: .implementation(.default))!
      let firestoreUserProfileRepository = r.resolve(UserProfileRepository.self, name: .implementation(.firestore))!
      let firestorePostHeartRepository = r.resolve(PostHeartRepository.self, name: .implementation(.firestore))!
      let firestoreOwnerHeartPostRepo = r.resolve(OwnerHeartPostRepository.self, name: .implementation(.firestore))!
      return PostFetchUseCaseImpl(
        postFetchAtomicRepository: firestorePostFetchAtomicRepo,
        userProfileRepository: firestoreUserProfileRepository,
        postHeartRepository: firestorePostHeartRepository,
        ownerHeartPostRepository: firestoreOwnerHeartPostRepo)
    }
  }
  
  func postCommentUseCase(container: Container) {
    container.register(
      PostCommentsAndPostLikeStateFetchUseCase.self,
      name: .implementation(.interceptedDefault)
    ) { r in
      let mockPostRepository = r.resolve(PostRepository.self, name: .testDouble(.mock))!
      return DefaultPostCommentsAndPostLikeStateFetchUseCase(postRepository: mockPostRepository)
    }
    
    container.register(
      PostCommentsAndPostLikeStateFetchUseCase.self,
      name: .implementation(.default)
    ) { r in
      let defaultPostRepository = r.resolve(PostRepository.self, name: .implementation(.default))!
      return DefaultPostCommentsAndPostLikeStateFetchUseCase(postRepository: defaultPostRepository)
    }
    
    container.register(PostCommentUseCase.self, name: .implementation(.default)) { r in
      let defaultPostCommentRepository = r.resolve(PostCommentRepository.self, name: .implementation(.default))!
      return DefaultPostCommentUseCase(postCommentRepository: defaultPostCommentRepository)
    }
    
    container.register(PostCommentUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let postCommentRepository = r.resolve(PostCommentRepository.self, name: .implementation(.interceptedDefault))!
      return DefaultPostCommentUseCase(postCommentRepository: postCommentRepository)
    }
    
    container.register(PostCommentUseCase.self, name: .implementation(.firestore)) { r in
      let ownerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      let postAtomicCommentRepository = r.resolve(PostAtomicCommentRepository.self, name: .implementation(.firestore))!
      let postAtomicNestedCommentRepo = r.resolve(
        PostAtomicNestedCommentRepository.self, name: .implementation(.firestore))!
      let firestoreUserProfileRepository = r.resolve(UserProfileRepository.self, name: .implementation(.firestore))!
      let postNestedCommentHeartRepository = r.resolve(
        PostNestedCommentHeartRepository.self, name: .implementation(.firestore))!
      let postCommentHeartRepository = r.resolve(PostCommentHeartRepository.self, name: .implementation(.firestore))!
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
    container.register(PostNestedCommentUseCase.self, name: .implementation(.default)) { r in
      let defaultPostNestedCommentRepository = r.resolve(
        PostNestedCommentRepository.self, name: .implementation(.default))!
      return DefaultPostNestedCommentUseCase(postNestedCommentRepository: defaultPostNestedCommentRepository)
    }
    
    container.register(PostNestedCommentUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedPostNestedCommentRepository = r.resolve(
        PostNestedCommentRepository.self, name: .implementation(.interceptedDefault))!
      return DefaultPostNestedCommentUseCase(postNestedCommentRepository: interceptedPostNestedCommentRepository)
    }
    
    container.register(PostNestedCommentUseCase.self, name: .implementation(.firestore)) { r in
      let firestoreNestedCommentRepository = r.resolve(
        PostAtomicNestedCommentRepository.self, name: .implementation(.firestore))!
      let ownerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      let firestoreCommentRepository = r.resolve(PostAtomicCommentRepository.self, name: .implementation(.firestore))!
      return PostNestedCommentUseCaseImpl(
        nestedCommentRepository: firestoreNestedCommentRepository,
        ownerRepository: ownerRepository,
        commentRepository: firestoreCommentRepository)
    }
  }
  
  func postCommentHeartUseCase(container: Container) {
    container.register(PostCommentHeartUseCase.self, name: .implementation(.default)) { r in
      let postCommentRepository = r.resolve(PostCommentRepository.self, name: .implementation(.default))!
      return DefaultPostCommentHeartUseCase(postCommentRepository: postCommentRepository)
    }
    
    container.register(PostCommentHeartUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedPostCommentRepository = r.resolve(
        PostCommentRepository.self, name: .implementation(.interceptedDefault))!
      return DefaultPostCommentHeartUseCase(postCommentRepository: interceptedPostCommentRepository)
    }
    
    container.register(PostCommentHeartUseCase.self, name: .implementation(.firestore)) { r in
      let firestorePostCommentHeartRepository = r.resolve(
        PostCommentHeartRepository.self, name: .implementation(.firestore))!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      return PostCommentHeartUseCaseImpl(
        commentHeartRepository: firestorePostCommentHeartRepository,
        ownerRepository: defaultOwnerRepository)
    }
  }
  
  func postNestedCommentHeartUseCase(container: Container) {
    container.register(PostNestedCommentHeartUseCase.self, name: .implementation(.default)) { r in
      let defaultPostCommentRepository = r.resolve(PostNestedCommentRepository.self, name: .implementation(.default))!
      return DefaultPostNestedCommentHeartUseCase(postNestedCommentRepository: defaultPostCommentRepository)
    }
    
    container.register(PostNestedCommentHeartUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedPostCommentRepository = r.resolve(
        PostNestedCommentRepository.self, name: .implementation(.interceptedDefault))!
      return DefaultPostNestedCommentHeartUseCase(postNestedCommentRepository: interceptedPostCommentRepository)
    }
    
    container.register(PostNestedCommentHeartUseCase.self, name: .implementation(.firestore)) { r in
      let firestoreNestedCommentHeartRepository = r.resolve(
        PostNestedCommentHeartRepository.self, name: .implementation(.firestore))!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      return PostNestedCommentHeartUseCaseImpl(
        nestedCommentHeartRepository: firestoreNestedCommentHeartRepository,
        ownerRepository: defaultOwnerRepository)
    }
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
  
  func loginUseCase(container: Container) {
    container.register(LoginUseCase.self) { r in
      let loginRepository = r.resolve(LoginRepository.self)!
      return DefaultLoginUseCase(loginRepository: loginRepository)
    }
  }
}

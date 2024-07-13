//
//  FirebaseRepositoryAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject
import Alamofire
import SHFirestoreService

final class FirebaseRepositoryAssembly: Swinject.Assembly {
  // swiftlint:disable:next function_body_length
  func assemble(container: Swinject.Container) {
    // MARK: - SHFirestoreService
    container.register(FirestoreServiceProtocol.self, name: .firebase) { _ in
      FirestoreService()
    }
    
    let firestoreService = container.resolve(FirestoreServiceProtocol.self, name: .firebase)!
    let firestoreStorageService = container.resolve(
      ImageStorageServiceProtocol.self, name: .firebase)!
    
    // MARK: - Firestore PostComment
    container.register(PostAtomicCommentRepository.self, name: .firebase) { _ in
      FirestorePostCommentRepository(service: firestoreService)
    }
    
    container.register(PostAtomicNestedCommentRepository.self, name: .firebase) { _ in
      FirestorePostNestedCommentRepository(service: firestoreService)
    }
    
    // MARK: - Firestore PostHeart
    container.register(PostNestedCommentHeartRepository.self, name: .firebase) { _ in
      FirestorePostNestedCommentHeartRepository(service: firestoreService)
    }
    
    container.register(OwnerHeartPostRepository.self, name: .firebase) { r in
      let ownerStorage = r.resolve(OwnerStorage.self)!
      return FirestoreOwnerHeartPostRepository(ownerStorage: ownerStorage, service: firestoreService)
    }
    
    container.register(PostHeartRepository.self, name: .firebase) { _ in
      FirestorePostHeartRepository(service: firestoreService)
    }
    
    container.register(PostCommentHeartRepository.self, name: .firebase) { _ in
      FirestorePostCommentHeartRepository(service: firestoreService)
    }
    
    // MARK: - Firestore User
    container.register(UserProfileRepository.self, name: .firebase) { _ in
      FirestoreUserProfileRepository(service: firestoreService, firebaseStorageService: firestoreStorageService)
    }
    
    container.register(UserProfileSettingRepository.self, name: .firebase) { r in
      let ownerStorage = r.resolve(OwnerStorage.self)!
      return FirestoreUserProfileSettingRepository(
        service: firestoreService,
        firebaseStorageService: firestoreStorageService,
        ownerStorage: ownerStorage)
    }
    
    container.register(UserBlockRepository.self, name: .firebase) { r in
      let ownerStorage = r.resolve(OwnerStorage.self)!
      return FirestoreUserBlockRepository(service: firestoreService, ownerStorage: ownerStorage)
    }
    
    // MARK: - Firesotre Post
    container.register(ReviewWritingRepository.self, name: .firebase) { _ in
      FirestoreReviewWritingRepository(service: firestoreService)
    }
    
    container.register(PostFetchAtomicRepository.self, name: .firebase) { r in
      let ownerStorage = r.resolve(OwnerStorage.self)!
      return FirestorePostRepository(
        service: firestoreService,
        firebaseStorageService: firestoreStorageService,
        ownerStorage: ownerStorage)
    }
    
    // MARK: - Firestore whatsNewNotification
    container.register(WhatsNewNotificationRepository.self, name: .firebase) { _ in
      return FirestoreWhatsNewNotificationRepository(service: firestoreService)
    }
  }
}

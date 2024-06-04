//
//  RepositoryAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject
import Alamofire
import SHFirestoreService

final class RepositoryAssembly: Swinject.Assembly {
  func assemble(container: Swinject.Container) {
    // MARK: - SHFirestoreService
    container.register(FirestoreServiceProtocol.self, name: .implementation(.firestore)) { _ in
      FirestoreService()
    }
    
    /// 외부에서 주입하고 싶은데, register 함수에서 factory가 클로저라 self.참조가됩니다 ㅠㅠ
    let firestoreService = container.resolve(FirestoreServiceProtocol.self, name: .implementation(.firestore))!
    let firestoreStorageService = container.resolve(
      ImageStorageServiceProtocol.self, name: .implementation(.firestore))!
    
    // MARK: - Common Tour API
    container.register(Sessionable.self, name: .implementation(.default)) { r in
      let session = r.resolve(Session.self, name: .implementation(.default))!
      return TourApiSessionProvider(session: session)
    }
    
    container.register(Sessionable.self, name: .testDouble(.mock)) { r in
      let mockSession = r.resolve(Session.self, name: .testDouble(.mock))!
      return TourApiSessionProvider(session: mockSession)
    }
    
    // MARK: - Firestore PostComment
    container.register(PostAtomicCommentRepository.self, name: .implementation(.firestore)) { _ in
      FirestorePostCommentRepository(service: firestoreService)
    }
    
    container.register(PostAtomicNestedCommentRepository.self, name: .implementation(.firestore)) { _ in
      FirestorePostNestedCommentRepository(service: firestoreService)
    }
    
    // MARK: - Firestore PostHeart
    container.register(PostNestedCommentHeartRepository.self, name: .implementation(.firestore)) { _ in
      FirestorePostNestedCommentHeartRepository(service: firestoreService)
    }
    
    container.register(OwnerHeartPostRepository.self, name: .implementation(.firestore)) { r in
      let ownerStorage = r.resolve(OwnerStorage.self, name: .implementation(.default))!
      return FirestoreOwnerHeartPostRepository(ownerStorage: ownerStorage, service: firestoreService)
    }
    
    container.register(OwnerHeartPostRepository.self, name: .testDouble(.mock)) { r in
      let stubOwnerStorage = r.resolve(OwnerStorage.self, name: .testDouble(.stub))!
      return FirestoreOwnerHeartPostRepository(ownerStorage: stubOwnerStorage, service: firestoreService)
    }
    
    container.register(PostHeartRepository.self, name: .implementation(.firestore)) { _ in
      FirestorePostHeartRepository(service: firestoreService)
    }
    
    container.register(PostCommentHeartRepository.self, name: .implementation(.firestore)) { _ in
      FirestorePostCommentHeartRepository(service: firestoreService)
    }
    
    // MARK: - Firestore User
    container.register(UserProfileRepository.self, name: .implementation(.firestore)) { _ in
      FirestoreUserProfileRepository(service: firestoreService, firebaseStorageService: firestoreStorageService)
    }
    
    container.register(UserProfileSettingRepository.self, name: .implementation(.firestore)) { r in
      let ownerStorage = r.resolve(OwnerStorage.self, name: .implementation(.default))!
      return FirestoreUserProfileSettingRepository(
        service: firestoreService,
        firebaseStorageService: firestoreStorageService,
        ownerStorage: ownerStorage)
    }
    
    container.register(UserProfileSettingRepository.self, name: .testDouble(.mock)) { r in
      let ownerStorage = r.resolve(OwnerStorage.self, name: .testDouble(.stub))!
      return FirestoreUserProfileSettingRepository(
        service: firestoreService,
        firebaseStorageService: firestoreStorageService,
        ownerStorage: ownerStorage)
    }
    
    container.register(UserBlockRepository.self, name: .implementation(.firestore)) { r in
      let ownerStorage = r.resolve(OwnerStorage.self, name: .implementation(.default))!
      return FirestoreUserBlockRepository(service: firestoreService, ownerStorage: ownerStorage)
    }
    
    // MARK: - Firesotre Post
    container.register(ReviewWritingRepository.self, name: .implementation(.firestore)) { _ in
      FirestoreReviewWritingRepository(service: firestoreService)
    }
    
    container.register(PostFetchAtomicRepository.self, name: .implementation(.firestore)) { r in
      let ownerStorage = r.resolve(OwnerStorage.self, name: .implementation(.default))!
      return FirestorePostRepository(
        service: firestoreService,
        firebaseStorageService: firestoreStorageService,
        ownerStorage: ownerStorage)
    }
    
    // TODO: - Tour API
    
    // TODO: - SpringServer
  }
}


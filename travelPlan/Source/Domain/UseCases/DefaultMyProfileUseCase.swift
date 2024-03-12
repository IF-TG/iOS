//
//  DefaultMyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

final class DefaultMyProfileUseCase: MyProfileUseCase {
  // MARK: - Dependencies
  private let myProfileRepository: MyProfileRepository
  
  // MARK: - Properties
  var isNicknameDuplicated = PassthroughSubject<Bool, MainError>()
  
  var isNicknameUpdated = PassthroughSubject<Bool, MainError>()
  
  var isProfileUpdated = PassthroughSubject<Bool, MainError>()
  
  var isProfileSaved = PassthroughSubject<Bool, MainError>()
  
  var isProfileDeleted = PassthroughSubject<Bool, MainError>()
  
  var fetchedProfile = PassthroughSubject<ProfileImageEntity, MainError>()
  
  var isProfileSavedInServer: Bool {
    myProfileRepository.isProfileSavedInServer
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(myProfileRepository: MyProfileRepository) {
    self.myProfileRepository = myProfileRepository
  }
  
  func checkIfNicknameDuplicate(with name: String) {
    myProfileRepository.checkIfUserNicknameDuplicate(with: name)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self?.isNicknameDuplicated.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.isNicknameDuplicated.send(result)
      }.store(in: &subscriptions)
  }
  
  func updateNickname(with name: String) {
    myProfileRepository.updateUserNickname(with: name)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          return
        case .failure(let error):
          self?.isNicknameUpdated.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.isNicknameUpdated.send(result)
      }.store(in: &subscriptions)
  }
  
  func updateProfile(with base64String: String) {
    myProfileRepository.updateProfile(with: base64String)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.isProfileUpdated.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.isProfileUpdated.send(result)
      }.store(in: &subscriptions)
  }
  
  func saveProfile(with base64String: String) {
    myProfileRepository.saveProfile(with: base64String)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.isProfileSaved.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.isProfileSaved.send(result)
      }.store(in: &subscriptions)
  }
  
  func deleteProfile() {
    myProfileRepository.deleteProfile()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.isProfileDeleted.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.isProfileDeleted.send(result)
      }.store(in: &subscriptions)
  }
  
  func fetchProfile() {
    myProfileRepository.fetchProfile()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard case .failure(let error) = completion else { return }
        self?.fetchedProfile.send(completion: .failure(error))
      } receiveValue: { [weak self] entity in
        self?.fetchedProfile.send(entity)
      }.store(in: &subscriptions)
  }
}

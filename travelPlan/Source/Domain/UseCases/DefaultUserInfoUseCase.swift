//
//  DefaultUserInfoUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

final class DefaultUserInfoUseCase: UserInfoUseCase {
  // MARK: - Dependencies
  private let userInfoRepository: UserInfoRepository
  
  // MARK: - Properties
  var isNicknameDuplicated = PassthroughSubject<Bool, MainError>()
  
  var isNicknameUpdated = PassthroughSubject<Bool, MainError>()
  
  var isProfileUpdated = PassthroughSubject<Bool, MainError>()
  
  var isProfileSaved = PassthroughSubject<Bool, MainError>()
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(userInfoRepository: UserInfoRepository) {
    self.userInfoRepository = userInfoRepository
  }
  
  func checkIfNicknameDuplicate(with name: String) {
    userInfoRepository.checkIfUserNicknameDuplicate(with: name)
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
    userInfoRepository.updateUserNickname(with: name)
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
    userInfoRepository.updateProfile(with: base64String)
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
    userInfoRepository.saveProfile(with: base64String)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.isProfileSaved.send(completion: .failure(error))
        }
      } receiveValue: { [weak self] result in
        self?.isProfileSaved.send(result)
      }.store(in: &subscriptions)
  }
}

//
//  FirestoreService.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import Combine

protocol FirestoreService {
  func request<D, E>(endpoint: E) -> AnyPublisher<[D], Error>
  where D: Decodable,
        E: FirestoreEndopintable,
        D == E.ResponseDTO
  
  func request<D, E>(endpoint: E) -> AnyPublisher<D, Error>
  where D: Decodable,
        E: FirestoreEndopintable,
        D == E.ResponseDTO
  
  func request(endpoint: any FirestoreEndopintable) -> AnyPublisher<Void, Error>
}

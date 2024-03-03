//
//  KeyChainManager.swift
//  travelPlan
//
//  Created by SeokHyun on 3/1/24.
//

import Foundation

// TODO: - 현재는 Token을 매개변수로 받고 있지만, 모든 KeyChain에서 균일하게 적용하능하도록 CRUD를 정형화 해야합니다.
protocol KeyChainManager {
  func addToken(_ token: String, forKey key: KeyChainKey)
  func deleteToken(forKey key: KeyChainKey)
}

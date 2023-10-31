//
//  LoginPlayerManager.swift
//  travelPlan
//
//  Created by SeokHyun on 10/31/23.
//

import AVFoundation
import UIKit
import Combine

final class LoginPlayerManager {
  enum Constant {
    static let bundleResource = "onboarding-video"
    static let bundleExtension = "mp4"
  }
  
  // MARK: - Properties
  static let shared = LoginPlayerManager()
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  private init() { }
}

// MARK: - Helpers
extension LoginPlayerManager {
  func setupPlayer(in view: UIView) {
    typealias Const = Constant
    
    guard let url = Bundle.main.url(
      forResource: Const.bundleResource,
      withExtension: Const.bundleExtension
    ) else { return }
    
    self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
    setupPlayerLayer(with: player, in: view)
    bind()
    player?.play()
  }
  
  func play() {
    player?.play()
  }
  
  /// player의 리소스를 해제합니다.
  ///
  /// 더 이상 동영상 재생을 하지 않는다면, 해당 메소드를 호출해주어야 합니다.
  func cleanup() {
    player = nil
    playerLayer = nil
    subscriptions.removeAll()
  }
}

// MARK: - Private Helpers
extension LoginPlayerManager {
  private func setupPlayerLayer(with player: AVPlayer?, in view: UIView) {
    playerLayer = AVPlayerLayer(player: player)
    guard let playerLayer = playerLayer else { return }
    
    playerLayer.videoGravity = .resizeAspectFill
    playerLayer.frame = view.bounds
    view.layer.addSublayer(playerLayer)
  }
  
  private func bind() {
    // 비디오가 끝나면 비디오를 다시 처음부터 재시작합니다.
    NotificationCenter.default.publisher(
      for: AVPlayerItem.didPlayToEndTimeNotification,
      object: player?.currentItem
    )
    .sink { [weak self] _ in
      self?.player?.seek(to: CMTime.zero) { isCompleted in
        if isCompleted {
          self?.play()
        }
      }
    }
    .store(in: &subscriptions)
  }
}

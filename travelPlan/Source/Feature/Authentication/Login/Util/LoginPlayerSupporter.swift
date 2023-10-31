//
//  LoginPlayerSupporter.swift
//  travelPlan
//
//  Created by SeokHyun on 10/31/23.
//

import AVFoundation
import UIKit
import Combine

final class LoginPlayerSupporter {
  enum Constant {
    static let bundleResource = "onboarding-video"
    static let bundleExtension = "mp4"
  }
  
  // MARK: - Properties
  private var player: AVPlayer?
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init() { }
}

// MARK: - Helpers
extension LoginPlayerSupporter {
  func setupPlayer(in view: UIView) {
    typealias Const = Constant
    
    guard let url = Bundle.main.url(
      forResource: Const.bundleResource,
      withExtension: Const.bundleExtension
    ) else { return }
    
    self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
    setupPlayerLayer(in: view)
    bind()
  }
  
  func play() {
    player?.play()
  }
}

// MARK: - Private Helpers
extension LoginPlayerSupporter {
  private func setupPlayerLayer(in view: UIView) {
    let playerLayer = AVPlayerLayer(player: player)
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

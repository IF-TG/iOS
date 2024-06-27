//
//  ProgressView.swift
//  travelPlan
//
//  Created by 양승현 on 6/26/24.
//

import UIKit
import Combine

final public class ProgressView: UIProgressView {
  // MARK: - Constants
  private let maxProgress: Float = 1.0
  private lazy var minProgress: Float = oneStepProgress
  
  // MARK: - Properties
  private var progressRange: ClosedRange<Float> {
    (minProgress...maxProgress)
  }
  
  /// Progress bar을 n개의 단계로 나눕니다.
  private var totalSteps: Int
  
  /// Progress step이 이동될 때 애니메이션 진행기간
  private var animationDuration: TimeInterval
  
  /// 한 step이동할 때 progress gauge value입니다.
  private var oneStepProgress: Float {
    return 1.0/Float(totalSteps)
  }
  
  // MARK: - Combine Properties
  private var subscription: AnyCancellable?
  
  private let progressOneStepUpdater = PassthroughSubject<Int, Never>()
  
  // MARK: - Lifecycle
  init(
    frame: CGRect,
    style: UIProgressView.Style = .bar,
    progressTotalSteps totalSteps: Int,
    progressTintColor tintColor: UIColor?,
    progressBackgroundColor backgroundColor: UIColor?,
    animationDuration animDuration: TimeInterval = 0.7
  ) {
    self.totalSteps = totalSteps
    self.animationDuration = animDuration
    super.init(frame: frame)
    self.progressTintColor = tintColor
    self.trackTintColor = backgroundColor
    bind()
    setProgress(oneStepProgress, animated: true)
  }
  
  /// Auto layout 수월하게 사용하기 위한 initializer
  convenience init(
    style: UIProgressView.Style = .bar,
    progressTotalSteps totalSteps: Int,
    progressTintColor tintColor: UIColor?,
    progressBackgroundColor backgroundColor: UIColor?,
    animationDuration animDuration: TimeInterval = 0.7
  ) {
    self.init(
      frame: .zero,
      progressTotalSteps: totalSteps,
      progressTintColor: tintColor,
      progressBackgroundColor: backgroundColor,
      animationDuration: animDuration)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) { nil }
}

// MARK: - Public Helpers
public extension ProgressView {
  /// 직접적으로 progress step를 설정 가능합니다. 1 -> 4 etc..
  @inline(__always)
  func setProgress(by index: Int) {
    progressOneStepUpdater.send(index)
  }
  
  func increase(_ steps: Int = 1) {
    let nextProgress = progress + Float(steps) * oneStepProgress
    let availableProgress = isOutOfProgress(nextProgress) ? maxProgress : minProgress
    animate(from: availableProgress)
  }
  
  func decrease(_ steps: Int = 1) {
    let nextProgress = progress - Float(steps) * oneStepProgress
    let availableProgress = isOutOfProgress(nextProgress) ? minProgress : maxProgress
    animate(from: availableProgress)
  }
}

// MARK: - Private Helpers
private extension ProgressView {
  @inline(__always)
  func isOutOfProgress(_ currentProgress: Float) -> Bool {
    return !(progressRange ~= Float(currentProgress))
  }
  
  func animate(from updatedProgress: Float) {
    UIView.animate(
      withDuration: animationDuration,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.setProgress(updatedProgress, animated: true)
    }
  }
  
  func bind() {
    subscription = progressOneStepUpdater
      .map { [weak self] value -> Float in
        guard let self else { return 0.0 }
        return Float(value) / Float(totalSteps)
      }.receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] step in
        guard let self else { return }
        if step > progress {
          increase()
          return
        }
        decrease()
      })
  }
}

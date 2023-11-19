//
//  ReviewWritingPlanView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/5/23.
//

import UIKit
import SnapKit

final class ReviewWritingPlanView: UIView {
  // MARK: - Properties
  private let mapImageView: UIImageView = .init().set {
    $0.image = .init(named: "map")?.withRenderingMode(.alwaysOriginal)
  }
  private let textLabel: UILabel = .init().set {
    $0.text = "플랜 불러오기"
    $0.font = .init(pretendard: .medium_500(fontSize: 14))
    $0.textColor = .yg.primary
  }
  private let lineView: UIView = .init().set {
    $0.backgroundColor = .yg.primary
  }
  
  override var intrinsicContentSize: CGSize {
    let targetSize = UIView.layoutFittingCompressedSize
    let width = mapImageView.systemLayoutSizeFitting(targetSize).width
    + textLabel.systemLayoutSizeFitting(targetSize).width
    + 2
    let height = max(mapImageView.systemLayoutSizeFitting(targetSize).height,
                     textLabel.systemLayoutSizeFitting(targetSize).height)
    + 1
    return .init(width: width, height: height)
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.alpha = 0.5
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.alpha = 1.0
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    self.alpha = 1.0
  }
}

extension ReviewWritingPlanView: LayoutSupport {
  func addSubviews() {
    addSubview(mapImageView)
    addSubview(textLabel)
    addSubview(lineView)
  }
  
  func setConstraints() {
    mapImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.size.equalTo(16)
      $0.leading.equalToSuperview()
    }
    textLabel.snp.makeConstraints {
      $0.leading.equalTo(mapImageView.snp.trailing).offset(2)
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    lineView.snp.makeConstraints {
      $0.top.equalTo(textLabel.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}

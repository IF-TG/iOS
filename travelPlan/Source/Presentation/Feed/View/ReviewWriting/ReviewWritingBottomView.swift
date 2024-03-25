//
//  ReviewWritingBottomView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/5/23.
//

import UIKit
import SnapKit

final class ReviewWritingBottomView: UIView {
  // MARK: - Properties
  private lazy var planView: ReviewWritingPlanView = .init().set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlanView))
    $0.addGestureRecognizer(tapGesture)
  }
  
  private lazy var albumButton: UIButton = .init(type: .system).set {
    $0.setImage(.init(named: "camera")?.withRenderingMode(.alwaysOriginal), for: .normal)
    $0.backgroundColor = .yg.primary.withAlphaComponent(0.1)
    $0.layer.cornerRadius = 16
    $0.addTarget(self, action: #selector(didTapAlbumButton(_:)), for: .touchUpInside)
    if #available(iOS 15.0, *) {
      $0.configuration?.imagePadding = 8
    } else {
      $0.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
  }
  
  private let alertCircleImageView: UIImageView = .init().set {
    $0.image = .init(named: "alert-circle")?.withRenderingMode(.alwaysOriginal)
  }
  
  private let cameraWarningLabel: UILabel = .init().set {
    $0.text = "사진을 1개 이상 등록해주세요."
    $0.textColor = .yg.gray1
    $0.font = .init(pretendard: .regular_400(fontSize: 14))
  }
  
  weak var delegate: ReviewWritingBottomViewDelegate?
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helpers
extension ReviewWritingBottomView {
  private func setupStyles() {
    backgroundColor = .white
  }
}

// MARK: - LayoutSupport
extension ReviewWritingBottomView: LayoutSupport {
  func addSubviews() {
    addSubview(planView)
    addSubview(albumButton)
    addSubview(alertCircleImageView)
    addSubview(cameraWarningLabel)
  }
  
  func setConstraints() {
    planView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(7)
      $0.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(planView.intrinsicContentSize.height)
    }
    
    albumButton.snp.makeConstraints {
      $0.top.equalTo(planView.snp.bottom).offset(9)
      $0.leading.equalToSuperview().inset(20)
      $0.size.equalTo(44)
    }
    
    alertCircleImageView.snp.makeConstraints {
      $0.leading.equalTo(albumButton.snp.trailing).offset(8)
      $0.centerY.equalTo(albumButton)
      $0.size.equalTo(20)
    }
    
    cameraWarningLabel.snp.makeConstraints {
      $0.leading.equalTo(alertCircleImageView.snp.trailing).offset(4)
      $0.centerY.equalTo(alertCircleImageView)
    }
  }
}

// MARK: - Actions
private extension ReviewWritingBottomView {
  @objc func didTapPlanView() {
    delegate?.didTapPlanView(planView)
  }
  
  @objc func didTapAlbumButton(_ button: UIButton) {
    delegate?.didTapAlbumButton(button)
  }
}

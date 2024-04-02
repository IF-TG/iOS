//
//  PhotoAuthorizationView.swift
//  travelPlan
//
//  Created by SeokHyun on 3/28/24.
//

import UIKit
import SnapKit

final class PhotoAuthorizationView: UIView {
  // MARK: - Properties
  // TODO: - 현재는 임시로 구현했지만, 추후 디자이너의 UI에 맞게 구현하기
  private lazy var selectMorePhotosButton: UIButton = .init().set {
    $0.setTitle("더 많은 사진 선택", for: .normal)
    $0.setTitleColor(.yg.gray6, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15)
    $0.addTarget(self, action: #selector(didTapSelectMorePhotosButton), for: .touchUpInside)
  }
  
  private let firstLineView: UIView = .init().set {
    $0.backgroundColor = .black
  }
  
  private lazy var AuthsettingButton: UIButton = .init().set {
    $0.setTitle("권한 설정으로 이동", for: .normal)
    $0.setTitleColor(.yg.gray6, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15)
    $0.addTarget(self, action: #selector(didTapAuthsettingButton), for: .touchUpInside)
  }
  
  weak var delegate: PhotoAuthorizationViewDelegate?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    backgroundColor = .clear
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension PhotoAuthorizationView: LayoutSupport {
  func addSubviews() {
    addSubview(selectMorePhotosButton)
    addSubview(firstLineView)
    addSubview(AuthsettingButton)
  }
  
  func setConstraints() {
    selectMorePhotosButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().inset(10)
    }
    
    firstLineView.snp.makeConstraints {
      $0.top.equalTo(selectMorePhotosButton.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(1)
    }
    
    AuthsettingButton.snp.makeConstraints {
      $0.top.equalTo(firstLineView.snp.bottom).offset(10)
      $0.leading.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview()
    }
  }
}

// MARK: - Actions
private extension PhotoAuthorizationView {
  @objc func didTapSelectMorePhotosButton() {
    delegate?.didTapSelectMorePhotosButton()
  }
  
  @objc func didTapAuthsettingButton() {
    delegate?.didTapAuthsettingButton()
  }
}

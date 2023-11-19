//
//  PictureImageView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/19/23.
//

import UIKit
import SnapKit

class PictureImageView: UIImageView {
  // MARK: - Properties
  private lazy var deleteButton = UIButton().set {
    $0.setImage(.init(systemName: "x.circle"), for: .normal)
    $0.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
  }
  
  // MARK: - LifeCycle
  convenience init(imageName: String) {
    self.init(frame: .zero, imageName: imageName)
  }
  
  init(frame: CGRect, imageName: String) {
    super.init(frame: frame)
    setupUI()
    image = .init(named: imageName)
    contentMode = .scaleAspectFill
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension PictureImageView: LayoutSupport {
  func addSubviews() {
    addSubview(deleteButton)
  }
  
  func setConstraints() {
    deleteButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(10)
      $0.trailing.equalToSuperview().inset(10)
      $0.size.equalTo(30)
    }
  }
}

// MARK: - Helpers
extension PictureImageView {
  func remove() {
    deleteButton.removeTarget(nil, action: nil, for: .allEvents)
    removeFromSuperview()
  }
}

// MARK: - Actions
private extension PictureImageView {
  @objc func didTapDeleteButton(_ sender: UIButton) {
    print("버튼 클릭")
  }
}

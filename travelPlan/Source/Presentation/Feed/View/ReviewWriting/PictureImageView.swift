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
  weak var delegate: PictureImageViewDelegate?
  private lazy var deleteButton = UIButton().set {
    let image = UIImage(named: "cancel")?.setColor(.yg.gray5)
    $0.setImage(image, for: .normal)
    $0.backgroundColor = .yg.littleWhite.withAlphaComponent(0.7)
    $0.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
  }
  
  // MARK: - LifeCycle
  convenience init(imageName: String) {
    self.init(frame: .zero, imageName: imageName)
  }
  
  init(frame: CGRect, image: UIImage) {
    super.init(frame: frame)
    setupUI()
    self.image = image
    contentMode = .scaleAspectFill
    clipsToBounds = true
    isUserInteractionEnabled = true
  }
  
  init(frame: CGRect, imageName: String) {
    super.init(frame: frame)
    setupUI()
    image = .init(named: imageName)
    contentMode = .scaleAspectFill
    clipsToBounds = true
    isUserInteractionEnabled = true
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
      $0.top.equalToSuperview().inset(8)
      $0.trailing.equalToSuperview().inset(8)
      $0.size.equalTo(20)
    }
  }
}

// MARK: - Actions
private extension PictureImageView {
  @objc func didTapDeleteButton(_ sender: UIButton) {
    delegate?.didTapDeleteButton(sender)
  }
}

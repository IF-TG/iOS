//
//  BaseDestinationView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/24.
//

import UIKit
import SnapKit

/// imageView + centerView + starButton로 구성되어 있습니다.
///
/// centerView를 커스텀해서 생성자 시점에 주입합니다.
/// imageView를 주입하지 않으면 기본 이미지뷰를 사용합니다.
/// starButton의 이벤트를 정의해야 되는 경우, StarButtonDelegate를 준수해야 합니다.
class BaseDestinationView<CenterView>: UIView where CenterView: UIView & CellConfigurable {
  enum Constants {
    enum ThumbnailImageView {
      static var cornerRadius: CGFloat { 3 }
      enum Spacing {
        static var top: CGFloat { 5 }
        static var bottom: CGFloat { 5 }
      }
    }
    
    enum CenterView {
      enum Spacing {
        static var leading: CGFloat { 15 }
        static var trailing: CGFloat { -20 }
      }
    }
    
    enum StarButton {
      static var size: CGFloat { 24 }
      enum Spacing {
        static var top: CGFloat { 5 }
        static var trailing: CGFloat { 16 }
      }
    }
  }
  
  // MARK: - Properties
  weak var delegate: StarButtonDelegate?
  private let thumbnailImageView: UIImageView
  private let centerView: CenterView
  private lazy var starButton: SearchStarButton = .init(normalType: .black).set {
    $0.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
  }
  
  // MARK: - LifeCycle
  /// imageView를 주입하지 않으면, 기본 이미지뷰를 사용합니다.
  convenience init(centerView: CenterView, thumbnailImageView: UIImageView = .init()) {
    self.init(frame: .zero, centerView: centerView, thumbnailImageView: thumbnailImageView)
  }
  
  init(frame: CGRect, centerView: CenterView, thumbnailImageView: UIImageView) {
    self.centerView = centerView
    self.thumbnailImageView = thumbnailImageView
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Actions
  @objc private func didTapStarButton(_ button: UIButton) {
    delegate?.didTapStarButton(button)
  }
}

// MARK: - Helpers
extension BaseDestinationView {
  func clearThumbnailImage() {
    thumbnailImageView.image = nil
  }
  
  func clearButtonSelectedState() {
    starButton.isSelected = false
  }
  
  func toggleStarButtonState() {
    starButton.isSelected.toggle()
  }
  
  func configure(centerModel: CenterView.ModelType) {
    centerView.configure(model: centerModel)
  }
  
  func configure(imageURL: String?, isSelectedButton: Bool) {
    thumbnailImageView.image = UIImage(named: imageURL ?? "tempProfile4")
    starButton.isSelected = isSelectedButton
  }
}

// MARK: - Private Helpers
extension BaseDestinationView {
  private func setupStyles() {
    thumbnailImageView.contentMode = .scaleToFill
  }
}
// MARK: - LayoutSupport
extension BaseDestinationView: LayoutSupport {
  func addSubviews() {
    _ = [
      thumbnailImageView,
      centerView,
      starButton
    ].map { self.addSubview($0) }
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalToSuperview().inset(Constants.ThumbnailImageView.Spacing.top)
      $0.bottom.equalToSuperview().inset(Constants.ThumbnailImageView.Spacing.bottom)
      $0.width.equalTo(thumbnailImageView.snp.height)
    }
    
    centerView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing)
        .offset(Constants.CenterView.Spacing.leading)
      $0.trailing.lessThanOrEqualTo(starButton.snp.leading)
        .offset(Constants.CenterView.Spacing.trailing)
      $0.top.equalTo(thumbnailImageView)
    }
    
    starButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constants.StarButton.Spacing.top)
      $0.trailing.equalToSuperview().inset(Constants.StarButton.Spacing.trailing)
      $0.size.equalTo(Constants.StarButton.size)
    }
  }
}

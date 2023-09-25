//
//  BaseDestinationView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/24.
//

import UIKit
import SnapKit

class BaseDestinationView<T: UIView & CellConfigurable>: UIView {
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
  private let thumbnailImageView = UIImageView()
  private let centerView: T
  private lazy var starButton: SearchStarButton = .init(normalType: .empty).set {
    $0.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
  }
  
  // MARK: - LifeCycle
  convenience init(centerView: T) {
    self.init(frame: .zero, centerView: centerView)
  }
  
  init(frame: CGRect, centerView: T) {
    self.centerView = centerView
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Actions
  @objc private func didTapStarButton(_ button: UIButton) {
    delegate?.didTapStarButton()
  }
}

// MARK: - Public Helpers
extension BaseDestinationView {
  func clearThumbnailImage() {
    thumbnailImageView.image = nil
  }
  
  func toggleStarButtonState() {
    starButton.isSelected.toggle()
  }
  
  func configure(centerModel: T.ModelType) {
    centerView.configure(model: centerModel)
  }
  
  func configure(imageURL: String?, isSelectedButton: Bool) {
    thumbnailImageView.image = UIImage(named: imageURL ?? "tempProfile4")
    starButton.isSelected = isSelectedButton
  }
}

// MARK: - LayoutSupport
extension BaseDestinationView: LayoutSupport {
  func addSubviews() {
    _ = [thumbnailImageView, centerView, starButton]
      .map { self.addSubview($0) }
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

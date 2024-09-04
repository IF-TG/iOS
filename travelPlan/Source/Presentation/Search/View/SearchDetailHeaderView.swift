//
//  SearchDetailHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/5/23.
//

import UIKit
import SnapKit

class SearchDetailHeaderView: UICollectionReusableView {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let titleLabel: UILabel = .init().set {
    $0.numberOfLines = 1
    $0.font = .init(pretendard: .bold_700(fontSize: 30))
    $0.text = "헤더 타이틀"
    $0.textColor = UIColor.yg.littleWhite
  }
  
  private lazy var categoryThumbnailImageView: UIImageView = .init().set {
    $0.roundCorners(
      cornerRadius: 10,
      cornerList: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    )
    $0.contentMode = .scaleAspectFill
    $0.layer.insertSublayer(self.imageGradientLayer, at: .zero)
  }
  
  private let imageGradientLayer: CAGradientLayer = .init().set {
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.yg.gray7.withAlphaComponent(0.5).cgColor
    ]
    $0.locations = [0.5, 1.0]
  }
  
  private var isImageLayerFrameSet = false
  
  override var bounds: CGRect {
    didSet {
      self.setImageLayerFrame()
    }
  }
  
  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    categoryThumbnailImageView.image = nil
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchDetailHeaderView {
  func configure(with model: SearchDetailHeaderInfo) {
    titleLabel.text = model.title
    let imageName: String
    
    switch model.searchSection {
    case .festival:
      imageName = "festival"
    case .leports:
      imageName = "leports"
    case .cultureFacility:
      imageName = "cultureFacility_searchMore"
    }
    
    categoryThumbnailImageView.image = UIImage(named: imageName)
  }
}

// MARK: - Private Helpers
extension SearchDetailHeaderView {
  private func setImageLayerFrame() {
    if !self.isImageLayerFrameSet {
      self.isImageLayerFrameSet = true
      self.imageGradientLayer.frame = self.bounds
    }
  }
}

// MARK: - LayoutSupport
extension SearchDetailHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(categoryThumbnailImageView)
    categoryThumbnailImageView.addSubview(titleLabel)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(25)
    }
    
    categoryThumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

//
//  SearchDetailHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/5/23.
//

import UIKit
import SnapKit

class SearchDetailHeaderView: UICollectionReusableView {
  enum Constants {
    enum TitleLabel {
      static let numberOfLines = 1
      static let fontSize: CGFloat = 30
      static let text = "헤더 타이틀"
      enum Spacing {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
        static let bottom: CGFloat = 25
      }
    }
    enum categoryThumbnailImageView {
      static let cornerRadius: CGFloat = 10
      enum Spacing {
        static let multipliedHeight: CGFloat = 0.25
      }
    }
    enum ImageGradientLayer {
      static let lastColorAlpha: CGFloat = 0.5
      static let firstLocation: NSNumber = 0.5
      static let secondLocation: NSNumber = 1.0
    }
  }
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let titleLabel: UILabel = .init().set {
    $0.numberOfLines = Constants.TitleLabel.numberOfLines
    $0.font = .init(pretendard: .bold, size: Constants.TitleLabel.fontSize)
    $0.text = Constants.TitleLabel.text
    $0.textColor = UIColor.yg.littleWhite
  }
  
  private lazy var categoryThumbnailImageView: UIImageView = .init().set {
    $0.roundCorners(
      cornerRadius: Constants.categoryThumbnailImageView.cornerRadius,
      cornerList: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    )
    $0.image = UIImage(named: "tempProfile1") // to erase
    $0.contentMode = .scaleAspectFill
    $0.layer.insertSublayer(self.imageGradientLayer, at: .zero)
  }
  
  private let imageGradientLayer: CAGradientLayer = .init().set {
    typealias Cnst = Constants.ImageGradientLayer
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.yg.gray7.withAlphaComponent(Cnst.lastColorAlpha).cgColor
    ]
    $0.locations = [
      Cnst.firstLocation,
      Cnst.secondLocation
    ]
  }
  
  override var bounds: CGRect {
    didSet {
      self.imageGradientLayer.frame = self.bounds
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
  func configure(with model: SearchDetailHeaderModel) {
    // TODO: - 추후 imageURL로 변경
    titleLabel.text = model.title
    categoryThumbnailImageView.image = UIImage(named: model.imageURL)
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
      $0.leading.equalToSuperview().inset(Constants.TitleLabel.Spacing.leading)
      $0.trailing.equalToSuperview().inset(Constants.TitleLabel.Spacing.trailing)
      $0.bottom.equalToSuperview().inset(Constants.TitleLabel.Spacing.bottom)
    }
    
    categoryThumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
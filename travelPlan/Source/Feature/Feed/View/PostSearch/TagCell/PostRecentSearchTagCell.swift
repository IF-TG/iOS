//
//  PostRecentSearchTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/29.
//

import UIKit
import SnapKit

final class PostRecentSearchTagCell: UICollectionViewCell {
  enum Constants {
    enum ContentView {
      static let borderWidth: CGFloat = 1
      static let cornerRadius: CGFloat = 15
    }
    
    enum TagLabel {
      enum Inset {
        static let leading: CGFloat = 10
        static let topBottom: CGFloat = 4
      }
      enum Offset {
        static let trailing: CGFloat = -4
      }
    }
    
    enum TagDeleteButton {
      enum Inset {
        static let trailing: CGFloat = 10
      }
      static let size: CGFloat = 18
      static let imageName = "cancel"
    }
    
    static let targetSizeHeight: CGFloat = DefaultPostSearchLayout
      .Constants.Recent.Item.absoluteHeight
    static let contentInsets: CGFloat = DefaultPostSearchLayout
      .Constants.Recent.Section.ContentInsets.leading + DefaultPostSearchLayout
      .Constants.Recent.Section.ContentInsets.trailing
  }
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
                
  private lazy var tagDeleteButton: UIButton = .init().set {
    $0.addTarget(self, action: #selector(didTaptagDeleteButton), for: .touchUpInside)
    $0.setImage(UIImage(named: Constants.TagDeleteButton.imageName), for: .normal)
    $0.tintColor = .yg.gray5
  }
  
  private let tagLabel = PostSearchTagLabel()
  
  weak var delegate: PostRecentSearchTagCellDelegate?
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFitting(layoutAttributes)
    
    layoutAttributes.frame.size.width = calculateTagSize(to: layoutAttributes)
    return layoutAttributes
  }
}

// MARK: - Configure
extension PostRecentSearchTagCell {
  func configure(_ text: String, delegate: PostRecentSearchTagCellDelegate?) {
    self.delegate = delegate
    tagLabel.text = text
  }
}

// MARK: - Helpers
extension PostRecentSearchTagCell {
  // label text가 길어져서 cell width가 최대 지정 width를 넘어간다면, cell width를 고정해줍니다.
  private func calculateTagSize(
    to layoutAttributes: UICollectionViewLayoutAttributes
  ) -> Double {
    let targetSize = CGSize(width: layoutAttributes.size.width, height: Constants.targetSizeHeight)

    // 현재 제약조건으로부터 가장 적절한 size를 계산합니다.
    let optimalSize = contentView.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .fittingSizeLevel,
      verticalFittingPriority: .required
    )

    // cell width가 최대 width를 넘어가면, cell width를 최대 width로 지정합니다.
    return min(optimalSize.width, UIScreen.main.bounds.width - Constants.contentInsets)
  }
  
  private func setupStyles() {
    contentView.backgroundColor = .yg.veryLightGray
    contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    contentView.layer.borderWidth = Constants.ContentView.borderWidth
    contentView.layer.cornerRadius = Constants.ContentView.cornerRadius
  }
}

extension PostRecentSearchTagCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(tagLabel)
    contentView.addSubview(tagDeleteButton)
  }
  
  func setConstraints() {
    tagLabel.snp.makeConstraints {
      typealias TagLabel = Constants.TagLabel
      $0.leading.equalToSuperview().inset(TagLabel.Inset.leading)
      $0.trailing.equalTo(tagDeleteButton.snp.leading).offset(TagLabel.Offset.trailing)
      $0.top.bottom.equalToSuperview().inset(TagLabel.Inset.topBottom)
    }
    
    tagDeleteButton.snp.makeConstraints {
      $0.size.equalTo(Constants.TagDeleteButton.size)
      $0.centerY.equalTo(tagLabel)
      $0.trailing.equalToSuperview().inset(Constants.TagDeleteButton.Inset.trailing)
    }
  }
}

// MARK: - Actions
extension PostRecentSearchTagCell {
  @objc private func didTaptagDeleteButton(_ button: UIButton) {
    delegate?.didTapTagDeleteButton(in: self)
  }
}

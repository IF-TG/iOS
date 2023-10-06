//
//  TitleWithButtonHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/30.
//

import UIKit
import SnapKit

final class TitleWithButtonHeaderView: UICollectionReusableView {
  enum Constants {
    enum HeaderLabel {
      static let fontSize: CGFloat = 25
      static let numberOfLines = 1
      enum Inset {
        static let top: CGFloat = 31
        static let bottom: CGFloat = 21
      }
      enum Offset {
        static let trailing: CGFloat = -15
      }
    }

    enum LookingMoreButton {
      static let title = "더보기"
      static let titleFontSize: CGFloat = 12
      static let imageName = "plus"
      static let cornerRadius: CGFloat = 14
      static let borderWidth: CGFloat = 1
      enum Inset {
        static let trailing: CGFloat = 4
      }
      static let width: CGFloat = 64
      static let height: CGFloat = 28
    }
  }
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }

  var sectionIndex: Int?
  
  weak var delegate: TitleWithButtonHeaderViewDelegate?
  
  private let headerLabel: UILabel = UILabel().set {
    $0.font = UIFont(pretendard: .bold, size: Constants.HeaderLabel.fontSize)
    $0.textColor = .yg.gray7
    $0.numberOfLines = Constants.HeaderLabel.numberOfLines
    $0.textAlignment = .left
    $0.text = "헤더 타이틀"
  }
  
  private lazy var lookingMoreButton: UIButton = .init().set {
    $0.setTitle(Constants.LookingMoreButton.title, for: .normal)
    $0.titleLabel?.font = .systemFont(
      ofSize: Constants.LookingMoreButton.titleFontSize,
      weight: .semibold
    )
    $0.setTitleColor(.yg.gray4, for: .normal)
    $0.setImage(UIImage(named: Constants.LookingMoreButton.imageName), for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.layer.cornerRadius = Constants.LookingMoreButton.cornerRadius
    $0.layer.borderColor = UIColor.yg.gray0.cgColor
    $0.layer.borderWidth = Constants.LookingMoreButton.borderWidth
    $0.addTarget(self, action: #selector(didTapLookingMoreButton), for: .touchUpInside)
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    headerLabel.text = nil
    sectionIndex = nil
  }
}

// MARK: - Public Helpers
extension TitleWithButtonHeaderView {
  func configure(title: String) {
    headerLabel.text = title
  }
}

// MARK: - Actions
extension TitleWithButtonHeaderView {
  @objc private func didTapLookingMoreButton() {
    guard let sectionIndex = sectionIndex else { return }
    delegate?.didTaplookingMoreButton(in: sectionIndex)
  }
}

// MARK: - LayoutSupport
extension TitleWithButtonHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(headerLabel)
    addSubview(lookingMoreButton)
  }
  
  func setConstraints() {
    headerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.lessThanOrEqualTo(lookingMoreButton.snp.leading)
        .offset(Constants.HeaderLabel.Offset.trailing)
      $0.top.equalToSuperview().inset(Constants.HeaderLabel.Inset.top)
      $0.bottom.equalToSuperview().inset(Constants.HeaderLabel.Inset.bottom)
    }
    
    lookingMoreButton.snp.makeConstraints {
      $0.top.equalTo(headerLabel)
      $0.width.equalTo(Constants.LookingMoreButton.width)
      $0.height.equalTo(Constants.LookingMoreButton.height)
      $0.trailing.equalToSuperview()
        .inset(Constants.LookingMoreButton.Inset.trailing)
    }
  }
}

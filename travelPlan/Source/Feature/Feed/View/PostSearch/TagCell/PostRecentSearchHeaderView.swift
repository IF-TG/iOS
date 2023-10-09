//
//  PostRecentSearchHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit
import Combine

// SectionTypeFIXME: - HeaderView는 sectionType을 알 필요가 없기 때문에, 제거해야 합니다.
final class PostRecentSearchHeaderView: UICollectionReusableView {
  enum Constants {
    enum TitleLabel {
      static let fontSize: CGFloat = 17
    }
    enum DeleteAllButton {
      static let title = "전체 삭제"
      static let titleFontSize: CGFloat = 12
      enum Inset {
        static let trailing: CGFloat = 10
      }
    }
  }
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let titleLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .bold, size: Constants.TitleLabel.fontSize)
    $0.textColor = .yg.gray6
  }
  
  private lazy var deleteAllButton: UIButton = .init().set {
    $0.setTitle(Constants.DeleteAllButton.title, for: .normal)
    $0.setTitleColor(.yg.gray4, for: .normal)
    $0.titleLabel?.font = .systemFont(
      ofSize: Constants.DeleteAllButton.titleFontSize,
      weight: .semibold
    )
    $0.addTarget(
      self, action: #selector(didTapDeleteAllButton),
      for: .touchUpInside
    )
  }
  
  weak var delegate: PostSearchHeaderViewDelegate?
  
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
    prepare(title: nil)
  }
}

// MARK: - Public Helpers
extension PostRecentSearchHeaderView {
  func prepare(title: String?) {
    titleLabel.text = title
  }
}

// MARK: - Actions
extension PostRecentSearchHeaderView {
  @objc private func didTapDeleteAllButton(_ button: UIButton) {
    delegate?.didTapDeleteAllButton()
  }
}

// MARK: - LayoutSupport
extension PostRecentSearchHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(deleteAllButton)
    addSubview(titleLabel)
  }
  
  func setConstraints() {
    deleteAllButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(Constants.DeleteAllButton.Inset.trailing)
    }
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
  }
}

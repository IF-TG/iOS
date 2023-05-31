//
//  PostSearchHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit
import Combine

final class PostSearchHeaderView: UICollectionReusableView {
  typealias SectionType = PostSearchSectionItemModel.SectionType
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }

  var sectionType: SectionType?
  
  private let titleLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .bold, size: 17)
    $0.textColor = .yg.gray6
  }
  
  private var deleteAllButton: UIButton?
  weak var delegate: PostSearchHeaderViewDelegate?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
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
extension PostSearchHeaderView {
  func prepare(title: String?) {
    titleLabel.text = title
  }
  
  func initSectionType(with sectionType: SectionType) {
    switch self.sectionType {
    case .none:
      self.sectionType = sectionType
      setupUI()
    case .recommendation, .recent: return
    }
  }
}

// MARK: - Helpers
extension PostSearchHeaderView {
  private func makeDeleteAllButton() -> UIButton {
    let button = UIButton()
    deleteAllButton = button
    
    button.setTitle("전체 삭제", for: .normal)
    button.setTitleColor(.yg.gray4, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    button.addTarget(self, action: #selector(didTapDeleteAllButton), for: .touchUpInside)

    return button
  }
}

// MARK: - Actions
extension PostSearchHeaderView {
  @objc private func didTapDeleteAllButton(_ button: UIButton) {
    delegate?.didTapDeleteAllButton()
  }
}

// MARK: - LayoutSupport
extension PostSearchHeaderView: LayoutSupport {
  func addSubviews() {
    switch sectionType {
    case .recent:
      // 최근 검색인 경우 전체삭제 버튼 추가
      addSubview(makeDeleteAllButton())
      fallthrough
    case .recommendation:
      addSubview(titleLabel)
    case .none: break
    }
  }
  
  func setConstraints() {
    switch sectionType {
    case .recent:
      guard let button = deleteAllButton else { return }
      
      button.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.trailing.equalToSuperview().inset(30)
      }
      fallthrough
    case .recommendation:
      titleLabel.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.leading.equalToSuperview().inset(20)
      }
    case .none: break
    }
  }
}

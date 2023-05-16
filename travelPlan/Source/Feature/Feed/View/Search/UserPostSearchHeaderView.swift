//
//  UserPostSearchHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit

final class UserPostSearchHeaderView: UICollectionReusableView {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  var sectionType: SearchSection?
  
  // FontFIXME: - PretendardVariable-Bold
  private let titleLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 17, weight: .bold) // weight 수정
    $0.textColor = UIColor(hex: "4B4B4B")
  }
  
  private var deleteAllButton: UIButton?
  
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
extension UserPostSearchHeaderView {
  func prepare(title: String?) {
    titleLabel.text = title
  }
  
  func initSectionType(with type: SearchSection) {
    switch sectionType {
    case .none:
      self.sectionType = type
      setupUI()
    case .recommendation, .recent: return
    }
  }
}

// MARK: - Helpers
extension UserPostSearchHeaderView {
  private func makeDeleteAllButton() -> UIButton {
    self.deleteAllButton = UIButton()
    guard let button = self.deleteAllButton else { return UIButton() }
    
    button.setTitle("전체 삭제", for: .normal)
    button.setTitleColor(UIColor(hex: "676767"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    button.addTarget(self, action: #selector(didTapDeleteAllButton), for: .touchUpInside)
    return button
  }
}

// MARK: - Actions
extension UserPostSearchHeaderView {
  @objc private func didTapDeleteAllButton(_ button: UIButton) {
    print("최근 검색 기록 전체 삭제!")
  }
}

// MARK: - LayoutSupport
extension UserPostSearchHeaderView: LayoutSupport {
  func addSubviews() {
    switch sectionType {
    case .recent:
      let deleteAllButton = makeDeleteAllButton() // 최근 검색인 경우 전체삭제 버튼 추가
      
      self.addSubview(deleteAllButton)
      fallthrough
    case .recommendation:
      self.addSubview(titleLabel)
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

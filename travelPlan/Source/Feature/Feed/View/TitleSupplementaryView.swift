//
//  TitleSupplementaryView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit

final class TitleSupplementaryView: UICollectionReusableView {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  // FontFIXME: - PretendardVariable-Bold
  private let titleLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 17, weight: .semibold) // weight 수정
    $0.text = "추천 검색"
    $0.textColor = UIColor(hex: "4B4B4B")
  }
  
  private var deleteAllButton: UIButton?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
//    self.backgroundColor = .systemPink
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

// MARK: - Helpers
extension TitleSupplementaryView {
  func prepare(title: String?) {
    titleLabel.text = title
  }
}

// MARK: - LayoutSupport
extension TitleSupplementaryView: LayoutSupport {
  func addSubviews() {
    self.addSubview(titleLabel)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(20)
    }
  }
}

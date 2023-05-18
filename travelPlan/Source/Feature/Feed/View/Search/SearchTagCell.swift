//
//  SearchTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit

class SearchTagCell: UICollectionViewCell {
  // MARK: - Properties
  var sectionType: SearchSection?
  
  static var id: String {
    return String(describing: self)
  }
  
  let tagLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .black
    $0.numberOfLines = 1
    $0.lineBreakMode = .byClipping
  }
  
  private var deleteButton: UIButton?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchTagCell {
  private func setupStyles() {
    self.contentView.backgroundColor = .systemBackground
    self.contentView.layer.cornerRadius = 13
    self.contentView.layer.borderColor = UIColor(hex: "D9D9D9").cgColor
    self.contentView.layer.borderWidth = 1
  }
  
  private func makeDeleteButton() -> UIButton {
    self.deleteButton = UIButton()
    guard let deleteButton = self.deleteButton else { return UIButton() }
    deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    deleteButton.tintColor = UIColor(hex: "#484848")
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    return deleteButton
  }
}

// MARK: - Public Helpers
extension SearchTagCell {
  func configure(_ text: String) {
    tagLabel.text = text
  }
  
  func initSectionType(with type: SearchSection) {
    switch sectionType {
    case .none:
      sectionType = type
      setupUI()
    case .recent, .recommendation: return
    }
  }
}

// MARK: - Actions
extension SearchTagCell {
  @objc private func didTapDeleteButton(_ button: UIButton) {
    // DeleteCellTODO: 선택된 최근 검색 cell 삭제
    print("delete button Tapped")
  }
}

// MARK: - LayoutSupport
extension SearchTagCell: LayoutSupport {
  func addSubviews() {
    switch sectionType {
    case .recent:
      // delete Button 추가
      let deleteButton = makeDeleteButton()
      self.contentView.addSubview(deleteButton)
      fallthrough
    case .recommendation: self.contentView.addSubview(tagLabel)
    case .none: break
    }
  }
  
  func setConstraints() {
    switch sectionType {
    case .recommendation:
      tagLabel.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(13)
        $0.trailing.equalToSuperview().inset(13)
        $0.centerY.equalToSuperview()
      }
    case .recent:
      guard let deleteButton = deleteButton else { return }
      
      tagLabel.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(13)
        $0.centerY.equalToSuperview()
      }
      
      deleteButton.snp.makeConstraints {
        $0.leading.equalTo(tagLabel.snp.trailing).offset(4)
        $0.trailing.equalToSuperview().inset(13)
        $0.centerY.equalTo(tagLabel)
        $0.size.equalTo(10)
      }
    case .none: break
    }
  }
}

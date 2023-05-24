//
//  SearchTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit

class SearchTagCell: UICollectionViewCell {
  typealias SectionType = SearchSectionItemModel.SectionType
  
  // MARK: - Properties
  var sectionType: SectionType?
  weak var delegate: SearchTagCellDelegate?
  
  static var id: String {
    return String(describing: self)
  }
  
  private let tagLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .black
    $0.numberOfLines = 1
    $0.lineBreakMode = .byClipping
  }
  
  var deleteButton: UIButton?
  
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
    self.contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.cornerRadius = 13
  }
  
  private func makeDeleteButton() -> UIButton {
    self.deleteButton = UIButton()
    guard let deleteButton = self.deleteButton else { return UIButton() }
    deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    deleteButton.tintColor = .yg.gray5
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    return deleteButton
  }
}

// MARK: - Public Helpers
extension SearchTagCell {
  func configure(_ text: String) {
    self.tagLabel.text = text
  }
  
  func initSectionType(with sectionType: SectionType) {
    switch self.sectionType {
    case .none:
      self.sectionType = sectionType
      setupUI()
    case .recent, .recommendation: return
    }
  }
}

// MARK: - Actions
extension SearchTagCell {
  @objc private func didTapDeleteButton(_ button: UIButton) {
    // DeleteCellTODO: 선택된 최근 검색 cell 삭제
    self.delegate?.didTapDeleteButton(
      item: button.tag,
      in: sectionType?.rawValue ?? SectionType.recent.rawValue
    )
  }
}

// MARK: - LayoutSupport
extension SearchTagCell: LayoutSupport {
  func addSubviews() {
    switch self.sectionType {
    case .recent:
      // delete Button 추가
      let deleteButton = makeDeleteButton()
      self.contentView.addSubview(deleteButton)
      fallthrough
    case .recommendation: self.contentView.addSubview(self.tagLabel)
    case .none: break
    }
  }
  
  func setConstraints() {
    switch self.sectionType {
    case .recommendation:
      self.tagLabel.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(13)
        $0.trailing.equalToSuperview().inset(13)
        $0.centerY.equalToSuperview()
      }
    case .recent:
      guard let deleteButton = self.deleteButton else { return }
      
      self.tagLabel.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(13)
        $0.centerY.equalToSuperview()
      }
      
      deleteButton.snp.makeConstraints {
        $0.leading.equalTo(self.tagLabel.snp.trailing).offset(4)
        $0.trailing.equalToSuperview().inset(13)
        $0.centerY.equalTo(self.tagLabel)
        $0.size.equalTo(10)
      }
    case .none: break
    }
  }
}

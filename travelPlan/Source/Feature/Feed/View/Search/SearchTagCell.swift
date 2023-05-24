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
    contentView.backgroundColor = .systemBackground
    contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    contentView.layer.borderWidth = 1
    contentView.layer.cornerRadius = 13
  }
  
  private func makeDeleteButton() -> UIButton {
    deleteButton = UIButton()
    guard let deleteButton = deleteButton else { return UIButton() }
    deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    deleteButton.tintColor = .yg.gray5
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    return deleteButton
  }
}

// MARK: - Public Helpers
extension SearchTagCell {
  func configure(_ text: String) {
    tagLabel.text = text
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
    delegate?.didTapDeleteButton(
      item: button.tag,
      in: sectionType?.rawValue ?? SectionType.recent.rawValue
    )
  }
}

// MARK: - LayoutSupport
extension SearchTagCell: LayoutSupport {
  func addSubviews() {
    switch sectionType {
    case .recent:
      // delete Button 추가
      let deleteButton = makeDeleteButton()
      contentView.addSubview(deleteButton)
      fallthrough
    case .recommendation: contentView.addSubview(tagLabel)
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

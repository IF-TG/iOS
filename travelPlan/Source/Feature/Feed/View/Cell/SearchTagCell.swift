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
  
  private let tagLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .black
    $0.numberOfLines = 1
    $0.lineBreakMode = .byClipping
  }
  
  private var cancelButton: UIButton?
  
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
  
  private func makeCancelButton() -> UIButton {
    self.cancelButton = UIButton()
    guard let cancelButton = self.cancelButton else { return UIButton() }
    cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    cancelButton.tintColor = UIColor(hex: "#484848")
    return cancelButton
  }
  
  func configure(_ text: String) {
    tagLabel.text = text
  }
  
  func initSectionType(with type: SearchSection) {
    switch sectionType {
    case .none:
      self.sectionType = type
      setupUI()
    case .recent, .recommendation: return
    }
  }
}

// MARK: - LayoutSupport
extension SearchTagCell: LayoutSupport {
  func addSubviews() {
    switch sectionType {
    case .recent:
      // Cancel Button 추가
      let cancelButton = makeCancelButton()
      self.contentView.addSubview(cancelButton)
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
      guard let cancelButton = cancelButton else { return }
      
      tagLabel.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(13)
        $0.centerY.equalToSuperview()
      }
      
      cancelButton.snp.makeConstraints {
        $0.leading.equalTo(tagLabel.snp.trailing).offset(4)
        $0.trailing.equalToSuperview().inset(13)
        $0.centerY.equalTo(tagLabel)
        $0.size.equalTo(10)
      }
    case .none: break
    }
  }
}

//protocol CancelButtonDelegate: AnyObject {
//  func
//}

//
//  SearchTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit

class SearchTagCell: UICollectionViewCell {
  // MARK: - Properties
  var type: SearchSection?
  
  static var id: String {
    return String(describing: self)
  }
  
  private let tagLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .black
  }
  
  private var cancelButton: UIButton?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    contentView.backgroundColor = .systemBackground
    contentView.layer.cornerRadius = 13
    contentView.layer.borderColor = UIColor(hex: "D9D9D9").cgColor
    contentView.layer.borderWidth = 1
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupUI()
  }
}

// MARK: - Helpers
extension SearchTagCell {
  func configure(_ text: String) {
    tagLabel.text = text
  }
}

// MARK: - LayoutSupport
extension SearchTagCell: LayoutSupport {
  func addSubviews() {
    self.contentView.addSubview(tagLabel)
//    if type == .recent {
//      self.cancelButton = UIButton(type: .close)
//      guard let cancelButton = self.cancelButton else { return }
//      self.contentView.addSubview(cancelButton)
//    }
  }
  
  func setConstraints() {
    tagLabel.snp.makeConstraints {
      $0.center.equalToSuperview() // case .recommendation: center 고정
    }
    
    
    //    switch type {
    //    case .recommendation:
    //      tagLabel.snp.makeConstraints {
    ////        $0.centerX.equalToSuperview()
    ////        $0.leading.equalToSuperview().inset(13)
    ////        $0.centerY.equalToSuperview()
    ////        $0.top.equalToSuperview().inset(4)
    //        $0.center.equalToSuperview()
    //      }
    //    case .recent: break
    ////      tagLabel.snp.makeConstraints {
    ////        $0.leading.equalToSuperview().inset(13)
    ////        $0.centerY.equalToSuperview()
    ////        $0.top.equalToSuperview().inset(4)
    ////      }
    ////
    ////      guard let cancelButton = cancelButton else { return }
    ////
    ////      cancelButton.snp.makeConstraints {
    ////        $0.leading.equalTo(tagLabel.snp.trailing).offset(4)
    ////        $0.centerY.equalTo(tagLabel)
    ////      }
    //    case .none: break
    //    }
  }
}

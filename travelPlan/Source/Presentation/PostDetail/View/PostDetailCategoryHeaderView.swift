//
//  PostDetailCategoryHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import UIKit

final class PostDetailCategoryHeaderView: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailCategoryHeaderView.self)
  
  // MARK: - Properties
  private let categoryLabel = BasePaddingLabel(
    padding: .init(top: 16.5, left: 20, bottom: 8.5, right: 20),
    fontType: .medium_500(fontSize: 14),
    lineHeight: 16.71
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.lineBreakMode = .byTruncatingTail
    $0.textColor = .yg.gray4
  }
  
  weak var delegate: PostDetailCategoryHeaderViewDelegate?
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
}

// MARK: - Helpers
extension PostDetailCategoryHeaderView {
  func configure(with text: String?) {
    categoryLabel.text = text
    
    if let text {
      let textArr = text.map { String($0) }
      var currentIdx = 0
      var highlightFontInfoList: [HighlightFontInfo] = []
      
      /// 텍스트에서 " > " 문구의 위치를 찾아서 강조합니다.
      while let idx = textArr[(currentIdx+1)...].firstIndex(of: ">") {
        currentIdx = idx
        let chevronHighlight = HighlightFontInfo(fontType: .bold_700(fontSize: 13), text: ">", startIndex: idx)
        highlightFontInfoList.append(chevronHighlight)
        if currentIdx + 1 >= textArr.count { break }
      }
      if highlightFontInfoList.count > 0 {
        categoryLabel.setHighlights(with: highlightFontInfoList)
      }
    }
  }
}

// MARK: - Private Helpers
private extension PostDetailCategoryHeaderView {
  func configureUI() {
    setupUI()
    setTapGestureInCategoryLabel()
  }
  
  func setTapGestureInCategoryLabel() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCategoryLabel))
    categoryLabel.isUserInteractionEnabled = true
    categoryLabel.addGestureRecognizer(tap)
  }
}

// MARK: - Actions
private extension PostDetailCategoryHeaderView {
  @objc func didTapCategoryLabel(_ sender: UITapGestureRecognizer) {
    delegate?.didTapCategoryHeaderView(sender)
  }
}

// MARK: - LayoutSupport
extension PostDetailCategoryHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(categoryLabel)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      categoryLabel.topAnchor.constraint(equalTo: topAnchor),
      categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
  }
}

//
//  PostSearchTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit
import SnapKit

final class PostSearchTagCell: UICollectionViewCell {
  typealias SectionType = PostSearchSectionItemModel.SectionType
  
  // MARK: - Properties
  var sectionType: SectionType?
  weak var delegate: PostSearchTagCellDelegate?
  
  static var id: String {
    return String(describing: self)
  }
  
  private let tagLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: Constants.TagLabel.fontSize)
    $0.textColor = .black
    $0.numberOfLines = Constants.TagLabel.numberOfLines
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
extension PostSearchTagCell {
  private func setupStyles() {
    contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    contentView.layer.borderWidth = Constants.ContentView.borderWidth
    contentView.layer.cornerRadius = Constants.ContentView.cornerRadius
  }
  
  private func makeDeleteButton() -> UIButton {
    deleteButton = UIButton()
    guard let deleteButton = deleteButton else { return UIButton() }
    deleteButton.setImage(UIImage(systemName: Constants.DeleteButton.imageName), for: .normal)
    deleteButton.tintColor = .yg.gray5
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    return deleteButton
  }
}

// MARK: - Helpers
extension PostSearchTagCell {
  private func tagLabelCommonConstraints(_ maker: ConstraintMaker) {
    maker.leading.equalToSuperview().inset(Constants.TagLabel.Inset.leading)
    maker.top.bottom.equalToSuperview().inset(Constants.TagLabel.Inset.top)
  }
}

// MARK: - Public Helpers
extension PostSearchTagCell {
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
  
  func setBackgroundColor(with section: Int) {
    switch section {
    case SectionType.recommendation.rawValue:
      contentView.backgroundColor = UIColor(hex: Constants.Recommendation.backgroundColor)
        .withAlphaComponent(Constants.Recommendation.alphaComponent)
    case SectionType.recent.rawValue:
      contentView.backgroundColor = .yg.veryLightGray
    default:
      contentView.backgroundColor = .white
    }
  }
}

// MARK: - Actions
extension PostSearchTagCell {
  @objc private func didTapDeleteButton(_ button: UIButton) {
    delegate?.didTapDeleteButton(
      item: button.tag,
      in: sectionType?.rawValue ?? SectionType.recent.rawValue
    )
  }
}

// MARK: - LayoutSupport
extension PostSearchTagCell: LayoutSupport {
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
        $0.trailing.equalToSuperview().inset(Constants.TagLabel.Inset.trailing)
        tagLabelCommonConstraints($0)
      }
    case .recent:
      guard let deleteButton = deleteButton else { return }
      tagLabel.snp.makeConstraints {
        tagLabelCommonConstraints($0)
      }
      
      deleteButton.snp.makeConstraints {
        $0.leading.equalTo(tagLabel.snp.trailing).offset(Constants.DeleteButton.Offset.leading)
        $0.trailing.equalToSuperview().inset(Constants.DeleteButton.Inset.trailing)
        $0.centerY.equalToSuperview()
        $0.width.equalTo(Constants.DeleteButton.Size.width)
        $0.height.equalTo(Constants.DeleteButton.Size.height)
      }
    case .none: break
    }
  }
}

//
//  MoreCaterogyView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class MoreCategoryView: UIView {
  // MARK: - Properties
  weak var delegate: MoreCategoryViewDelegate?
  
  private let moreIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(
      named: Constant.MoreIcon.iconName)
    $0.contentMode = .scaleAspectFit
  }
  
  private var isSelected: Bool = false {
    didSet {
      animateMoreIcon()
    }
  }
  
  private let categoryLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = Constant.CategoryLabel.color
    $0.text = ""
    $0.font = .systemFont(ofSize: Constant.CategoryLabel.fontSize)
    $0.sizeToFit()
  }
  
  private var categoryType: TravelCategorySortingType = .detailCategory
  
  // MARK: - LifeCycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderWidth = Constant.boarderSize
    layer.cornerRadius = Constant.radius
    layer.borderColor = Constant.color.cgColor
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}

extension MoreCategoryView {
  @objc func didTapView() {
    isSelected.toggle()
    delegate?.moreCategoryView(
      self,
      didSelectedType: categoryType)
  }
}

// MARK: - Helper
extension MoreCategoryView {
  func configure(with type: TravelCategorySortingType) {
    categoryLabel.text = type.rawValue
    categoryType = type
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    addGestureRecognizer(tap)
  }
}

// MARK: - Private helper
private extension MoreCategoryView {
  func animateMoreIcon() {
    guard isSelected else {
      UIView.animate(withDuration: 0.2) {
        self.moreIcon.transform = .identity
      }
      return
    }
    UIView.animate(withDuration: 0.2) {
      self.moreIcon.transform = .init(rotationAngle: 1)
    }
    
  }
}

// MARK: - LayoutSupport
extension MoreCategoryView: LayoutSupport {
  func addSubviews() {
    _=[categoryLabel, moreIcon].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[categoryLabelConstraints,
       moreIconConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}
// MARK: - Layout support helper
private extension MoreCategoryView {
  var categoryLabelConstraints: [NSLayoutConstraint] {
    [categoryLabel.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.CategoryLabel.spacing.leading),
     categoryLabel.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.CategoryLabel.spacing.top),
     categoryLabel.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.CategoryLabel.spacing.bottom)]
  }

  var moreIconConstraints: [NSLayoutConstraint] {
    [moreIcon.leadingAnchor.constraint(
      equalTo: categoryLabel.trailingAnchor,
      constant: Constant.MoreIcon.spacing.leading),
     moreIcon.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.MoreIcon.spacing.top),
     moreIcon.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.MoreIcon.spacing.bottom),
     moreIcon.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.MoreIcon.spacing.trailing),
     moreIcon.heightAnchor.constraint(
      equalToConstant: Constant.MoreIcon.size.height),
     moreIcon.widthAnchor.constraint(
      equalToConstant: Constant.MoreIcon.size.width)]
  }
}

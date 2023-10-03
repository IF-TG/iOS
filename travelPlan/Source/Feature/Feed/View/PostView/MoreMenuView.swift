//
//  MoreMenuView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class MoreMenuView: UICollectionReusableView {
  static let id = String(describing: MoreMenuView.self)
  
  enum Constant {
    static let selectedBorderColor: UIColor = .YG.gray3
    static let selectedBGColor: UIColor = .yg.gray3
    static let deselectedBorderColor: UIColor = .yg.littleWhite
    static let deselectedBGColor: UIColor = .yg.gray3
    static let boarderSize: CGFloat = 0.8
    static let radius: CGFloat = 15
    
    enum MoreIcon {
      enum Inset {
        static let leading: CGFloat = 3
        static let trailing: CGFloat = 10
        static let top: CGFloat = 5
        static let bottom: CGFloat = 5
      }
      static let size: CGSize = .init(
        width: 20, height: 20)
      static let iconName = "feedMore"
      static let selectedColor: UIColor = .yg.littleWhite
      static let deselectedColor: UIColor = . yg.gray3
    }

    enum MenuLabel {
      enum Inset {
        static let leading: CGFloat = 10
        static let top: CGFloat = 7
        static let bottom: CGFloat = 7
      }
      static let fontSize: CGFloat = 13
      static let selectedTextColor: UIColor = .yg.littleWhite
      static let deselectedTextColor: UIColor = .yg.gray3
    }
  }
  // MARK: - Properties
  weak var delegate: MoreMenuViewDelegate?
  
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
  
  private let menuLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = Constant.MenuLabel.deselectedTextColor
    $0.text = ""
    $0.font = .systemFont(ofSize: Constant.MenuLabel.fontSize)
    $0.sizeToFit()
  }
  
  private(set) var categoryType: TravelCategorySortingType = .detailCategory(.all)
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Helpers
extension MoreMenuView {
  func configure(with type: TravelCategorySortingType) {
    menuLabel.text = type.rawValue
    categoryType = type
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    addGestureRecognizer(tap)
  }
}

// MARK: - Private helpers
private extension MoreMenuView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderWidth = Constant.boarderSize
    layer.cornerRadius = Constant.radius
    layer.borderColor = Constant.deselectedBorderColor.cgColor
    menuLabel.textColor = Constant.MenuLabel.deselectedTextColor
    moreIcon.tintColor = Constant.MoreIcon.deselectedColor
    setupUI()
  }
  
  func animateMoreIcon() {
    guard isSelected else {
      UIView.animate(withDuration: 0.3) {
        self.setDeselectedMoreIcon()
      }
      return
    }
    UIView.animate(withDuration: 0.3) {
      self.setSelectedMoreIcon()
    }
  }
  
  func setSelectedMoreIcon() {
    moreIcon.transform = moreIcon.transform.rotated(by: .pi)
    moreIcon.tintColor = Constant.MoreIcon.selectedColor
    layer.borderColor = Constant.selectedBorderColor.cgColor
    backgroundColor = Constant.selectedBGColor
    menuLabel.textColor = Constant.MenuLabel.selectedTextColor
  }
  
  func setDeselectedMoreIcon() {
    moreIcon.transform = .identity
    moreIcon.tintColor = Constant.MoreIcon.deselectedColor
    layer.borderColor = Constant.deselectedBorderColor.cgColor
    backgroundColor = Constant.deselectedBGColor
    menuLabel.textColor = Constant.MenuLabel.deselectedTextColor
  }
}

// MARK: - Actions
extension MoreMenuView {
  @objc func didTapView() {
    isSelected.toggle()
    delegate?.moreMenuView(
      self,
      didSelectedType: categoryType)
  }
}

// MARK: - LayoutSupport
extension MoreMenuView: LayoutSupport {
  func addSubviews() {
    _=[
      menuLabel,
      moreIcon
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[categoryLabelConstraints,
       moreIconConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - Layout support helper
private extension MoreMenuView {
  var categoryLabelConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.MenuLabel.Inset
    return [
      menuLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Inset.leading),
      menuLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Inset.top),
      menuLabel.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Inset.bottom)]
  }
  
  var moreIconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.MoreIcon
    typealias Inset = Const.Inset
    return [
      moreIcon.leadingAnchor.constraint(
        equalTo: menuLabel.trailingAnchor,
        constant: Inset.leading),
      moreIcon.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Inset.top),
      moreIcon.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Inset.bottom),
      moreIcon.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Inset.trailing),
      moreIcon.heightAnchor.constraint(
        equalToConstant: Const.size.height),
      moreIcon.widthAnchor.constraint(
        equalToConstant: Const.size.width)]
  }
}

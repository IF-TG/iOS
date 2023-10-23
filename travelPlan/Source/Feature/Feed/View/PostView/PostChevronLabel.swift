//
//  PostChevronLabel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostChevronLabel: UIView {
  enum Constant {
    static let selectedBorderColor: UIColor = .YG.gray3
    static let selectedBGColor: UIColor = .yg.gray3
    static let deselectedBorderColor: UIColor = .yg.littleWhite
    static let deselectedBGColor: UIColor = .yg.gray3
    static let boarderSize: CGFloat = 0.8
    static let radius: CGFloat = 15
    enum ChevronIcon {
      enum Inset {
        static let leading: CGFloat = 3
        static let trailing: CGFloat = 10
        static let top: CGFloat = 5
        static let bottom: CGFloat = 5
      }
      static let size: CGSize = .init(width: 20, height: 20)
      static let iconName = "feedChevron"
      static let selectedColor: UIColor = .yg.littleWhite
      static let deselectedColor: UIColor = . yg.gray3
    }

    enum Label {
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
  private let chevronIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: Constant.ChevronIcon.iconName)
    $0.contentMode = .scaleAspectFit
  }
  
  private let label = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = Constant.Label.deselectedTextColor
    $0.text = ""
    $0.font = .systemFont(ofSize: Constant.Label.fontSize)
    $0.sizeToFit()
  }
  
  weak var delegate: MoreMenuViewDelegate?
  
  private var isSelected: Bool = false {
    didSet {
      animateMoreIcon()
    }
  }
  
  private(set) var sortingType: TravelCategorySortingType!
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension PostChevronLabel {
  func configure(with type: TravelCategorySortingType) {
    sortingType = type
    label.text = sortingType.rawValue
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    addGestureRecognizer(tap)
  }
}

// MARK: - Private helpers
private extension PostChevronLabel {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderWidth = Constant.boarderSize
    layer.cornerRadius = Constant.radius
    layer.borderColor = Constant.deselectedBorderColor.cgColor
    label.textColor = Constant.Label.deselectedTextColor
    chevronIcon.tintColor = Constant.ChevronIcon.deselectedColor
    setupUI()
  }
  
  func animateMoreIcon() {
    guard isSelected else {
      UIView.animate(withDuration: 0.3) {
        self.setDeselectedAppearance()
      }
      return
    }
    UIView.animate(withDuration: 0.3) {
      self.setSelectedAppearance()
    }
  }
  
  func setSelectedAppearance() {
    chevronIcon.transform = chevronIcon.transform.rotated(by: .pi)
    chevronIcon.tintColor = Constant.ChevronIcon.selectedColor
    layer.borderColor = Constant.selectedBorderColor.cgColor
    backgroundColor = Constant.selectedBGColor
    label.textColor = Constant.Label.selectedTextColor
  }
  
  func setDeselectedAppearance() {
    chevronIcon.transform = .identity
    chevronIcon.tintColor = Constant.ChevronIcon.deselectedColor
    layer.borderColor = Constant.deselectedBorderColor.cgColor
    backgroundColor = Constant.deselectedBGColor
    label.textColor = Constant.Label.deselectedTextColor
  }
}

// MARK: - Actions
extension PostChevronLabel {
  @objc func didTapView() {
    isSelected.toggle()
    delegate?.moreMenuView(self, didSelectedType: sortingType)
  }
}

// MARK: - LayoutSupport
extension PostChevronLabel: LayoutSupport {
  func addSubviews() {
    _=[
      label,
      chevronIcon
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
private extension PostChevronLabel {
  var categoryLabelConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.Label.Inset
    return [
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Inset.leading),
      label.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Inset.bottom)]
  }
  
  var moreIconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.ChevronIcon
    typealias Inset = Const.Inset
    return [
      chevronIcon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: Inset.leading),
      chevronIcon.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
      chevronIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Inset.bottom),
      chevronIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Inset.trailing),
      chevronIcon.heightAnchor.constraint(equalToConstant: Const.size.height),
      chevronIcon.widthAnchor.constraint(equalToConstant: Const.size.width)]
  }
}

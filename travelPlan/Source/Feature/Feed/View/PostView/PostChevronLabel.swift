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
    static let selectedTextColor: UIColor = .yg.littleWhite
    static let deselectedBorderColor: UIColor = .yg.gray0
    static let deselectedBGColor: UIColor = .yg.littleWhite
    static let deselectedTextColor: UIColor = .yg.gray3
    static let boarderSize: CGFloat = 0.8
    enum ChevronIcon {
      enum Spacing {
        static let leading: CGFloat = 2
        static let trailing: CGFloat = 8
      }
      static let size: CGSize = .init(width: 15, height: 15)
      static let iconName = "feedChevron"
    }

    enum Label {
      enum Spacing {
        static let leading: CGFloat = 8
        static let top: CGFloat = 6
        static let bottom: CGFloat = 6
      }
      static let fontSize: CGFloat = 12
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
    $0.textColor = Constant.deselectedTextColor
    $0.text = ""
    $0.font = .init(pretendard: .medium, size: 12)
    $0.sizeToFit()
  }
  
  weak var delegate: MoreMenuViewDelegate?
  
  private var isSelected: Bool = false {
    didSet {
      animateChevronIcon()
    }
  }
  
  private(set) var sortingType: TravelCategorySortingType!
  
  private var isBoundsSet = false
  
  override var bounds: CGRect {
    didSet {
      if !isBoundsSet {
        isBoundsSet.toggle()
        layer.cornerRadius = bounds.height/2
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 14)
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
      }
    }
  }
  
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
    layer.borderColor = Constant.deselectedBorderColor.cgColor
    backgroundColor = UIColor.white
    chevronIcon.tintColor = Constant.deselectedBGColor
    setupUI()
  }
  
  func animateChevronIcon() {
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
    chevronIcon.tintColor = Constant.selectedTextColor
    layer.borderColor = Constant.selectedBorderColor.cgColor
    backgroundColor = Constant.selectedBGColor
    label.textColor = Constant.selectedTextColor
  }
  
  func setDeselectedAppearance() {
    chevronIcon.transform = .identity
    chevronIcon.tintColor = Constant.deselectedTextColor
    layer.borderColor = Constant.deselectedBorderColor.cgColor
    backgroundColor = Constant.deselectedBGColor
    label.textColor = Constant.deselectedTextColor
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
    typealias Const = Constant.Label
    typealias Spacing = Const.Spacing
    return [
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      label.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.bottom)]
  }
  
  var moreIconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.ChevronIcon
    typealias Spacing = Const.Spacing
    return [
      chevronIcon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: Spacing.leading),
      chevronIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
      chevronIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      chevronIcon.heightAnchor.constraint(equalToConstant: Const.size.height),
      chevronIcon.widthAnchor.constraint(equalToConstant: Const.size.width)]
  }
}

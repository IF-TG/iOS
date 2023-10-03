//
//  TravelMainThemeCategoryAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class TravelMainThemeCategoryAreaView: UIView {
  enum Constant {
    enum ScrollBar {
      static let height: CGFloat = 4
      static let radius: CGFloat = 2.5
      static let color: UIColor = .yg.primary
    }
    
    enum Shadow {
      static let radius: CGFloat = 10.0
      static let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
      static let offset = CGSize(width: 0, height: 1)
    }
    
    static let cellSize = TravelMainCategoryViewCell.Constant.size
    
    static let size: CGSize = {
      let width = cellSize.width
      let height = Constant.ScrollBar.height + Constant.cellSize.height
      return CGSize(width: width, height: height)
    }()
  }
  
  // MARK: - Properties
  private var scrollBarConstraints: [NSLayoutConstraint] = []
  
  private(set) var travelThemeCategoryView = TravelMainThemeCollectionView()
  
  private let scrollBar: UIView = UIView().set {
    $0.backgroundColor = Constant.ScrollBar.color
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.ScrollBar.radius
  }
  
  private var isSetShadow = false
  override var bounds: CGRect {
    didSet {
      if !isSetShadow {
        isSetShadow.toggle()
        configureShadow()
      }
    }
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - Helpers
extension TravelMainThemeCategoryAreaView {
  /// selected cell위치에 따라 scrollBar layout 갱신
  /// - Parameters:
  ///   - layoutTargetCell: selected cell
  ///   - leadingInset: celected cell's title text leading
  ///   - animation: 초기에는 애니메이션 x
  func drawScrollBar(
    layoutTargetCell cell: UICollectionViewCell?,
    leadingInset: CGFloat,
    animation: Bool = true
  ) {
    NSLayoutConstraint.deactivate(scrollBarConstraints)
    scrollBarConstraints = scrollBarConstriant(cell, cellTitleSpacing: leadingInset)
    NSLayoutConstraint.activate(scrollBarConstraints)
    guard animation else {
      layoutIfNeeded()
      return
    }
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }
  
  func configureShadow() {
    layer.shadowColor = Constant.Shadow.color
    layer.shadowRadius = Constant.Shadow.radius
    layer.shadowOffset = Constant.Shadow.offset
    layer.shadowOpacity = 1
    let shadowRect = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y,
      width: bounds.width,
      height: bounds.height + 1)
    let shadowPath = UIBezierPath(rect: shadowRect).cgPath
    layer.shadowPath = shadowPath
  }
}

// MARK: - Private Helpers
private extension TravelMainThemeCategoryAreaView {
  func configureUI() {
    backgroundColor = .white
    setupUI()
  }
}

// MARK: - LayoutSupport
extension TravelMainThemeCategoryAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      travelThemeCategoryView,
      scrollBar
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    /// scrollBar position dynamic하게 바꾸기 위해 인스턴스에 저장
    scrollBarConstraints = scrollBarConstriant()
    _=[
      travelThemeCategoryViewConstraint,
      scrollBarConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension TravelMainThemeCategoryAreaView {
  var travelThemeCategoryViewConstraint: [NSLayoutConstraint] {
    typealias Const = Constant
    return [
      travelThemeCategoryView.topAnchor.constraint(equalTo: topAnchor),
      travelThemeCategoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
      travelThemeCategoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
      travelThemeCategoryView.heightAnchor.constraint(
        equalToConstant: Const.cellSize.height)]
  }
  
  func scrollBarConstriant(
    _ cell: UICollectionViewCell? = nil,
    cellTitleSpacing spacing: CGFloat = 0.0
  ) -> [NSLayoutConstraint] {
    var const = [
      scrollBar.topAnchor.constraint(
        equalTo: travelThemeCategoryView.bottomAnchor),
      scrollBar.heightAnchor.constraint(equalToConstant: Constant.ScrollBar.height),
      scrollBar.bottomAnchor.constraint(equalTo: bottomAnchor)]
    
    guard let cell = cell else { return setInitialScrollBar(constraint: &const) }
    
    setScrollBarPosition(
      from: cell,
      spacing: spacing,
      constraint: &const)
    
    return const
  }
  
  /// ScrollBar's leading, width anchor l
  /// - Parameter constraint: scrollBar's default constraint array
  /// - Returns: configured scrollBar's initial constraint
  func setInitialScrollBar(
    constraint: inout [NSLayoutConstraint]
  ) -> [NSLayoutConstraint] {
    _=[scrollBar.leadingAnchor.constraint(equalTo: leadingAnchor),
       scrollBar.widthAnchor.constraint(equalToConstant: 10)]
      .map { constraint.append($0) }
    return constraint
  }
  
  /// When called selectedItem in categoryView, set scroll bar's position
  /// - Parameters:
  ///   - cell: selectedItem
  ///   - spacing: selected item's title from leading spacing
  ///   - constraint: scrollBar's current constraint
  func setScrollBarPosition(
    from cell: UICollectionViewCell,
    spacing: CGFloat,
    constraint: inout [NSLayoutConstraint]
  ) {
    constraint.append(contentsOf: [
      scrollBar.leadingAnchor.constraint(
        equalTo: cell.leadingAnchor,
        constant: spacing),
      scrollBar.trailingAnchor.constraint(
        equalTo: cell.trailingAnchor,
        constant: -spacing)])
  }
}

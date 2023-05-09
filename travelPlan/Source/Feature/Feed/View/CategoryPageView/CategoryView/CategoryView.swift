//
//  CategoryView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class CategoryView: UIView {
  // MARK: - Properties
  private var scrollBarConstraints: [NSLayoutConstraint] = []
  
  private let categoryView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CategoryViewConstant
      .shared.cellSize
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let cv = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.decelerationRate = .fast
    cv.showsHorizontalScrollIndicator = false
    return cv
  }()
  
  private let scrollBar: UIView = UIView().set {
    $0.backgroundColor = UIColor(red: 0.106, green: 0.627, blue: 0.922, alpha: 1)
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = CategoryViewConstant.ScrollBar.radius
  }
  
  var delegate: UICollectionViewDelegate? {
    get {
      return categoryView.delegate
    } set {
      categoryView.delegate = newValue
    }
  }
  
  var dataSource: UICollectionViewDataSource? {
    get {
      return categoryView.dataSource
    } set {
      categoryView.dataSource = newValue
    }
  }
  
  var collectionView: UICollectionView {
    categoryView
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    categoryView.register(
      CategoryViewCell.self,
      forCellWithReuseIdentifier: CategoryViewCell.id)
    categoryView.bounces = false
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Helpers
extension CategoryView {
  /// selected cell위치에 따라 scrollBar layout 갱신
  /// - Parameters:
  ///   - cell: selected cell
  ///   - spacing: celected cell's title text leading
  func drawScrollBar(target cell: UICollectionViewCell, fromLeading spacing: CGFloat) {
    NSLayoutConstraint.deactivate(scrollBarConstraints)
    scrollBarConstraints = scrollBarConstriant(cell, cellTitleSpacing: spacing)
    NSLayoutConstraint.activate(scrollBarConstraints)
  }
}

// MARK: - LayoutSupport
extension CategoryView: LayoutSupport {
  func addSubviews() {
    _=[categoryView, scrollBar].map { addSubview($0) }
  }
  
  func setConstraints() {
    /// scrollBar position dynamic하게 바꾸기 위해 인스턴스에 저장
    scrollBarConstraints = scrollBarConstriant()
    _=[categoryViewConstraint,
       scrollBarConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

fileprivate extension CategoryView {
  var categoryViewConstraint: [NSLayoutConstraint] {
    [categoryView.topAnchor.constraint(equalTo: topAnchor),
     categoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
     categoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
     categoryView.heightAnchor.constraint(
      equalToConstant: CategoryViewConstant.shared
        .cellSize.height)]
  }
  
  func scrollBarConstriant(
    _ cell: UICollectionViewCell? = nil,
    cellTitleSpacing spacing: CGFloat = 0.0
  ) -> [NSLayoutConstraint] {
    
    var const = [
      scrollBar.topAnchor.constraint(
        lessThanOrEqualTo: categoryView.bottomAnchor),
      scrollBar.heightAnchor.constraint(
        lessThanOrEqualToConstant: CategoryViewConstant.ScrollBar.height),
      scrollBar.bottomAnchor.constraint(equalTo: bottomAnchor)]
    
    guard let cell = cell else {
      return setInitialScrollBar(constraint: &const)
    }
    
    setScrollBarPosition(
      from: cell,
      spacing: spacing,
      constraint: &const)
    
    return const
  }
  
  /// ScrollBar's leading, width anchor l
  /// - Parameter constraint: scrollBar's default constraint array
  /// - Returns: configured scrollBar's initial constraint
  func setInitialScrollBar(constraint: inout [NSLayoutConstraint]
  ) -> [NSLayoutConstraint] {
    let width = CategoryViewConstant.shared
      .intrinsicContentSize
      .width
    _=[scrollBar.leadingAnchor.constraint(equalTo: leadingAnchor),
       scrollBar.widthAnchor.constraint(equalToConstant: width)]
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

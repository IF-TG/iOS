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
  
  private(set) var categoryView = {
    let layout = UICollectionViewFlowLayout().set {
      $0.scrollDirection = .horizontal
      $0.itemSize = Constant.cellSize
      $0.minimumLineSpacing = 0
      $0.minimumInteritemSpacing = 0
    }
    return UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    ).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.decelerationRate = .fast
      $0.showsHorizontalScrollIndicator = false
    }
  }()
  
  private let scrollBar: UIView = UIView().set {
    $0.backgroundColor = Constant.ScrollBar.color
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.ScrollBar.radius
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Public helpers
extension CategoryView {
  func setInitialVisibleSubviews(from text: String) {
    let indexPath = IndexPath(row: 0, section: 0)
    guard let cell = categoryView.cellForItem(at: indexPath) as? CategoryViewCell else { return }
    let firstCategoryTextWidth = UILabel(frame: .zero)
      .set {
        typealias Const = CategoryViewCell.Constant.Title
        $0.text = text
        $0.font = UIFont.systemFont(ofSize: Const.fontSize)
        $0.sizeToFit()
      }
      .bounds
      .width
    let scrollBarLeading = (Constant.size.width - firstCategoryTextWidth) / 2
    
    NSLayoutConstraint.deactivate(scrollBarConstraints)
    scrollBarConstraints = scrollBarConstriant(cell, cellTitleSpacing: scrollBarLeading)
    NSLayoutConstraint.activate(scrollBarConstraints)
    layoutIfNeeded()
  }
  
  func selectedItem(
    at indexPath: IndexPath,
    animated: Bool,
    scrollPosition position: UICollectionView.ScrollPosition
  ) {
    categoryView.selectItem(
      at: indexPath,
      animated: animated,
      scrollPosition: position)
  }
  
  /// selected cell위치에 따라 scrollBar layout 갱신
  /// - Parameters:
  ///   - cell: selected cell
  ///   - spacing: celected cell's title text leading
  func drawScrollBar(target cell: UICollectionViewCell, fromLeading spacing: CGFloat) {
    NSLayoutConstraint.deactivate(scrollBarConstraints)
    scrollBarConstraints = scrollBarConstriant(cell, cellTitleSpacing: spacing)
    NSLayoutConstraint.activate(scrollBarConstraints)
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }
  
  /// CategoryView의 컨테이너 뷰는 CategoryPageView입니다.
  /// CategoryPageView에서 뒤늦게 scrollBar의 위치와 CategoryDetailView의 item 크기가 지정됩니다.
  /// 그 후에 호출해야합니다.
  func configureShadow() {
    layer.shadowColor = Constant.Shadow.color
    layer.shadowRadius = Constant.Shadow.radius
    layer.shadowOffset = Constant.Shadow.offset
    layer.masksToBounds = false
    layoutIfNeeded()
    let shadowRect = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y + bounds.height - 1,
      width: bounds.width,
      height: Constant.Shadow.offset.height + 1)
    let shadowPath = UIBezierPath(rect: shadowRect).cgPath
    layer.shadowPath = shadowPath
  }
}

// MARK: - Helpers
private extension CategoryView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    categoryView.bounces = false
    backgroundColor = .white
    setupUI()
    configureRegister()
    configureShadow()
  }
  
  func configureRegister() {
    categoryView.register(
      CategoryViewCell.self,
      forCellWithReuseIdentifier: CategoryViewCell.id)
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

// MARK: - LayoutSupport constraints
private extension CategoryView {
  var categoryViewConstraint: [NSLayoutConstraint] {
    [categoryView.topAnchor.constraint(equalTo: topAnchor),
     categoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
     categoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
     categoryView.heightAnchor.constraint(
      equalToConstant: Constant.cellSize.height)]
  }
  
  func scrollBarConstriant(
    _ cell: UICollectionViewCell? = nil,
    cellTitleSpacing spacing: CGFloat = 0.0
  ) -> [NSLayoutConstraint] {
    
    var const = [
      scrollBar.topAnchor.constraint(
        equalTo: categoryView.bottomAnchor),
      scrollBar.heightAnchor.constraint(equalToConstant: Constant.ScrollBar.height),
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
    let width = Constant.size.width
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

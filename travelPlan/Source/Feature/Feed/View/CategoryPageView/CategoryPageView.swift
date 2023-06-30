//
//  CategoryPageView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

/// Horizontal category page view
final class CategoryPageView: UIView {
  
  // MARK: - Properties
  private lazy var categoryView = CategoryView()
  
  private lazy var categoryDetailView = CategoryDetailView()
  
  private let vm = CategoryPageViewModel()
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  override func layoutSubviews() {
    initCategoryDetailViewCellItem()
    initCategoryViewScrollBarLayout()
    selectedCategoryViewFirstCell()
    bringSubviewToFront(categoryView)
    categoryView.configureShadow()
  }
}

// MARK: - Helpers
private extension CategoryPageView {
  func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    categoryView.delegate = self
    categoryView.dataSource = self
    categoryDetailView.dataSource = self
  }
  
  /// If subviews layout, set category view scroll bar's layout
  func initCategoryViewScrollBarLayout() {
    let indexPath = IndexPath(row: 0, section: 0)
    guard let cell = categoryView
      .collectionView
      .cellForItem(at: indexPath
      ) as? CategoryViewCell else {
      return
    }
    
    
    let lb = UILabel()
    lb.text = vm.data[indexPath.row]
    lb.font = UIFont.systemFont(
      ofSize: CategoryViewCell.Constant.Title.fontSize)
    lb.sizeToFit()
    let firstCellTextSize = lb.bounds.width
    
    
    let firstTextLeading = (
      CategoryView.Constant.size.width - firstCellTextSize)/2
    categoryView.drawScrollBar(
      target: cell,
      fromLeading: firstTextLeading)
  }
  
  /// If subviews layout, set category detail view cell size
  func initCategoryDetailViewCellItem() {
    let categoryHeight = CategoryView.Constant.size.height
    categoryDetailView.setLayoutItemSize(
      CGSize(
        width: bounds.width,
        height: bounds.height - categoryHeight))
    categoryDetailView.isScrollEnabled = false
  }
  
  /// If subviews layout, selectItem category view first sell
  func selectedCategoryViewFirstCell() {
    categoryView.collectionView.selectItem(
      at: IndexPath(row: 0, section: 0),
      animated: false,
      scrollPosition: .left)
  }
}

// MARK: - UICollectionViewDataSource
extension CategoryPageView: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return categoryData.count
  }
  
  func collectionView(
    _ cv: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch cv {
    case categoryDetailView:
//      return vm.configCell(
//        collectionView,
//        cellForItemAt: indexPath,
//        type: .categoryDetail)
      guard let cell = cv.dequeueReusableCell(
        withReuseIdentifier: CategoryDetailViewCell.id,
        for: indexPath
      ) as? CategoryDetailViewCell else {
        return UICollectionViewCell()
      }
      return cell.configure(with: vm.mockPostData)
    default:
//      return vm.configCell(
//        collectionView,
//        cellForItemAt: indexPath,
//        type: .category)
      guard let cell = cv.dequeueReusableCell(
        withReuseIdentifier: CategoryViewCell.id,
        for: indexPath
      ) as? CategoryViewCell else {
        return UICollectionViewCell()
      }
      return cell.configUI(with: vm.data[indexPath.row])
    }
  }
}

// MARK: - UICollectionViewDelegate
extension CategoryPageView: UICollectionViewDelegate {
  /// When selected category view's cell, set scrollBar postiion, cell's position in screen
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    if collectionView == categoryView.collectionView {
      
      let lb = UILabel()
      lb.text = vm.data[indexPath.row]
      lb.font = UIFont.systemFont(
        ofSize: CategoryViewCell.Constant.Title.fontSize)
      lb.sizeToFit()
      let titleWidth = lb.bounds.width
      
//      let titleWidth = vm.titleFontSize(of: indexPath)
      let spacing = vm.scrollBarLeadingSpacing(titleWidth)
      
      guard let cell = collectionView.cellForItem(at: indexPath) else { return }
      
      _=[collectionView, categoryDetailView]
        .map {
          $0.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .centeredHorizontally)
        }
      categoryView.drawScrollBar(target: cell, fromLeading: spacing)
      UIView.animate(withDuration: 0.3) {
        self.layoutIfNeeded()
      }
    }
  }
}

// MARK: - LayoutSupport
extension CategoryPageView: LayoutSupport {
  func addSubviews() {
    _=[categoryDetailView,
       categoryView]
      .map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[categoryViewConstraint,
       categoryDetailViewConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport constraints
private extension CategoryPageView {
  var categoryViewConstraint: [NSLayoutConstraint] {
    [categoryView.topAnchor.constraint(
      equalTo: topAnchor),
     categoryView.leadingAnchor.constraint(
      equalTo: leadingAnchor),
     categoryView.trailingAnchor.constraint(
      equalTo: trailingAnchor),
     categoryView.heightAnchor.constraint(
      equalToConstant:
        CategoryView.Constant.size.height)]
  }
  
  var categoryDetailViewConstraint: [NSLayoutConstraint] {
    [categoryDetailView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
     categoryDetailView.leadingAnchor.constraint(equalTo: leadingAnchor),
     categoryDetailView.trailingAnchor.constraint(equalTo: trailingAnchor),
     categoryDetailView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}

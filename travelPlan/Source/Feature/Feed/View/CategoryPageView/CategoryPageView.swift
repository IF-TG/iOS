//
//  CategoryPageView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit
import Combine

/// Horizontal category page view
final class CategoryPageView: UIView {
  // MARK: - Properties
  private let categoryScrollBarAreaView = CategoryView()
  
  private let categoryDetailView = CategoryDetailView()
  
  private let vm = CategoryPageViewModel()
  
  private var adapter: CategoryPageViewAdapter!
  
  private var subscription: AnyCancellable?
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    bind()
    adapter = CategoryPageViewAdapter(
      dataSource: vm,
      delegate: self,
      travelThemeCollectionView: categoryScrollBarAreaView.travelThemeCategoryView,
      categoryDetailCollectionView: categoryDetailView)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    bind()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - Private Helpers
private extension CategoryPageView {
  func configureUI() {
    setupUI()
  }
  
  func bind() {
    subscription = categoryDetailView
      .itemSizeSetNotifier
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] in
        let categoryfirstText = vm.travelMainCategoryTitle(at: 0)
        let firstIndex = IndexPath(item: 0, section: 0)
        categoryScrollBarAreaView.setInitialVisibleSubviews(from: categoryfirstText)
        categoryScrollBarAreaView.selectedItem(at: firstIndex, animated: false, scrollPosition: .left)
        categoryDetailView.selectItem(at: firstIndex, animated: false, scrollPosition: .left)
        // TODO: - 쉐도우 적용 안되서 적용해야합니다.
        // bringSubviewToFront(categoryScrollBarAreaView)
        categoryScrollBarAreaView.configureShadow()
      }
  }
}

// MARK: - CategoryPageViewDelegate
extension CategoryPageView: CategoryPageViewDelegate {
  func didSelectItemAt(_ indexPath: IndexPath, spacing: CGFloat) {
    guard let cell = categoryScrollBarAreaView.selectedCell(at: indexPath) else { return }
    categoryScrollBarAreaView.selectedItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    categoryDetailView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    categoryScrollBarAreaView.drawScrollBar(target: cell, fromLeading: spacing)
  }
}

// MARK: - LayoutSupport
extension CategoryPageView: LayoutSupport {
  func addSubviews() {
    _=[categoryDetailView,
       categoryScrollBarAreaView]
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
    typealias Const = CategoryView.Constant
    return [
      categoryScrollBarAreaView.topAnchor.constraint(
        equalTo: topAnchor),
      categoryScrollBarAreaView.leadingAnchor.constraint(
        equalTo: leadingAnchor),
      categoryScrollBarAreaView.trailingAnchor.constraint(
        equalTo: trailingAnchor),
      categoryScrollBarAreaView.heightAnchor.constraint(
        equalToConstant:
          Const.size.height)]
  }
  
  var categoryDetailViewConstraint: [NSLayoutConstraint] {
    [categoryDetailView.topAnchor.constraint(equalTo: categoryScrollBarAreaView.bottomAnchor),
     categoryDetailView.leadingAnchor.constraint(equalTo: leadingAnchor),
     categoryDetailView.trailingAnchor.constraint(equalTo: trailingAnchor),
     categoryDetailView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}

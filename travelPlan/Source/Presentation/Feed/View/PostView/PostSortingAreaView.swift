//
//  PostSortingMenuAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostSortingAreaView: UICollectionReusableView {
  static let id = String(describing: PostSortingAreaView.self)
  
  enum Constant {
    enum TravelMainThemeChevronView {
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 10
      }
    }
    enum TravelOrderChevronView {
      enum Spacing {
        static let leading: CGFloat = 10
        static let top: CGFloat = 10
      }
    }
  }
  
  // MARK: - Properties
  /// 분류
  private var travelMainThemeChevronView = PostChevronLabel()
  
  /// 정렬
  private var travelOrderChevronView = PostChevronLabel()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    travelOrderChevronView.configure(with: .travelOrder)
    setupUI()
    travelMainThemeChevronView.delegate = self
    travelOrderChevronView.delegate = self
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - Helpers
extension PostSortingAreaView {
  func configure(with sortingType: PostFilterOptions) {
    travelMainThemeChevronView.configure(with: sortingType)
  }
  
  func setDefaultThemeUI() {
    travelMainThemeChevronView.isSelected = false
  }
  
  func setDefaultOrderUI() {
    travelOrderChevronView.isSelected = false
  }
}

// MARK: - LayoutSupport
extension PostSortingAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      travelMainThemeChevronView,
      travelOrderChevronView
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      travelThemeMenuViewConstraints,
      travelTrendMenuViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - MoreMenuViewDelegate
extension PostSortingAreaView: MoreMenuViewDelegate {
  func moreMenuView(
    _ moreMenuView: PostChevronLabel,
    didSelectedType type: PostFilterOptions
  ) {
    let data: [Notification.Name: PostFilterOptions] = [.TravelCategoryDetailSelected: type]
    NotificationCenter.default.post(
      name: .TravelCategoryDetailSelected,
      object: nil,
      userInfo: data)
  }
}

// MARK: - Private layoutsupport
private extension PostSortingAreaView {
  var travelThemeMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.TravelMainThemeChevronView.Spacing
    return [
      travelMainThemeChevronView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Inset.leading),
      travelMainThemeChevronView.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
      travelMainThemeChevronView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
  
  var travelTrendMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.TravelOrderChevronView.Spacing
    return [
      travelOrderChevronView.leadingAnchor.constraint(
        equalTo: travelMainThemeChevronView.trailingAnchor,
        constant: Inset.leading),
      travelOrderChevronView.centerYAnchor.constraint(equalTo: travelMainThemeChevronView.centerYAnchor)]
  }
}

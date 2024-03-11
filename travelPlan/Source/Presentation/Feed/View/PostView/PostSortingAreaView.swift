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
    enum TravelThemeChevronView {
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 10
      }
    }
    enum TravelTrendChevronView {
      enum Spacing {
        static let leading: CGFloat = 10
        static let top: CGFloat = 10
      }
    }
  }
  
  // MARK: - Properties
  /// 분류
  private var travelThemeChevronView = PostChevronLabel()
  
  /// 최신순
  private var travelTrendChevronView = PostChevronLabel()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    travelTrendChevronView.configure(with: .travelOrder)
    setupUI()
    travelThemeChevronView.delegate = self
    travelTrendChevronView.delegate = self
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - Helpers
extension PostSortingAreaView {
  func configure(with sortingType: PostFilterOptions) {
    travelThemeChevronView.configure(with: sortingType)
  }
  
  func setDefaultThemeUI() {
    travelThemeChevronView.isSelected = false
  }
  
  func setDefaultOrderUI() {
    travelTrendChevronView.isSelected = false
  }
}

// MARK: - LayoutSupport
extension PostSortingAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      travelThemeChevronView,
      travelTrendChevronView
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
    typealias Inset = Constant.TravelThemeChevronView.Spacing
    return [
      travelThemeChevronView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Inset.leading),
      travelThemeChevronView.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
      travelThemeChevronView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
  
  var travelTrendMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.TravelTrendChevronView.Spacing
    return [
      travelTrendChevronView.leadingAnchor.constraint(
        equalTo: travelThemeChevronView.trailingAnchor,
        constant: Inset.leading),
      travelTrendChevronView.centerYAnchor.constraint(equalTo: travelThemeChevronView.centerYAnchor)]
  }
}

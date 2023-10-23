//
//  PostSortingMenuAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostSortingAreaView: UIView {
  enum Constant {
    enum TravelThemeChevronView {
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 10
        static let bottom: CGFloat = 10
      }
    }
    enum TravelTrendChevronView {
      enum Spacing {
        static let leading: CGFloat = 10
        static let top: CGFloat = 10
        static let bottom: CGFloat = 10
      }
    }
  }
  
  // MARK: - Properties
  private var travelThemeChevronView = PostChevronLabel()
  
  private var travelTrendChevronView = PostChevronLabel()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    travelTrendChevronView.configure(with: .trend)
    setupUI()
    travelThemeChevronView.delegate = self
    travelTrendChevronView.delegate = self
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Helpers
extension PostSortingAreaView {
  func configure(with sortingType: TravelCategorySortingType) {
    travelThemeChevronView.configure(with: sortingType)
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
    didSelectedType type: TravelCategorySortingType
  ) {
    let data: [Notification.Name: TravelCategorySortingType] = [.TravelCategoryDetailSelected: type]
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
      travelThemeChevronView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Inset.bottom)]
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

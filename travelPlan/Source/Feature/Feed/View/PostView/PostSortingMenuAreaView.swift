//
//  PostSortingMenuAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostSortingMenuAreaView: UIView {
  enum Constant {
    enum TravelThemeMenuView {
      enum Inset {
        static let leading: CGFloat = 16
        static let top: CGFloat = 10
        static let bottom: CGFloat = 10
      }
    }
    
    enum TravelTrendMenuView {
      enum Inset {
        static let leading: CGFloat = 10
        static let top: CGFloat = 10
        static let bottom: CGFloat = 10
      }
    }
  }
  
  // MARK: - Properties
  private var travelThemeMenuView = PostChevronLabel(sortingType: .trend)
  
  private var travelTrendMenuView: PostChevronLabel
  
  // MARK: - LifeCycle
  init(frame: CGRect, travelThemeType: TravelMainThemeType) {
    travelTrendMenuView = PostChevronLabel(sortingType: .detailCategory(travelThemeType))
    super.init(frame: frame)
    setupUI()
    travelThemeMenuView.configure(with: .detailCategory(travelThemeType))
    travelTrendMenuView.configure(with: .trend)
    travelThemeMenuView.delegate = self
    travelTrendMenuView.delegate = self
  }
  
  convenience init(travelThemeType: TravelMainThemeType) {
    self.init(frame: .zero, travelThemeType: travelThemeType)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

// MARK: - LayoutSupport
extension PostSortingMenuAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      travelThemeMenuView,
      travelTrendMenuView
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
extension PostSortingMenuAreaView: MoreMenuViewDelegate {
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
private extension PostSortingMenuAreaView {
  var travelThemeMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.TravelThemeMenuView.Inset
    return [
      travelThemeMenuView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Inset.leading),
      travelThemeMenuView.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Inset.top),
      travelThemeMenuView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Inset.bottom)]
  }
  
  var travelTrendMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.TravelTrendMenuView.Inset
    return [
      travelTrendMenuView.leadingAnchor.constraint(
        equalTo: travelThemeMenuView.trailingAnchor,
        constant: Inset.leading),
      travelThemeMenuView.centerYAnchor.constraint(
        equalTo: travelThemeMenuView.centerYAnchor),
      travelTrendMenuView.trailingAnchor.constraint(
        lessThanOrEqualTo: trailingAnchor)]
  }
}

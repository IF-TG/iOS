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
  private var travelThemeChevronView: PostChevronLabel
  
  private var travelTrendChevronView = PostChevronLabel(sortingType: .trend)
  
  // MARK: - LifeCycle
  init(frame: CGRect, travelThemeType: TravelMainThemeType) {
    travelThemeChevronView = PostChevronLabel(sortingType: .detailCategory(travelThemeType))
    super.init(frame: frame)
    setupUI()
    travelThemeChevronView.delegate = self
    travelTrendChevronView.delegate = self
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
      travelThemeChevronView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Inset.leading),
      travelThemeChevronView.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
      travelThemeChevronView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Inset.bottom)]
  }
  
  var travelTrendMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.TravelTrendMenuView.Inset
    return [
      travelTrendChevronView.leadingAnchor.constraint(
        equalTo: travelThemeChevronView.trailingAnchor,
        constant: Inset.leading),
      travelThemeChevronView.centerYAnchor.constraint(equalTo: travelThemeChevronView.centerYAnchor),
      travelTrendChevronView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)]
  }
}

//
//  PostSortingMenuView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostSortingMenuView: UIView {
  enum Constants {
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
  private(set) var travelThemeMenuView = MoreCategoryView()
  
  private(set) var travelTrendMenuView = MoreCategoryView()
  
  // MARK: - LifeCycle
  private override init(frame: CGRect) {
    fatalError()
  }
  
  init(frame: CGRect, travelThemeType: TravelThemeType) {
    super.init(frame: frame)
    setupUI()
    travelThemeMenuView.configure(with: .detailCategory(travelThemeType))
    travelTrendMenuView.configure(with: .trend)
  }
  
  convenience init(travelThemeType: TravelThemeType) {
    self.init(frame: .zero, travelThemeType: travelThemeType)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

// MARK: - LayoutSupport
extension PostSortingMenuView: LayoutSupport {
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

// MARK: - Layout support helper
private extension PostSortingMenuView {
  var travelThemeMenuViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constants.TravelThemeMenuView.Inset
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
    typealias Inset = Constants.TravelTrendMenuView.Inset
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

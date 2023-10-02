//
//  PostViewBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostViewBottomSheetViewController: UIViewController {
  struct Constants {
    enum CategoryView {
      enum Inset {
        static let top: CGFloat = 15
      }
      
      static let cellSize: CGSize = {
        let width = UIScreen.main.bounds.width
        let cellTitleSpacing = PostViewBottomSheetCell.Constant.Title.spacing
        let topAndBottomSpacing = cellTitleSpacing.top + cellTitleSpacing.bottom
        let height: CGFloat = {
          let label = UILabel().set {
            $0.text = "test"
            $0.font = PostViewBottomSheetCell.Constant.Title.font
            $0.sizeToFit()
          }
          return label.bounds.height
        }()
        return .init(width: width, height: topAndBottomSpacing + height)
      }()
    }
  }
  
  // MARK: - Properties
  private let indicatorBar = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0
  }
  private let categoryView = UITableView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(
      PostViewBottomSheetCell.self,
      forCellReuseIdentifier: PostViewBottomSheetCell.id)
    $0.rowHeight = Constants.CategoryView.cellSize.height
  }
  
  private let safeAreaBottomBackgroundView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  // MARK: - Lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    configureUI()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    UIView.animate(
      withDuration: 0.40,
      delay: 0,
      options: .curveEaseOut
    ) {
      self.view.backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.1)
      self.categoryView.transform = .identity
      self.safeAreaBottomBackgroundView.transform = .identity
    }
  }
}

// MARK: - Private Helpers
extension PostViewBottomSheetViewController {
  private func configureUI() {
    setupUI()
    modalPresentationStyle = .overFullScreen
    let height = UIScreen.main.bounds.height
    view.backgroundColor = .clear
    categoryView.transform = .init(translationX: 0, y: +height)
    safeAreaBottomBackgroundView.transform = .init(translationX: 0, y: +height)
  }
}

// MARK: - LayoutSupport
extension PostViewBottomSheetViewController: LayoutSupport {
  func addSubviews() {
    _=[categoryView,
     safeAreaBottomBackgroundView
    ].map { view.addSubview($0) }
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(categoryViewConstraints)
    _=[categoryViewConstraints,
       safeAreaBottomBackgroundViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostViewBottomSheetViewController {
  var categoryViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constants.CategoryView.Inset
    return [
      categoryView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      categoryView.topAnchor.constraint(
        greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
        constant: Inset.top),
      categoryView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      categoryView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      categoryView.heightAnchor.constraint(lessThanOrEqualToConstant: 300)]
  }
  
  var safeAreaBottomBackgroundViewConstraints: [NSLayoutConstraint] {
    return [
      safeAreaBottomBackgroundView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      safeAreaBottomBackgroundView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      safeAreaBottomBackgroundView.topAnchor.constraint(
        equalTo: categoryView.bottomAnchor),
      safeAreaBottomBackgroundView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor)
    ]
  }
}

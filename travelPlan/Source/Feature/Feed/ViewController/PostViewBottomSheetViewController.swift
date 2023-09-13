//
//  PostViewBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostViewBottomSheetViewController: UIViewController {
  // MARK: - Constant
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
  private let categoryView: UITableView = UITableView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(
      PostViewBottomSheetCell.self,
      forCellReuseIdentifier: PostViewBottomSheetCell.id)
    $0.rowHeight = Constants.CategoryView.cellSize.height
  }
  
  // MARK: - Lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupUI()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
}

// MARK: - LayoutSupport
extension PostViewBottomSheetViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(categoryView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(categoryViewConstraints)
  }
}

// MARK: - LayoutSupport helper
private extension PostViewBottomSheetViewController {
  var categoryViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constants.CategoryView.Inset
    return [
      categoryView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      categoryView.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: Inset.top),
      categoryView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      categoryView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor)]
  }
}

//
//  PostViewBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostViewBottomSheetViewController: UIViewController {
  // MARK: - Constant
  struct Constant {
    enum CategoryCollectionView {
      static let spacing: UISpacing = .init(top: 15)
      static let cellSize: CGSize = {
        let width = UIScreen.main.bounds.width
        let cellTitleSpacing = PostViewBottomSheetCategoryCVCell.Constant.Title.spacing
        let topAndBottomSpacing = cellTitleSpacing.top + cellTitleSpacing.bottom
        let height: CGFloat = {
          let label = UILabel().set {
            $0.text = "test"
            $0.font = PostViewBottomSheetCategoryCVCell.Constant.Title.font
            $0.sizeToFit()
          }
          return label.bounds.height
        }()
        return .init(width: width, height: topAndBottomSpacing + height)
      }()
    }
  }
  
  // MARK: - Properties
  private let categoryCollectionView = {
    let layout = UICollectionViewFlowLayout().set {
      $0.scrollDirection = .vertical
      $0.minimumLineSpacing = 0
      $0.minimumInteritemSpacing = 0
      $0.itemSize = Constant.CategoryCollectionView.cellSize
    }
    let cv = UICollectionView.init(
      frame: .zero,
      collectionViewLayout: layout)
    cv.register(
      PostViewBottomSheetCategoryCVCell.self, forCellWithReuseIdentifier: PostViewBottomSheetCategoryCVCell.id)
    return cv
  }()
  
  // MARK: - Lifecycle
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupUI()
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }
}

extension PostViewBottomSheetViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(categoryCollectionView)
  }
  
  func setConstraints() {
    [categoryCollectionView.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: Constant.CategoryCollectionView.spacing.leading),
     categoryCollectionView.topAnchor.constraint(
      equalTo: view.topAnchor,
      constant: Constant.CategoryCollectionView.spacing.top),
     categoryCollectionView.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.CategoryCollectionView.spacing.trailing),
     categoryCollectionView.bottomAnchor.constraint(
      equalTo: view.bottomAnchor,
      constant: -Constant.CategoryCollectionView.spacing.bottom)]
  }
}

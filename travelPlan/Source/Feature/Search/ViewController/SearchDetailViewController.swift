//
//  SearchDetailViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit
import SnapKit

class SearchDetailViewController: UIViewController {
  // MARK: - Properties
  weak var coordinator: SearchDetailCoordinator?
  
  private let titleLabel: UILabel = .init().set {
    $0.numberOfLines = 1
    $0.font = .init(pretendard: .bold, size: 30)
    $0.text = "헤더 타이틀"
    $0.textColor = UIColor.yg.littleWhite
  }
  
  private let categoryThumbnailImageView: UIImageView = .init().set {
    $0.backgroundColor = .red // to erase
    $0.roundCorners(cornerRadius: 10, cornerList: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    $0.image = UIImage(named: "tempProfile1") // to erase
    $0.contentMode = .scaleAspectFill
  }
  
  // layoutTODO: - layout 변경
  private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init()).set {
    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
    $0.backgroundColor = .cyan
    $0.roundCorners(cornerRadius: 10, cornerList: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
  }
  
  let type: SearchSectionType
  
  // MARK: - LifeCycle
  init(type: SearchSectionType) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    coordinator?.finish()
    print("deinit: \(Self.self)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupBackBarButtonItem()
    
    switch type {
    case .festival:
      print("베스트 축제 VC")
    case .famous:
      print("레포츠 vc")
    }
  }
}

// MARK: - Helpers
extension SearchDetailViewController {
  
}

// MARK: - Helpers
extension SearchDetailViewController {
  private func setupStyles() {
    view.backgroundColor = .yg.gray00Background
  }
}

// MARK: - LayoutSupport
extension SearchDetailViewController: LayoutSupport {
  func addSubviews() {
    categoryThumbnailImageView.addSubview(titleLabel)
    view.addSubview(categoryThumbnailImageView)
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(25)
    }
    
    categoryThumbnailImageView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.25)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(categoryThumbnailImageView.snp.bottom).offset(8)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - UIScrollViewDelegate
extension SearchDetailViewController: UIScrollViewDelegate {
  
}

// diffableTODO: - DiffableDataSource 적용 해보기

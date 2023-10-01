//
//  SearchMoreDetailViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit
import SnapKit

class SearchMoreDetailViewController: UIViewController {
  enum Constants {
    enum TitleLabel {
      static let numberOfLines = 1
      static let fontSize: CGFloat = 30
      static let text = "헤더 타이틀"
      enum Spacing {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
        static let bottom: CGFloat = 25
      }
    }
    enum categoryThumbnailImageView {
      static let cornerRadius: CGFloat = 10
      enum Spacing {
        static let multipliedHeight: CGFloat = 0.25
      }
    }
    enum CollectionView {
      static let cornerRadius: CGFloat = 10
      enum Spacing {
        static let top: CGFloat = 8
      }
    }
    enum CollectionViewCell {
      static let height: CGFloat = UIScreen.main.bounds.size.height * 0.172
    }
  }
  
  // MARK: - Properties
  weak var coordinator: SearchMoreDetailCoordinatorDelegate?
  private let viewModel = SearchMoreDetailViewModel()
  
  private let titleLabel: UILabel = .init().set {
    $0.numberOfLines = Constants.TitleLabel.numberOfLines
    $0.font = .init(pretendard: .bold, size: Constants.TitleLabel.fontSize)
    $0.text = Constants.TitleLabel.text
    $0.textColor = UIColor.yg.littleWhite
  }
  
  private let categoryThumbnailImageView: UIImageView = .init().set {
    $0.roundCorners(
      cornerRadius: Constants.categoryThumbnailImageView.cornerRadius,
      cornerList: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    )
    $0.image = UIImage(named: "tempProfile1") // to erase
    $0.contentMode = .scaleAspectFill
  }
  
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).set {
    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
    $0.roundCorners(cornerRadius: Constants.CollectionView.cornerRadius,
                    cornerList: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    $0.backgroundColor = .cyan
    $0.delegate = self
    $0.dataSource = self
  }
  
  let type: SearchSectionType
  let input = SearchMoreDetailViewModel.Input()
  
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
    
    input.viewDidLoad.send(type)
    switch type {
    case .festival:
      print("베스트 축제 VC")
    case .camping:
      print("레포츠 vc")
    }
  }
}

// MARK: - Helpers
extension SearchMoreDetailViewController {
  private func setupStyles() {
    view.backgroundColor = .yg.gray00Background
  }
}

// MARK: - LayoutSupport
extension SearchMoreDetailViewController: LayoutSupport {
  func addSubviews() {
    categoryThumbnailImageView.addSubview(titleLabel)
    view.addSubview(categoryThumbnailImageView)
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Constants.TitleLabel.Spacing.leading)
      $0.trailing.equalToSuperview().inset(Constants.TitleLabel.Spacing.trailing)
      $0.bottom.equalToSuperview().inset(Constants.TitleLabel.Spacing.bottom)
    }
    
    categoryThumbnailImageView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.equalToSuperview()
      $0.height.equalToSuperview()
        .multipliedBy(Constants.categoryThumbnailImageView.Spacing.multipliedHeight)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(categoryThumbnailImageView.snp.bottom).offset(Constants.CollectionView.Spacing.top)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - UIScrollViewDelegate
extension SearchMoreDetailViewController: UIScrollViewDelegate {
  
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchMoreDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.size.width, height: Constants.CollectionViewCell.height)
  }
}

// MARK: - UICollectionViewDataSource
extension SearchMoreDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 10
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TravelDestinationCell.id,
      for: indexPath
    ) as? TravelDestinationCell else { return .init() }
//    cell.configure(with: )
    return cell
  }
}

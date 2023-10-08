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
    enum CollectionView {
      static let cornerRadius: CGFloat = 10
    }
    enum CollectionHeaderView {
      static let heightRatio: CGFloat = 0.25
    }
    enum CollectionViewCell {
      static let height: CGFloat = UIScreen.main.bounds.height * 0.172
    }
  }
  
  // MARK: - Properties
  weak var coordinator: SearchMoreDetailCoordinatorDelegate?
<<<<<<< HEAD
  private let viewModel: SearchMoreDetailViewModel
  
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
  
=======
  private let viewModel = SearchMoreDetailViewModel()
  private let compositionalLayoutManager: CompositionalLayoutCreatable = SearchMoreDetailLayoutManager()
>>>>>>> dcfdcaff5ae4419dfbfa178847588701569f3906
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: compositionalLayoutManager.makeLayout()
  ).set {
    $0.register(TravelDestinationCell.self,
                forCellWithReuseIdentifier: TravelDestinationCell.id)
    $0.register(SearchDetailHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchDetailHeaderView.id)
    $0.roundCorners(cornerRadius: Constants.CollectionView.cornerRadius,
                    cornerList: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    $0.backgroundColor = .white
    $0.delegate = self
    $0.dataSource = self
    $0.bounces = false
    $0.contentInsetAdjustmentBehavior = .never  // 자동 inset 조정 비활성화
  }
  
  private var headerViewHeight: CGFloat {
    self.view.bounds.height * Constants.CollectionHeaderView.heightRatio
  }
  
  private lazy var backButton: UIButton = .init().set {
    $0.addTarget(
      self,
      action: #selector(didTapBackBarButtonItem),
      for: .touchUpInside
    )
    $0.contentEdgeInsets = .init(
      top: .zero,
      left: 10,
      bottom: .zero,
      right: .zero
    )
    $0.setImage(
      UIImage(named: "back")?
        .withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    $0.imageView?.tintColor = .white
  }
  
<<<<<<< HEAD
  private let type: SearchSectionType
  let input = SearchMoreDetailViewModel.Input()
=======
  let type: SearchSectionType
  private let input = SearchMoreDetailViewModel.Input()
>>>>>>> dcfdcaff5ae4419dfbfa178847588701569f3906
  
  // MARK: - LifeCycle
  init(type: SearchSectionType) {
    self.type = type
    self.viewModel = SearchMoreDetailViewModel(type: type)
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
    setupNavigationBar()
    
    input.viewDidLoad.send()
    switch type {
    case .festival:
      print("베스트 축제 VC")
    case .camping:
      print("레포츠 vc")
<<<<<<< HEAD
    case .topTen:
      print("여행지 TOP 10 VC")
=======
    case .top10:
      print("여행지 TOP 10")
>>>>>>> dcfdcaff5ae4419dfbfa178847588701569f3906
    }
  }
}

// MARK: - Actions
extension SearchMoreDetailViewController {
  @objc private func didTapBackBarButtonItem() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailViewController {
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationBar() {
    self.navigationController?.isNavigationBarHidden = false
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    clearNavigationBarImage()
  }
  
  private func clearNavigationBarImage() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func changeBlackOrWhiteColor(with alpha: CGFloat) -> UIColor {
    return UIColor(white: alpha, alpha: 1)
  }
}

// MARK: - LayoutSupport
extension SearchMoreDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
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
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if case UICollectionView.elementKindSectionHeader = kind {
      guard let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SearchDetailHeaderView.id,
        for: indexPath) as? SearchDetailHeaderView else { return .init() }
      
      // TODO: - ViewModel을 통해 서버로부터 fetch해온 model을 주입주어야 합니다.
      headerView.configure(with: SearchDetailHeaderModel(title: "헤더 타이틀", imageURL: "tempProfile1"))
      return headerView
    } else { return .init() }
  }
}

extension SearchMoreDetailViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let maxHeight = min(headerViewHeight, scrollView.contentOffset.y)
    
    let alpha = (headerViewHeight - maxHeight) / headerViewHeight
    print(alpha)
    let headerView = collectionView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: .zero, section: .zero)
    )
    
    headerView?.alpha = alpha
    backButton.imageView?.tintColor = changeBlackOrWhiteColor(with: alpha)
  }
}

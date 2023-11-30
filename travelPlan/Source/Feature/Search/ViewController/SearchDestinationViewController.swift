//
//  SearchDestinationViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/27/23.
//

import UIKit
import SnapKit

enum DestinationType {
  case cultureFacility
  case touristAttraction
  case leports
  case restaurant
  case shopping
  case festival
}

class SearchDestinationViewController: UIViewController {
  // MARK: - Properties
  private lazy var starButton = UIButton().set {
    $0.setImage(.init(named: "emptyStar-border-white"), for: .normal)
    $0.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
  }
  private lazy var shareButton = UIButton().set {
    // TODO: - 색상을 image에서 흰색으로 바꿔야합니다.(작동 되는지 확인해보기)
    let image = resizeImage(image: .init(named: "feedShare"),
                            size: .init(width: 24, height: 24))?
      .withRenderingMode(.alwaysTemplate)
    $0.setImage(image, for: .normal)
    $0.imageView?.tintColor = .white
    $0.addTarget(self, action: #selector(didTapShareButton(_:)), for: .touchUpInside)
  }
  private let type: DestinationType
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: SearchDestinationCollectionViewLayout().makeLayout()
  ).set {
    $0.register(SearchDestinationTitleCell.self, forCellWithReuseIdentifier: SearchDestinationTitleCell.id)
    $0.register(SearchDestinationServiceCell.self, forCellWithReuseIdentifier: SearchDestinationServiceCell.id)
    $0.register(SearchDestinationContentCell.self, forCellWithReuseIdentifier: SearchDestinationContentCell.id)
    $0.backgroundColor = .yg.littleWhite
    $0.dataSource = self
    $0.delegate = self
  }
  private var collectionViewWillDisplayIsFirstCalled = false
  // FIXME: - will erase
  private let mockThumbnailImageView = UIImageView().set {
    $0.image = .init(named: "seomun")
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  // MARK: - LifeCycle
  init(type: DestinationType) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupStyles()
    setupUI()
  }
}

// MARK: - Private Helpers
extension SearchDestinationViewController {
  private func setupNavigationBar() {
    setupDefaultBackBarButtonItem(tintColor: .white)
    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: shareButton),
                                          UIBarButtonItem(customView: starButton)]
    let appearance = UINavigationBarAppearance()
    appearance.backgroundEffect = .none
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
  
  private func setupStyles() {
    view.backgroundColor = .black
  }
  
  private func resizeImage(image: UIImage?, size: CGSize) -> UIImage? {
    guard let image = image else { return nil }
    
    let newSize = CGSize(width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage ?? image
  }
}

// MARK: - Actions
private extension SearchDestinationViewController {
  @objc func didTapStarButton(_ sender: UIButton) {
    print("Star Button 클릭")
  }
  
  @objc func didTapShareButton(_ sender: UIButton) {
    print("Share Button 클릭")
  }
}

// MARK: - LayoutSupport
extension SearchDestinationViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
    view.addSubview(mockThumbnailImageView)
  }
  
  func setConstraints() {
    mockThumbnailImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(200)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(mockThumbnailImageView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchDestinationViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    3
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch section {
    case 0: 
      return 1
    case 1:
      return 1
    case 2:
      return 6
    default:
      return 1
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      guard let titleCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchDestinationTitleCell.id,
        for: indexPath
      ) as? SearchDestinationTitleCell else { return .init() }
      titleCell.configure(title: "서문수육애국밥", address: "대전 동구 대학로 37")
      return titleCell
    case 1:
      guard let serviceCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchDestinationServiceCell.id,
        for: indexPath
      ) as? SearchDestinationServiceCell else { return .init() }
      let mockModels: [SearchDestinationServiceTypeViewInfo] = [
        // TODO: - 추후에 ServiceType을 enum으로 정의하기
        .init(imageName: "cooker", title: "식당"),
        .init(imageName: "parking", title: "주차가능"),
        .init(imageName: "takeout", title: "포장가능")
      ]
      serviceCell.configure(models: mockModels)
      return serviceCell
    case 2:
      guard let contentCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchDestinationContentCell.id,
        for: indexPath
      ) as? SearchDestinationContentCell else { return .init() }
      let mockModels: [SearchDestinationContentInfo] = [
        .init(title: "🕐영업시간",
              description: """
                           월 09:00 ~ 18:00
                           화 09:00 ~ 18:00
                           수 09:00 ~ 18:00
                           목 09:00 ~ 18:00
                           금 09:00 ~ 18:00
                           """
             ),
        .init(title: "⛔️휴무일", description: "둘째 넷째 화요일"),
        .init(title: "🍱대표 메뉴", description: """
        수육국밥:     7,000원
        머리고기국밥:  8,000원
        순대국밥:     8,000원
        특 모듬국밥:   8,000원
        """),
        .init(title: "🅿️주차요금", description: "무료"),
        .init(title: "📞️전화번호", description: "042-282-5954"),
        .init(title: "✔️️서비스", description: "주차 가능 / 포장 가능")
      ]
      let mockModel = mockModels[indexPath.item]
      contentCell.configure(with: mockModel)
      return contentCell
    default:
      return .init()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension SearchDestinationViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let titleCell = cell as? SearchDestinationTitleCell else { return }
    titleCell.updateToggleButtonVisibility()
  }
}

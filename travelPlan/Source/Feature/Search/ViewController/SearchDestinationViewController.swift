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
  private let layout = UICollectionViewFlowLayout().set {
    $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
  }
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: SearchDestinationCollectionViewLayout().makeLayout()
  ).set {
    $0.backgroundColor = .yg.littleWhite
    $0.register(SearchDestinationTitleCell.self, forCellWithReuseIdentifier: SearchDestinationTitleCell.id)
    $0.dataSource = self
    $0.delegate = self
  }
  private var collectionViewWillDisplayIsFirstCalled = false
  
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
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchDestinationViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchDestinationTitleCell.id,
      for: indexPath
    ) as? SearchDestinationTitleCell else { return .init() }
    //    cell.configure(title: "대전시립미술관", address: "대전광역시 서구 둔산대로117번길 155")
    cell.configure(title: "대전시립미술관미술관미술관미술관미술관미술관미술관미술관미술관미술관미술관미술관미술관",
                   address: "대전광역시대전광역시대전광역시대전광역시대전광역시대전광역시")
    return cell
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

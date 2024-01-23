//
//  PhotoViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit
import SnapKit
import Photos

final class PhotoViewController: UIViewController {
  // MARK: - Nested
  private enum Const {
    static let numberOfColumns = 4.0
    static let cellSpace = 1.0
    static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
    static let cellSize = CGSize(width: length, height: length)
    static let scale = UIScreen.main.scale
  }
  
  // MARK: - Properties
  weak var coordinator: PhotoCoordinator?
  private var dataSource = [PhotoCellInfo]()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 1
      $0.minimumInteritemSpacing = 1
      $0.itemSize = Const.cellSize
    }
  ).set {
    $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
    $0.dataSource = self
  }
  
  private lazy var cancelButton: BaseNavigationLeftButton = .init().set {
    $0.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
  }
  
  private lazy var finishButton: BaseNavigationRightButton = .init().set {
    $0.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
  }
  
  private lazy var titleView: NavigationTitleWithClickView = .init(
    title: "최근 항목",
    layoutType: .rightImage
  ).set {
    self.addGestureRecognizer(from: $0, action: #selector(didTapTitleView))
  }
  
  private var currentAlbumIndex = 0 {
    didSet { loadImages() }
  }
  private let albumService: AlbumService = ReviewWriteAlbumService()
  private let photoService: PhotoService = ReviewWritePhotoService()
  private var albums = [PHFetchResult<PHAsset>]()
  
  // index: order-1
  // element: indexPath.item
  private var selectedIndexArray = [Int]()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    loadAlbums(completion: { [weak self] in
      self?.loadImages()
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
    (tabBarController as? MainTabBarController)?.hideShadowLayer()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
    (tabBarController as? MainTabBarController)?.showShadowLayer()
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LayoutSupport
extension PhotoViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    dataSource.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PhotoCell.id,
      for: indexPath
    ) as? PhotoCell else { return .init() }
    
    let imageInfo = dataSource[indexPath.item]
    let asset = imageInfo.asset
    let imageSize = CGSize(width: Const.cellSize.width * Const.scale,
                           height: Const.cellSize.height * Const.scale)
    photoService.fetchImage(
      asset: asset,
      size: imageSize,
      contentMode: .aspectFit) { [weak cell] image in
        let cellInfo = PhotoCellInfo(asset: asset, image: image, selectedOrder: imageInfo.selectedOrder)
        cell?.configure(with: cellInfo)
      }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let cellInfo = dataSource[indexPath.item]
    let newIndexPaths: [IndexPath]
    if case .selected = cellInfo.selectedOrder {
      dataSource[indexPath.item].selectedOrder = .none
      selectedIndexArray.removeAll(where: { $0 == indexPath.item })
      
      for (order, index) in selectedIndexArray.enumerated() {
        let order = order + 1
        let prev = dataSource[index]
        dataSource[index] = PhotoCellInfo(asset: prev.asset, image: prev.image, selectedOrder: .selected(order))
      }
      newIndexPaths = [indexPath] + selectedIndexArray.map { IndexPath(item: $0, section: 0) }
    } else {
      guard selectedIndexArray.count < 20 else { return }
      
      selectedIndexArray.append(indexPath.item)
      dataSource[indexPath.item].selectedOrder = .selected(selectedIndexArray.count)
      newIndexPaths = selectedIndexArray.map { IndexPath(item: $0, section: .zero) }
    }
    
    update(indexPaths: newIndexPaths)
  }
}

// MARK: - Private Helpers
extension PhotoViewController {
  private func update(indexPaths: [IndexPath]) {
    collectionView.performBatchUpdates {
      collectionView.reloadItems(at: indexPaths)
    }
  }
  
  private func loadAlbums(completion: @escaping () -> Void) {
    albumService.getAlbums(mediaType: .image) { [weak self] albumInfos in
      self?.albums = albumInfos.map(\.album)
      completion()
    }
  }
  
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = .init(customView: cancelButton)
    navigationItem.rightBarButtonItem = .init(customView: finishButton)
    navigationItem.titleView = titleView
  }
  
  private func addGestureRecognizer(from view: UIView, action: Selector?) {
    let tapGesture = UITapGestureRecognizer(target: self, action: action)
    view.addGestureRecognizer(tapGesture)
  }
  
  private func loadImages() {
    let album = albums[currentAlbumIndex]
    photoService.convertAlbumToPHAssets(album: album) { [weak self] assets in
      self?.dataSource = assets.map { PhotoCellInfo(asset: $0, image: nil, selectedOrder: .none) }
      self?.collectionView.reloadData()
    }
  }
}

// MARK: - Actions
private extension PhotoViewController {
  @objc func didTapCancelButton(_ sender: UIButton) {
    print("취소 버튼 클릭")
    coordinator?.finish(withAnimated: true)
  }
  
  @objc func didTapFinishButton(_ sender: UIButton) {
    print("완료 버튼 클릭")
    coordinator?.finish(withAnimated: true)
  }
  
  @objc func didTapTitleView() {
    print("최근항목 선택됨")
  }
}

// MARK: - PhotoCellDelegate
extension PhotoViewController: PhotoCellDelegate {
  func didTapOrderView(_ view: UIView) {
    
  }
}

// MARK: - UINavigationControllerDelegate
extension PhotoViewController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    
    if operation == .push {
      return SlideUpAnimator()
    } else if operation == .pop {
      return SlideDownAnimator()
    } else {
      return nil
    }
  }
}

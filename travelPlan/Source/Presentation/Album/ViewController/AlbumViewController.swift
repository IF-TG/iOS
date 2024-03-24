//
//  AlbumViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit
import SnapKit
import Photos
import Combine

final class AlbumViewController: UIViewController {
  // MARK: - Nested
  private enum Const {
    static let numberOfColumns = 4.0
    static let cellSpace = 1.0
    static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
    static let cellSize = CGSize(width: length, height: length)
    static let scale = UIScreen.main.scale
  }
  
  // MARK: - Properties
  weak var coordinator: AlbumCoordinator?
  private let photoService: any PhotoService
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
  
//  private var currentAlbumIndex = 0 {
//    didSet { loadImages() }
//  }
//  private let albumService: AlbumService = ReviewWriteAlbumService()
//  private let photoService: PhotoService = ReviewWritePhotoService()
//  private var albums = [PHFetchResult<PHAsset>]()
  
  /// - index: order-1
  /// - element: indexPath.item
//  @Published private var selectedIndexArray = [Int]()
  private var subscriptions = Set<AnyCancellable>()
  var imageCompletionHandler: (([UIImage]) -> Void)?
  private let viewModel: any AlbumViewModelable
  private let input = AlbumViewModelInput()
  
  // MARK: - LifeCycle
  init(viewModel: any AlbumViewModelable, photoService: any PhotoService) {
    self.viewModel = viewModel
    self.photoService = photoService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bind()
    input.viewDidLoad.send(.image)
//    loadAlbums(completion: { [weak self] in
//      self?.loadImages()
//    })
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
    print("deinit: \(AlbumViewController.self)")
  }
}

// MARK: - LayoutSupport
extension AlbumViewController: LayoutSupport {
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
extension AlbumViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    viewModel.dataSource.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PhotoCell.id,
      for: indexPath
    ) as? PhotoCell else { return .init() }
    
    cell.delegate = self
    
    let imageSize = CGSize(
      width: Const.cellSize.width * Const.scale,
      height: Const.cellSize.height * Const.scale
    )
    photoService.fetchImage(
      asset: viewModel.dataSource[indexPath.item].asset,
      size: imageSize,
      contentMode: .aspectFit) { [weak cell] image in
        let cellInfo = PhotoCellInfo(image: image, selectedOrder: .none)
        cell?.configure(with: cellInfo)
      }

    return cell
  }
}

// MARK: - Private Helpers
extension AlbumViewController {
  private func update(indexPaths: [IndexPath]) {
    collectionView.performBatchUpdates {
      collectionView.reloadItems(at: indexPaths)
    }
  }
  
//  private func loadAlbums(completion: @escaping () -> Void) {
//    albumService.getAlbums(mediaType: .image) { [weak self] albumEntities in
//      self?.albums = albumEntities.map(\.album)
//      completion()
//    }
//  }
  
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
  
//  private func loadImages() {
//    let album = albums[currentAlbumIndex]
//    photoService.convertAlbumToPHAssets(album: album) { [weak self] assets in
//      self?.dataSource = assets.map { PhotoEntity(asset: $0, image: nil, selectedOrder: .none) }
//      self?.collectionView.reloadData()
//    }
//  }
  
  private func bind() {
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .none:
          break
        case .showDetailPhoto:
          break
        case .reload:
          self?.collectionView.reloadData()
        }
      }
      .store(in: &subscriptions)
    
//    $selectedIndexArray
//      .sink { [weak self] arr in
//        if arr.count > 0 {
//          self?.finishButton.isEnabled = true
//          self?.finishButton.setTitleColor(.yg.primary, for: .normal)
//        } else {
//          self?.finishButton.isEnabled = false
//          self?.finishButton.setTitleColor(.yg.gray1, for: .normal)
//        }
//      }
//      .store(in: &subscriptions)
  }
}

// MARK: - Actions
private extension AlbumViewController {
  @objc func didTapCancelButton(_ sender: UIButton) {
    print("취소 버튼 클릭")
    coordinator?.finish(withAnimated: true)
  }
  
  @objc func didTapFinishButton(_ sender: UIButton) {
//    print("1. 완료 버튼 클릭")
//    var imageList = Array(repeating: UIImage(), count: selectedIndexArray.count)
//    let group = DispatchGroup()
//    for (i, indexPathItem) in selectedIndexArray.enumerated() {
//      group.enter()
    
//      photoService.fetchImage(
//        asset: viewModel.dataSource[indexPathItem].asset,
//        size: CGSize(width: UIScreen.main.bounds.width - 15 * 2,
//                     height: CGFloat.greatestFiniteMagnitude),
//        contentMode: .aspectFit) { image in
//          imageList[i] = image
//          group.leave()
//        }
//    }
    
//    group.notify(queue: .main) { [weak self] in
//      guard let self = self else { return }
//      self.imageCompletionHandler?(imageList)
//    }
//    
//    coordinator?.finish(withAnimated: true)
  }
  
  @objc func didTapTitleView() {
    print("최근항목 선택됨")
  }
}

// MARK: - PhotoCellDelegate
extension AlbumViewController: PhotoCellDelegate {
  func touchBegan(_ cell: UICollectionViewCell, quadrant: PhotoCellQuadrant) {
//    switch quadrant {
//    case .first:
//      guard let indexPath = collectionView.indexPath(for: cell) else { return }
//      
//      let cellInfo = dataSource[indexPath.item]
//      let newIndexPaths: [IndexPath]
//      
//      if case .selected = cellInfo.selectedOrder {
//        dataSource[indexPath.item].selectedOrder = .none
//        selectedIndexArray.removeAll(where: { $0 == indexPath.item })
//        
//        for (order, index) in selectedIndexArray.enumerated() {
//          let order = order + 1
//          let prev = dataSource[index]
//          dataSource[index] = PhotoEntity(asset: prev.asset, image: prev.image, selectedOrder: .selected(order))
//        }
//        newIndexPaths = [indexPath] + selectedIndexArray.map { IndexPath(item: $0, section: 0) }
//      } else {
//        guard selectedIndexArray.count < 20 else { return }
//        
//        selectedIndexArray.append(indexPath.item)
//        dataSource[indexPath.item].selectedOrder = .selected(selectedIndexArray.count)
//        newIndexPaths = selectedIndexArray.map { IndexPath(item: $0, section: .zero) }
//      }
//      
//      update(indexPaths: newIndexPaths) // UI로직
//    case .else:
//      print("연관값으로 image넘겨서 imageDetailVC 열기")
//      // TODO: - 연관값으로 image넘겨서 imageDetailVC 열기
//      break
//    }
  }
}

// MARK: - UINavigationControllerDelegate
extension AlbumViewController: UINavigationControllerDelegate {
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

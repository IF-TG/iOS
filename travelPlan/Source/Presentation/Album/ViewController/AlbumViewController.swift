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
  
  private var subscriptions = Set<AnyCancellable>()
  var finishButtonHandler: (([PHAsset]) -> Void)?
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
    input.viewDidLoad.send()
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
    let photoModel = viewModel.dataSource[indexPath.item]
    
    photoService.fetchImage(
      asset: photoModel.asset,
      size: imageSize,
      contentMode: .aspectFit
    ) { [weak cell] image in
      let cellInfo = PhotoCellInfo(image: image, selectedOrder: photoModel.selectedOrder)
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
  
  private func decideFinishButtonState(_ shouldAvtivate: Bool) {
    if shouldAvtivate {
      self.finishButton.isEnabled = true
      self.finishButton.setTitleColor(.yg.primary, for: .normal)
    } else {
      self.finishButton.isEnabled = false
      self.finishButton.setTitleColor(.yg.gray1, for: .normal)
    }
  }
  
  private func bind() {
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .none:
          break
        case .showDetailPhoto:
          // TODO: - 사진확대화면을 보여줘야합니다.
          break
        case .reloadData:
          self?.collectionView.reloadData()
        case .reloadItem(let indexPaths):
          self?.update(indexPaths: indexPaths)
        case .activateFinishButton(let basis):
          self?.decideFinishButtonState(basis)
        case.popViewController:
          self?.coordinator?.finish(withAnimated: true)
        case .deliverAssets(let selectedAssets):
          self?.finishButtonHandler?(selectedAssets)
          self?.coordinator?.finish(withAnimated: true)
        }
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Actions
private extension AlbumViewController {
  @objc func didTapCancelButton(_ sender: UIButton) {
    input.didTapCancelButton.send()
  }
  
  @objc func didTapFinishButton(_ sender: UIButton) {
    input.didTapFinishButton.send()
  }
  
  @objc func didTapTitleView() {
    print("최근항목 선택됨")
  }
}

// MARK: - PhotoCellDelegate
extension AlbumViewController: PhotoCellDelegate {
  func touchBegan(_ cell: UICollectionViewCell, quadrant: PhotoCellQuadrant) {
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    if case .first = quadrant {
      input.touchedFirstQuadrant.send(indexPath)
    } else {
      input.touchedElseQuadrant.send(indexPath)
    }
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

//
//  AlbumPhotoDetailViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 1/24/24.
//

import UIKit
import SnapKit
import Combine
import Photos

final class AlbumPhotoDetailViewController: UIViewController {
  
  // MARK: - Properties
  private let viewModel: any AlbumPhotoDetailViewModelable
  private let input = AlbumPhotoDetailViewModelInput()
  private let photoService: PhotoService
  private var subscriptions = Set<AnyCancellable>()
  weak var coordinator: AlbumPhotoDetailCoordinatorDelegate?
  
  private let imageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
    $0.backgroundColor = .clear
    $0.isUserInteractionEnabled = true
  }
  
  private lazy var backButton = UIButton().set {
    $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    $0.setImage(
      UIImage(named: "back")?
        .setColor(.yg.littleWhite)
        .withRenderingMode(.alwaysOriginal),
      for: .normal
    )
  }
  
  private lazy var orderView = PhotoOrderView().set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOrderView))
    $0.addGestureRecognizer(tapGesture)
  }
  
  // MARK: - LifeCycle
  init(
    viewModel: any AlbumPhotoDetailViewModelable,
    photoService: any PhotoService
  ) {
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
    bind()
    
    input.viewDidLoad.send()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.hidesBackButton = true
    tabBarController?.tabBar.isHidden = true
    (tabBarController as? MainTabBarController)?.hideShadowLayer()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
    (tabBarController as? MainTabBarController)?.showShadowLayer()
  }
}

// MARK: - LayoutSupport
extension AlbumPhotoDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(imageView)
    imageView.addSubview(backButton)
    imageView.addSubview(orderView)
  }
  
  func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalTo(view)
    }
    
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().inset(20)
      $0.size.equalTo(24)
    }
    
    orderView.snp.makeConstraints {
      $0.centerY.equalTo(backButton)
      $0.trailing.equalToSuperview().inset(20)
      $0.size.equalTo(35)
    }
  }
}

// MARK: - Private Helpers
extension AlbumPhotoDetailViewController {
  private func setupStyles() {
    view.backgroundColor = .black
  }
  
  private func bind() {
    viewModel.transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .none:
          break
        case .cancelOrder:
          self?.orderView.initializeUI()
        case .setOrder(let order):
          self?.orderView.configureOrderView(orderText: String(order))
        case .popViewController:
          self?.coordinator?.popViewController()
        case .configureUI(let photoModel):
          self?.fetchDetailImage(asset: photoModel.asset)
          self?.configureOrder(selectedOrder: photoModel.selectedOrder)
        }
      }
      .store(in: &subscriptions)
  }
  
  private func fetchDetailImage(asset: PHAsset) {
    photoService.fetchImage(
      asset: asset,
      size: PHImageManagerMaximumSize,
      contentMode: .aspectFit,
      resizeModeOption: .none
    ) { [weak self] image in
      DispatchQueue.main.async {
        self?.imageView.image = image
      }
    }
  }
  
  private func configureOrder(selectedOrder: SelectionOrder) {
    if case .selected(let order) = selectedOrder {
      orderView.configureOrderView(orderText: String(order))
    }
  }
}

// MARK: - Actions
private extension AlbumPhotoDetailViewController {
  @objc func didTapBackButton(_ sender: UIButton) {
    input.didTapBackButton.send()
  }
  
  @objc func didTapOrderView() {
    input.didTapOrderView.send()
  }
}

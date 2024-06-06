//
//  SearchDestinationViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/27/23.
//

import UIKit
import SnapKit
import Combine

enum DestinationType {
  case cultureFacility
  case touristAttraction
  case leports
  case restaurant
  case shopping
  case festival
}

class SearchDestinationViewController: UIViewController {
  enum Common {
    static var backgroundColor: UIColor {
      return .yg.littleWhite
    }
  }
  
  // MARK: - Dependencies
  private let viewModel: any SearchDestinationViewModel
  
  // MARK: - Properties
  private let copyAlertView = CopyAlertView().set {
    $0.isHidden = true
    $0.alpha = 0
  }
  
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
  
  private let layout = SearchDestinationCollectionViewLayout().makeLayout().set {
    $0.register(InnerRoundRectReusableView.self, forDecorationViewOfKind: InnerRoundRectReusableView.baseID)
  }
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: layout
  ).set {
    $0.register(SearchDestinationTitleCell.self, forCellWithReuseIdentifier: SearchDestinationTitleCell.id)
    $0.register(SearchDestinationServiceCell.self, forCellWithReuseIdentifier: SearchDestinationServiceCell.id)
    $0.register(SearchDestinationContentCell.self, forCellWithReuseIdentifier: SearchDestinationContentCell.id)
    $0.backgroundColor = Common.backgroundColor
    $0.dataSource = self
    $0.delegate = self
    $0.layer.cornerRadius = 50
    $0.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
  }
  private var collectionViewWillDisplayIsFirstCalled = false
  // FIXME: - will erase
  private let thumbnailImageView = UIImageView().set {
//    $0.image = .init(named: "seomun")
    $0.backgroundColor = Common.backgroundColor
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let input = SearchDestinationViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()
  // MARK: - LifeCycle
  init(viewModel: any SearchDestinationViewModel, type: DestinationType) {
    self.viewModel = viewModel
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
    bind()
    input.viewDidLoad.send()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupThumbnailImageViewLayer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTabBarVisibility(false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    updateTabBarVisibility(true)
  }
}

extension SearchDestinationViewController {
  private func setupThumbnailImageViewLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = thumbnailImageView.bounds
    gradientLayer.colors = [
      UIColor.black.withAlphaComponent(0.08).cgColor,
      UIColor.clear.cgColor
    ]
    gradientLayer.locations = [0, 0.28]
    thumbnailImageView.layer.addSublayer(gradientLayer)
  }
  
  private func bind() {
    viewModel
      .transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .appearCopyAlert:
          UIView.animate(withDuration: 1.0, animations: {
            self?.copyAlertView.isHidden = false
            self?.copyAlertView.alpha = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              UIView.animate(withDuration: 0.5, animations: {
                self?.copyAlertView.alpha = 0
              }) { _ in
                self?.copyAlertView.isHidden = true
              }
            }
          })
          // TODO: - 주소 복사 수행 후, alert보이게 하기
          
        case .none:
          break
        case .reloadData(let thumbnailData):
          self?.collectionView.reloadData()
          guard let self = self else { return }
          self.thumbnailImageView.image = UIImage(data: thumbnailData)
        }
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Private Helpers
extension SearchDestinationViewController {
  private func setupNavigationBar() {
    setupDefaultBackBarButtonItem(tintColor: .white)
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(customView: shareButton),
      UIBarButtonItem(customView: starButton)
    ]
  }
  
  private func setupStyles() {
    view.backgroundColor = Common.backgroundColor
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
    view.addSubview(thumbnailImageView)
    view.addSubview(collectionView)
    collectionView.addSubview(copyAlertView)
    view.bringSubviewToFront(collectionView)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(325)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(thumbnailImageView.snp.bottom).inset(50)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    copyAlertView.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(11)
      $0.height.equalTo(40)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchDestinationViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.dataSource.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch viewModel.dataSource[section] {
    case .main:
      return 1
    case .temp:
      return 0
    case .content(let infos):
      return infos.count
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch viewModel.dataSource[indexPath.section] {
    case .main(let info):
      guard let titleCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchDestinationTitleCell.id,
        for: indexPath
      ) as? SearchDestinationTitleCell else { return .init() }
      
      titleCell.configure(mainInfo: info)
      titleCell.bind(to: input.didTapCopyAddressButton)
      return titleCell
      
    case .temp:
      return UICollectionViewCell()
      
    case .content(let infos):
      guard let contentCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchDestinationContentCell.id,
        for: indexPath
      ) as? SearchDestinationContentCell else { return .init() }
      
      contentCell.configure(with: infos[indexPath.item])
      return contentCell
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

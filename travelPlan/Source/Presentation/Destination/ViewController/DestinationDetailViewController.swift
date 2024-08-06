//
//  DestinationDetailViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/27/23.
//

import UIKit
import SnapKit
import Combine

class DestinationDetailViewController: UIViewController {
  enum Common {
    static var backgroundColor: UIColor {
      return .yg.littleWhite
    }
  }
  
  // MARK: - Dependencies
  private let viewModel: any DestinationDetailViewModel
  
  // MARK: - Properties
  private let landscapeToastView = LandscapeToastView(text: "복사되었습니다.")
  
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
  
  private let layout = DestinationDetailCollectionViewLayout()
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: layout.makeLayout().set {
      $0.register(InnerRoundRectReusableView.self, forDecorationViewOfKind: InnerRoundRectReusableView.baseID)
    }
  ).set {
    $0.register(DestinationDetailHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: DestinationDetailHeaderView.identifier)
    $0.register(type: DestinationDetailTitleCell.self)
    $0.register(type: DestinationDetailServiceCell.self)
    $0.register(type: DestinationDetailContentCell.self)
    $0.backgroundColor = Common.backgroundColor
    $0.dataSource = self
    $0.delegate = self
    $0.contentInsetAdjustmentBehavior = .never
  }
  
  private let input = DestinationDetailViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()
  
  private var isHeaderViewFirstDequeue = false
  
  // MARK: - LifeCycle
  init(viewModel: any DestinationDetailViewModel) {
    self.viewModel = viewModel
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTabBarVisibility(false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    updateTabBarVisibility(true)
  }
}

extension DestinationDetailViewController {
  private func bind() {
    viewModel
      .transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .appearCopyAlert:
          self?.landscapeToastView.performGhostAnimation()
        case .none:
          break
        case .reloadData:
          self?.collectionView.reloadData()
        case .unexpectedError(description: let description):
          print("에러 발생: \(description)")
        }
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Private Helpers
extension DestinationDetailViewController {
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
private extension DestinationDetailViewController {
  @objc func didTapStarButton(_ sender: UIButton) {
    print("Star Button 클릭")
  }
  
  @objc func didTapShareButton(_ sender: UIButton) {
    print("Share Button 클릭")
  }
}

// MARK: - LayoutSupport
extension DestinationDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
    collectionView.addSubview(landscapeToastView)
    view.bringSubviewToFront(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    landscapeToastView.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(7)
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(11)
      $0.height.equalTo(40)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension DestinationDetailViewController: UICollectionViewDataSource {
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
        withReuseIdentifier: DestinationDetailTitleCell.id,
        for: indexPath
      ) as? DestinationDetailTitleCell else { return .init() }
      
      titleCell.configure(mainInfo: info)
      titleCell.bind(to: input.didTapCopyAddressButton)
      return titleCell
      
    case .temp:
      return UICollectionViewCell()
      
    case .content(let infos):
      guard let contentCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DestinationDetailContentCell.id,
        for: indexPath
      ) as? DestinationDetailContentCell else { return .init() }
      
      contentCell.configure(with: infos[indexPath.item])
      return contentCell
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: DestinationDetailHeaderView.identifier,
      for: indexPath
    ) as? DestinationDetailHeaderView else { return .init() }
    if case .main(let mainInfo) = viewModel.dataSource[indexPath.section] {
      if !isHeaderViewFirstDequeue {
        headerView.configure(with: mainInfo.headerInfo.imageDatas)
        isHeaderViewFirstDequeue.toggle()
      }
      return headerView
    }
    return .init()
  }
}

// MARK: - UICollectionViewDelegate
extension DestinationDetailViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let titleCell = cell as? DestinationDetailTitleCell else { return }
    titleCell.updateToggleButtonVisibility()
  }
}

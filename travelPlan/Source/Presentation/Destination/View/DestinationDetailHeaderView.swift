//
//  DestinationDetailHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 6/12/24.
//

import UIKit
import SnapKit

final class DestinationDetailHeaderView: UICollectionReusableView {
  enum Constant {
    static var bumperViewHeight: CGFloat {
      return 38-DestinationDetailCollectionViewLayout.Constant.SectionZero.sectionInsetTop
    }
  }
  
  // MARK: - Properties
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.makeCompositionalLayout()
  ).set {
    $0.register(type: DestinationDetailImageCell.self)
    $0.contentInsetAdjustmentBehavior = .never
    $0.dataSource = self
  }
  
  private var dataSource = [Data]()
  
  private let bumperView = UIView().set {
    $0.backgroundColor = .yg.littleWhite
    $0.layer.cornerRadius = Constant.bumperViewHeight
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  private let indicatorBoxView = IndicatorBoxView()
  private var hasDisplayedInfiniteCarouselSection = false
  /// configure 메소드에서 scrollView.scrollToItem가 먹히지 않기 때문에, dataSource가 적용된 후에
  ///  section.visibleItemsInvalidationHandler에서 초기 scrollToItem을 적용해주기 위해 사용하는 변수
  ///  carousel을 적용하는 경우에만 해당
  private var isConfiguredIfCarousel = false
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupLayer()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension DestinationDetailHeaderView {
  func configure(with imageDatas: [Data]) {
    let firstPage = 1
    if imageDatas.count > 1, let last = imageDatas.last, let first = imageDatas.first {
      dataSource = imageDatas
      dataSource.insert(last, at: 0)
      dataSource.append(first)
      indicatorBoxView.configure(currentPage: firstPage, totalPage: imageDatas.count)
      isConfiguredIfCarousel = true
    } else if imageDatas.count == 1 { // 이미지의 개수가 1개만 있는 경우는 트릭 사용 제외
      dataSource = imageDatas
      indicatorBoxView.configure(currentPage: firstPage, totalPage: imageDatas.count)
    } else { // 이미지가 존재하지 않는 경우
      let url = Bundle.main.url(forResource: "emptyImage", withExtension: "png")!
      guard let data = try? Data(contentsOf: url) else { return }
      
      dataSource = [data]
      indicatorBoxView.configure(currentPage: firstPage, totalPage: firstPage)
    }
    collectionView.reloadData()
  }
}

// MARK: - Private Helpers
extension DestinationDetailHeaderView {
  private func setupStyles() {
    self.clipsToBounds = true
  }
  
  private func setupLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [
      UIColor.black.withAlphaComponent(0.08).cgColor,
      UIColor.clear.cgColor
    ]
    gradientLayer.locations = [0, 0.28]
    layer.addSublayer(gradientLayer)
  }
  
  private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case 0:
        return self?.createImageViewSection()
      default:
        return nil
      }
    }
  }
  
  private func createImageViewSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                           heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    
    section.visibleItemsInvalidationHandler = { [weak self] (_, contentOffset, environment) in
      guard let self = self else { return }
      
      let contentSize = environment.container.contentSize
      
      if !hasDisplayedInfiniteCarouselSection, isConfiguredIfCarousel {
        hasDisplayedInfiniteCarouselSection.toggle()
        collectionView.scrollToItem(
          at: IndexPath(item: 1, section: .zero),
          at: .centeredHorizontally,
          animated: false
        )
        return
      }
      
      guard validateCarouselAction(contentOffset: contentOffset, contentWidth: contentSize.width) else { return }
      let currentPageIndex = Int(round(contentOffset.x / contentSize.width))
      self.indicatorBoxView.update(currentPage: currentPageIndex)
      scrollToItemIfMoveEdgeIndex(contentOffset: contentOffset, contentWidth: contentSize.width)
    }
    return section
  }
  
  private func validateCarouselAction(contentOffset: CGPoint, contentWidth: Double) -> Bool {
    let isFinishDeceleration = (Int(contentOffset.x) % Int(contentWidth)) == 0
    
    return isFinishDeceleration && dataSource.count > 1
  }
  
  private func scrollToItemIfMoveEdgeIndex(contentOffset: CGPoint, contentWidth: Double) {
    // 오른쪽 끝으로 가면 왼쪽에 존재하는 fake data로 스크롤 이동
    if contentOffset.x <= 0 {
      collectionView.scrollToItem(
        at: IndexPath(item: dataSource.count-2, section: .zero),
        at: .centeredHorizontally,
        animated: false
      )
    }

    // 왼쪽 끝으로 가면 오른쪽에 존재하는 fake data로 스크롤 이동
    if contentOffset.x >= Double(dataSource.count-1) * contentWidth {
      collectionView.scrollToItem(
        at: IndexPath(item: 1, section: .zero),
        at: .centeredHorizontally,
        animated: false
      )
    }
  }
}

// MARK: - UICollectionViewDataSource
extension DestinationDetailHeaderView: UICollectionViewDataSource {
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
      withReuseIdentifier: DestinationDetailImageCell.identifier,
      for: indexPath
    ) as? DestinationDetailImageCell else { return .init() }
    
    cell.configure(with: dataSource[indexPath.item])
    return cell
  }
}

// MARK: - LayoutSupport
extension DestinationDetailHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(indicatorBoxView)
    addSubview(collectionView)
    addSubview(bumperView)
    _=[bumperView, indicatorBoxView].map { bringSubviewToFront($0) }
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    indicatorBoxView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(bumperView.snp.top).offset(-12)
      $0.height.equalTo(22)
      $0.width.equalTo(50)
    }
    
    bumperView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Constant.bumperViewHeight * 2)
      $0.bottom.equalToSuperview().offset(Constant.bumperViewHeight)
    }
  }
}

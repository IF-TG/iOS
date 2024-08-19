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
  
  private var dataSource = [Data?]()
  
  private let bumperView = UIView().set {
    $0.backgroundColor = .yg.littleWhite
    $0.layer.cornerRadius = Constant.bumperViewHeight
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  private let indicatorBoxView = IndicatorBoxView()
  
  private var willSetContentOffsetToRightEdge = false
  private var willSetContentOffsetToLeftEdge = false
  
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
    dataSource = imageDatas
    
    if dataSource.count > 1, let last = dataSource.last, let first = dataSource.first {
      dataSource.insert(last, at: 0)
      dataSource.append(first)
      let firstPage = 1
      indicatorBoxView.configure(currentPage: firstPage, totalPage: imageDatas.count)
      collectionView.setContentOffset(
        .init(x: collectionView.bounds.width, y: collectionView.contentOffset.y),
        animated: false
      )
      collectionView.reloadData()
    } else if imageDatas.count == 1 { // 이미지의 개수가 1개만 있는 경우는 트릭 사용 제외
      let firstPage = 1
      indicatorBoxView.configure(currentPage: firstPage, totalPage: imageDatas.count)
      collectionView.reloadData()
    } else { // 이미지가 존재하지 않는 경우
      // empty image를 적용하기
    }
  }
}

// MARK: - Private Helpers
extension DestinationDetailHeaderView {
  private func shouldTrick() -> Bool {
    if dataSource.count > 1, let _ = dataSource.last, let _ = dataSource.first {
      return true
    }
    return false
  }
  
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
//      let count = dataSource.count
//      
//      if shouldTrick() {
//        if contentOffset.x < 0, !willSetContentOffsetToRightEdge {
//          willSetContentOffsetToRightEdge.toggle()
//          collectionView.setContentOffset(
//            .init(x: contentSize.width * Double(count - 2), y: contentOffset.y),
//            animated: false
//          )
//          willSetContentOffsetToRightEdge.toggle()
//        } else if contentOffset.x > Double(count - 1) * contentSize.width, !willSetContentOffsetToLeftEdge {
//          willSetContentOffsetToLeftEdge.toggle()
//          collectionView.setContentOffset(
//            .init(x: contentSize.width, y: contentOffset.y),
//            animated: false
//          )
//          willSetContentOffsetToLeftEdge.toggle()
//        }
//      }
      
      let currentPageIndex = Int(round(contentOffset.x / contentSize.width))
      self.indicatorBoxView.update(currentPage: currentPageIndex + 1)
    }
    return section
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

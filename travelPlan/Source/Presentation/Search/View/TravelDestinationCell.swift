//
//  TravelDestinationCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/06/01.
//

import UIKit
import SnapKit
import Combine

class TravelDestinationCell: UICollectionViewCell {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private lazy var containerView: BaseDestinationView<LeftAlignThreeLabelsView>
  = .init(centerView: LeftAlignThreeLabelsView(), imageViewType: .default)
  
  private var cancellable: AnyCancellable?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    containerView.clearButtonSelectedState()
    containerView.clearThumbnailImage()
  }
}

// MARK: - Helpers
extension TravelDestinationCell {
  func configure(with info: TravelDestinationInfo) {
    containerView.configure(
      centerViewInfo: LeftAlignThreeLabelsView.Model(
        place: info.place,
        category: info.category,
        location: info.location
      ),
      imageData: info.imageData,
      isSelectedButton: info.isButtonSelected
    )
  }
  
  // in SearchResultListVC
  func bind(to publisher: PassthroughSubject<(IndexPath, Bool), Never>, indexPath: IndexPath) {
    cancellable?.cancel()
    cancellable = containerView
      .starButtonTapPublisher
      .sink { [weak self] isSelected in
        guard let self = self else { return }
        publisher.send((indexPath, isSelected))
      }
  }
  
  // in SearchVC
  func bind(to publisher: PassthroughSubject<IndexPath, Never>, indexPath: IndexPath) {
    cancellable?.cancel()
    cancellable = containerView
      .starButtonTapPublisher
      .sink { _ in
        publisher.send(indexPath)
      }
  }
}

// MARK: - LayoutSupport
extension TravelDestinationCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(containerView)
  }
  
  func setConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
  }
}

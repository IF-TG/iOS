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
  
//  private var viewModel: TravelDestinationCellViewModel? {
//    didSet {
//      bind()
//    }
//  }
  
  private lazy var containerView: BaseDestinationView<LeftAlignThreeLabelsView>
  = .init(centerView: LeftAlignThreeLabelsView(), imageViewType: .default)
  
  var buttonPublisher: AnyPublisher<Void, Never> {
    return containerView.starButtonPublisher.eraseToAnyPublisher()
  }
  
//  private lazy var input = Input()
  private var subscriptions = Set<AnyCancellable>()
  
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
    subscriptions.removeAll()
  }
}

//// MARK: - ViewBindCase
//extension TravelDestinationCell: ViewBindCase {
//  func bind() {
//    guard let viewModel = self.viewModel else { return }
//    
//    let output = viewModel.transform(input)
//    output
//      .receive(on: RunLoop.main)
//      .sink { [weak self] completion in
//        switch completion {
//        case .finished:
//          print("DEBUG: finished SearchFamousSpotCell")
//        case .failure(let error):
//          self?.handleError(error)
//        }
//      } receiveValue: { [weak self] in
//        self?.render($0)
//      }
//      .store(in: &subscriptions)
//  }
//  
//  func render(_ state: State) {
//    switch state {
//    case .changeButtonColor:
//      containerView.toggleStarButtonState()
//    case .none: break
//    }
//  }
//  
//  func handleError(_ error: ErrorType) {
//    switch error {
//    case .fatalError: 
//      print("DEBUG: fatalError occurred")
//    case .networkError:
//      print("DEBUG: networkError occurred")
//    case .unexpected:
//      print("DEBUG: unexpected occurred")
//    }
//  }
//}

// MARK: - Helpers
extension TravelDestinationCell {
  func configure(with info: TravelDestinationItemInfo) {
    containerView.configure(
      centerViewInfo: LeftAlignThreeLabelsView.Model(place: info.place, category: info.category, location: info.location),
      imageData: info.imageData,
      isSelectedButton: info.isSelectedButton
    )
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

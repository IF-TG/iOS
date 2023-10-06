//
//  SearchTopTenCell.swift
//  travelPlan
//
//  Created by SeokHyun on 10/7/23.
//

import UIKit

class SearchTopTenCell: UICollectionViewCell {
  // MARK: - Properties
  static var id: String {
    return String(describing: Self.self)
  }
  
  private var viewModel: TravelDestinationCellViewModel? {
    didSet {
      bind()
    }
  }
  
  private lazy var containerView: BaseDestinationView<LeftAlignThreeLabelsView>
  = .init(centerView: LeftAlignThreeLabelsView()).set {
    $0.delegate = self
  }
  
  private lazy var input = Input()
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
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
  
  private func bind() {
    guard let viewModel = self.viewModel else { return }
    
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          print("DEBUG: finished SearchFamousSpotCell")
        case .failure(let error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  private func render(_ state: State) {
    switch state {
    case .changeButtonColor:
      containerView.toggleStarButtonState()
    case .none: break
    }
  }
  
  private func handleError(_ error: ErrorType) {
    switch error {
    case .fatalError: print("DEBUG: fatalError occurred")
    case .networkError: print("DEBUG: networkError occurred")
    case .unexpected: print("DEBUG: unexpected occurred")
    }
  }
}

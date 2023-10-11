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
  typealias Input = TravelDestinationCellViewModel.Input
  typealias ErrorType = TravelDestinationCellViewModel.ErrorType
  typealias State = TravelDestinationCellViewModel.State
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private var viewModel: TravelDestinationCellViewModel? {
    didSet {
      bind()
    }
  }
  
  private lazy var containerView: BaseDestinationView<LeftAlignThreeLabelsView> 
  = .init(centerView: LeftAlignThreeLabelsView(), imageViewType: .default).set {
    $0.delegate = self
  }
  
  private lazy var input = Input()
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

// MARK: - ViewBindCase
extension TravelDestinationCell: ViewBindCase {
  func bind() {
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
  
  func render(_ state: State) {
    switch state {
    case .changeButtonColor:
      containerView.toggleStarButtonState()
    case .none: break
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .fatalError: 
      print("DEBUG: fatalError occurred")
    case .networkError:
      print("DEBUG: networkError occurred")
    case .unexpected:
      print("DEBUG: unexpected occurred")
    }
  }
}

// MARK: - StarButtonDelegate
extension TravelDestinationCell: StarButtonDelegate {
  func didTapStarButton(_ button: UIButton) {
    input.didTapStarButton.send()
  }
}

// MARK: - Helpers
extension TravelDestinationCell {
  func configure(with viewModel: TravelDestinationCellViewModel) {
    self.viewModel = viewModel
    
    containerView.configure(centerModel: viewModel.contentModel)
    containerView.configure(imageURL: viewModel.imagePath,
                            isSelectedButton: viewModel.isSelectedButton)
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

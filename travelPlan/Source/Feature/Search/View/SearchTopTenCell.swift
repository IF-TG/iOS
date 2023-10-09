//
//  SearchTopTenCell.swift
//  travelPlan
//
//  Created by SeokHyun on 10/7/23.
//

import UIKit
import Combine
import SnapKit

class SearchTopTenCell: UICollectionViewCell {
  typealias Input = SearchTopTenCellViewModel.Input
  typealias ErrorType = SearchTopTenCellViewModel.ErrorType
  typealias State = SearchTopTenCellViewModel.State
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private var viewModel: SearchTopTenCellViewModel? {
    didSet {
      bind()
    }
  }
  
  private let thumbnailImageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 7
    $0.clipsToBounds = true
  }
  
  private let rankingView: UIView = .init().set {
    $0.layer.cornerRadius = 2
    $0.backgroundColor = .yg.littleWhite
    $0.alpha = 0.9
  }
  
  private let rankingNumberLabel: UILabel = .init().set {
    $0.font = .init(pretendard: .semiBold, size: 16)
    $0.textColor = .yg.gray5
  }
  
  // TODO: - 순위뷰를 포함하는 이미지뷰를 주입해야 합니다.
  private lazy var containerView: BaseDestinationView<LeftAlignThreeLabelsView>
  = .init(
    centerView: LeftAlignThreeLabelsView(),
    imageViewType: .custom(imageView: self.thumbnailImageView)
  ).set {
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
    rankingNumberLabel.text = nil
  }
}

// MARK: - ViewBindCase
extension SearchTopTenCell: ViewBindCase {
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
extension SearchTopTenCell: StarButtonDelegate {
  func didTapStarButton(_ button: UIButton) {
    input.didTapStarButton.send()
  }
}

// MARK: - Helpers
extension SearchTopTenCell {
  func configure(with viewModel: SearchTopTenCellViewModel) {
    self.viewModel = viewModel
    
    containerView.configure(centerModel: viewModel.contentModel)
    containerView.configure(imageURL: viewModel.imagePath,
                            isSelectedButton: viewModel.isSelectedButton)
    rankingNumberLabel.text = "\(viewModel.ranking)"
  }
}

// MARK: - LayoutSupport
extension SearchTopTenCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(containerView)
    thumbnailImageView.addSubview(rankingView)
    rankingView.addSubview(rankingNumberLabel)
  }
  
  func setConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
    
    rankingView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().inset(8)
      $0.size.equalTo(20)
    }
    
    rankingNumberLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

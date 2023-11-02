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
  enum Constant {
    enum ThumbnailImageView {
      static let cornerRadius: CGFloat = 7
    }
    enum RankingView {
      static let cornerRadius: CGFloat = 2
      static let alpha: CGFloat = 0.9
      static let size: CGFloat = 20
      enum Spacing {
        static let leading: CGFloat = 8
        static let top: CGFloat = 8
      }
    }
    enum RankingNumberLabel {
      static let fontSize: CGFloat = 16
    }
  }
  
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
    $0.layer.cornerRadius = Constant.ThumbnailImageView.cornerRadius
    $0.clipsToBounds = true
  }
  
  private let rankingView: UIView = .init().set {
    $0.layer.cornerRadius = Constant.RankingView.cornerRadius
    $0.backgroundColor = .yg.littleWhite
    $0.alpha = Constant.RankingView.alpha
  }
  
  private let rankingNumberLabel: UILabel = .init().set {
    $0.font = .init(pretendard: .semiBold_600(fontSize: Constant.RankingNumberLabel.fontSize))
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
  typealias Input = SearchTopTenCellViewModel.Input
  typealias ErrorType = SearchTopTenCellViewModel.ErrorType
  typealias State = SearchTopTenCellViewModel.State
  
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
      typealias Cnst = Constant.RankingView
      $0.leading.equalToSuperview().inset(Cnst.Spacing.leading)
      $0.top.equalToSuperview().inset(Cnst.Spacing.top)
      $0.size.equalTo(Cnst.size)
    }
    
    rankingNumberLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

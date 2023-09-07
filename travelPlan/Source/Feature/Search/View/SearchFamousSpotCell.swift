//
//  SearchFamousSpotCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/06/01.
//

import UIKit
import SnapKit
import Combine

final class SearchFamousSpotCell: UICollectionViewCell {
  // MARK: - Properties
  private var viewModel: SearchFamousSpotCellViewModel? {
    didSet {
      bind()
    }
  }
  
  static var id: String {
    return String(describing: self)
  }
  
  private let thumbnailImageView: UIImageView = UIImageView().set {
    $0.image = UIImage(named: Constants.ThumbnailImageView.imageName)
    $0.layer.cornerRadius = Constants.ThumbnailImageView.cornerRadius
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private lazy var heartButton: SearchHeartButton = .init().set {
    $0.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
  }
  
  private let placeLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .semiBold, size: Constants.PlaceLabel.fontSize)
    $0.text = "관광 장소명"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.PlaceLabel.numberOfLines
  }
  
  private let categoryLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.CategoryLabel.fontSize)
    $0.textColor = .yg.gray6
    $0.text = "관광 카테고리"
    $0.numberOfLines = Constants.CategoryLabel.numberOfLines
  }
  
  private let areaLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.AreaLabel.size)
    $0.text = "지역명"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.AreaLabel.numberOfLines
  }
  
  private let labelStackView: UIStackView = UIStackView().set {
    $0.axis = .vertical
    $0.spacing = Constants.LabelStackView.spacing
    $0.alignment = .leading
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
    thumbnailImageView.image = nil
    subscriptions.removeAll()
  }
}

extension SearchFamousSpotCell: ViewBindCase {
  typealias Input = SearchFamousSpotCellViewModel.Input
  typealias ErrorType = SearchFamousSpotCellViewModel.ErrorType
  typealias State = SearchFamousSpotCellViewModel.State
  
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
      heartButton.isSelected.toggle()
    case .none: break
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .fatalError: print("DEBUG: fatalError occurred")
    case .networkError: print("DEBUG: networkError occurred")
    case .unexpected: print("DEBUG: unexpected occurred")
    }
  }
}

// MARK: - Actions
extension SearchFamousSpotCell {
  @objc private func didTapHeartButton() {
    // viewModelTODO: - CellViewModel 추가해서 input output 패턴 적용하고 delegate를 제거해야 합니다.
    input.didTapHeartButton.send()
    print("DEBUG: 버튼 변화됨!")
  }
}

// MARK: - Configure
extension SearchFamousSpotCell {
  func configure(with viewModel: SearchFamousSpotCellViewModel) {
    self.viewModel = viewModel
    
    thumbnailImageView.image = UIImage(named: viewModel.thumbnailImage ?? "tempProfile4")
    placeLabel.text = viewModel.place
    categoryLabel.text = viewModel.category
    areaLabel.text = viewModel.location
  }
}

// MARK: - LayoutSupport
extension SearchFamousSpotCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
    contentView.addSubview(labelStackView)
    contentView.addSubview(heartButton)
    _ = [placeLabel, categoryLabel, areaLabel]
      .map { labelStackView.addArrangedSubview($0) }
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalToSuperview().inset(Constants.ThumbnailImageView.Inset.top)
      $0.bottom.equalToSuperview().inset(Constants.ThumbnailImageView.Inset.bottom)
      $0.width.equalTo(thumbnailImageView.snp.height)
    }
    
    labelStackView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing)
        .offset(Constants.LabelStackView.Offset.leading)
      $0.trailing.lessThanOrEqualTo(heartButton.snp.leading)
        .offset(Constants.LabelStackView.Offset.trailing)
      $0.top.equalTo(thumbnailImageView)
    }
    
    heartButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constants.HeartButton.Inset.top)
      $0.trailing.equalToSuperview()
      $0.size.equalTo(Constants.HeartButton.size)
    }
  }
}

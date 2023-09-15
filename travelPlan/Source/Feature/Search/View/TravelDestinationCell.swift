//
//  TravelDestinationCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/06/01.
//

import UIKit
import SnapKit
import Combine

final class TravelDestinationCell: UICollectionViewCell {
  enum Constants {
    // MARK: - ThumbnailImageView
    enum ThumbnailImageView {
      static let imageName = "tempThumbnail1"
      static let cornerRadius: CGFloat = 3
      enum Inset {
        static let top: CGFloat = 5
        static let bottom: CGFloat = 5
      }
    }
    // MARK: - LabelStackView
    enum LabelStackView {
      static let spacing: CGFloat = 0
      enum Offset {
        static let leading: CGFloat = 15
        static let trailing: CGFloat = -20
      }
    }
    // MARK: - HeartButton
    enum HeartButton {
      static let size: CGFloat = 24
      enum Inset {
        static let top: CGFloat = 5
        static let trailing: CGFloat = 16
      }
    }
    // MARK: - PlaceLabel
    enum PlaceLabel {
      static let fontSize: CGFloat = 16
      static let numberOfLines = 1
    }
    // MARK: - CategoryLabel
    enum CategoryLabel {
      static let fontSize: CGFloat = 14
      static let numberOfLines = 1
    }
    // MARK: - AreaLabel
    enum AreaLabel {
      static let size: CGFloat = 14
      static let numberOfLines = 1
    }
  }
  
  // MARK: - Properties
  private var viewModel: TravelDestinationCellViewModel? {
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
  
  private lazy var starButton: SearchStarButton = .init(normalType: .empty).set {
    $0.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
  }
  
  private let titleLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .semiBold, size: Constants.PlaceLabel.fontSize)
    $0.text = "관광 장소명"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.PlaceLabel.numberOfLines
  }
  
  private let secondLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.CategoryLabel.fontSize)
    $0.textColor = .yg.gray6
    $0.text = "n/a"
    $0.numberOfLines = Constants.CategoryLabel.numberOfLines
  }
  
  private let thirdLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.AreaLabel.size)
    $0.text = "n/a"
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

extension TravelDestinationCell: ViewBindCase {
  typealias Input = TravelDestinationCellViewModel.Input
  typealias ErrorType = TravelDestinationCellViewModel.ErrorType
  typealias State = TravelDestinationCellViewModel.State
  
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
      starButton.isSelected.toggle()
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
extension TravelDestinationCell {
  @objc private func didTapStarButton() {
    // viewModelTODO: - CellViewModel 추가해서 input output 패턴 적용하고 delegate를 제거해야 합니다.
    input.didTapStarButton.send()
    print("DEBUG: 버튼 변화됨!")
  }
}

// MARK: - Configure
extension TravelDestinationCell {
  func configure(with viewModel: TravelDestinationCellViewModel) {
    self.viewModel = viewModel
    
    thumbnailImageView.image = UIImage(named: viewModel.thumbnailImage ?? "tempProfile4")
    titleLabel.text = viewModel.place
    secondLabel.text = viewModel.category
    thirdLabel.text = viewModel.location
  }
}

// MARK: - LayoutSupport
extension TravelDestinationCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
    contentView.addSubview(labelStackView)
    contentView.addSubview(starButton)
    _ = [titleLabel, secondLabel, thirdLabel]
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
      $0.trailing.lessThanOrEqualTo(starButton.snp.leading)
        .offset(Constants.LabelStackView.Offset.trailing)
      $0.top.equalTo(thumbnailImageView)
    }
    
    starButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constants.HeartButton.Inset.top)
      $0.trailing.equalToSuperview().inset(Constants.HeartButton.Inset.trailing)
      $0.size.equalTo(Constants.HeartButton.size)
    }
  }
}

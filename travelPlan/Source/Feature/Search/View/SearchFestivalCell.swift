//
//  SearchFestivalCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/30.
//

import Combine
import UIKit

import SnapKit

final class SearchFestivalCell: UICollectionViewCell {
  enum Constants {
    enum ThumbnailImageView {
      static let cornerRadius: CGFloat = 7
    }
    enum ThumbnailGradientLayer {
      static let lastColorAlpha: CGFloat = 1.0
      static let firstLocation: NSNumber = 0.7
      static let lastLocation: NSNumber = 1.0
    }
    
    enum StarButton {
      enum Inset {
        static let top: CGFloat = 8
        static let trailing: CGFloat = 8
      }
      static let size: CGFloat = 24
    }
    
    enum FestivalLabel {
      static let fontSize: CGFloat = 18
      static let numberOfLines = 1
      enum Inset {
        static let leading: CGFloat = 4
        static let trailing: CGFloat = 4
      }
    }
    
    enum PeriodLabel {
      static let fontSize: CGFloat = 12
      enum Inset {
        static let trailing: CGFloat = 4
        static let bottom: CGFloat = 6
      }
    }
  }
  
  // MARK: - Properties
  private var viewModel: SearchFestivalCellViewModel? {
    didSet {
      bind()
    }
  }
  
  private lazy var input = Input()
  private var subscriptions = Set<AnyCancellable>()
  
  static var id: String {
    return String(describing: self)
  }
  
  private lazy var thumbnailImageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
    $0.isUserInteractionEnabled = true // UIImageView의 터치 이벤트를 감지하기 위해 인터랙션을 활성화
    $0.layer.cornerRadius = Constants.ThumbnailImageView.cornerRadius
    $0.layer.insertSublayer(self.thumbnailGradientLayer, at: .zero)
  }
  
  private let thumbnailGradientLayer: CAGradientLayer = .init().set {
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.yg.gray7.withAlphaComponent(Constants.ThumbnailGradientLayer.lastColorAlpha).cgColor
    ]
    $0.locations = [
      Constants.ThumbnailGradientLayer.firstLocation,
      Constants.ThumbnailGradientLayer.lastLocation
    ]
  }
  
  private lazy var starButton: SearchStarButton = .init(normalType: .white).set {
    $0.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
  }
  
  private let festivalLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .bold, size: Constants.FestivalLabel.fontSize)
    $0.textColor = .yg.littleWhite
    $0.numberOfLines = Constants.FestivalLabel.numberOfLines
    $0.textAlignment = .center
    $0.text = "축제명"
  }
  
  private let periodLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .semiBold, size: Constants.PeriodLabel.fontSize)
    $0.textColor = .yg.littleWhite
    $0.textAlignment = .center
    $0.text = "날짜"
  }
  
  override var bounds: CGRect {
    didSet {
      self.thumbnailGradientLayer.frame = self.bounds
    }
  }
  
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
    periodLabel.text = nil
    festivalLabel.text = nil
    subscriptions.removeAll()
  }
}

// MARK: - Actions
extension SearchFestivalCell {
  @objc private func didTapStarButton() {
    input.didTapStarButton.send()
  }
}

// MARK: - ViewBindCase
extension SearchFestivalCell: ViewBindCase {
  typealias Input = SearchFestivalCellViewModel.Input
  typealias ErrorType = SearchFestivalCellViewModel.ErrorType
  typealias State = SearchFestivalCellViewModel.State
  
  internal func bind() {
    guard let viewModel = self.viewModel else { return }
    
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          print("DEBUG: finished SearchBestFestivalCell")
        case .failure(let error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  internal func render(_ state: State) {
    switch state {
    case .changeButtonColor:
      // networkFIXME: - 서버의 저장에 따라 하트버튼 색의 UI를 변경해야합니다.
      starButton.isSelected.toggle()
    case .none: break
    }
  }
  
  internal func handleError(_ error: ErrorType) {
    switch error {
    case .fatalError:
      print("DEBUG: Error fatalError in SeachBestFestivalCell")
    case .unexpected:
      print("DEBUG: Error unexpected in SeachBestFestivalCell")
    case .networkError:
      print("DEBUG: Error networkError in SeachBestFestivalCell")
    }
  }
}

// MARK: - Configure
extension SearchFestivalCell {
  func configure(with viewModel: SearchFestivalCellViewModel) {
    self.viewModel = viewModel
    
    festivalLabel.text = viewModel.title
    periodLabel.text = viewModel.periodString
    starButton.isSelected = viewModel.isSelectedButton
    // imageTODO: - 이미지 적용
    thumbnailImageView.image = UIImage(named: viewModel.imagePath ?? "tempThumbnail7")
  }
}

// MARK: - LayoutSupport
extension SearchFestivalCell: LayoutSupport {
  func addSubviews() {
    thumbnailImageView.layer.insertSublayer(thumbnailGradientLayer, at: .zero)
    
    contentView.addSubview(thumbnailImageView)
    thumbnailImageView.addSubview(starButton)
    thumbnailImageView.addSubview(festivalLabel)
    thumbnailImageView.addSubview(periodLabel)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    starButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constants.StarButton.Inset.top)
      $0.trailing.equalToSuperview().inset(Constants.StarButton.Inset.trailing)
      $0.size.equalTo(Constants.StarButton.size)
    }
    
    festivalLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Constants.FestivalLabel.Inset.leading)
      $0.trailing.lessThanOrEqualToSuperview()
        .inset(Constants.FestivalLabel.Inset.trailing)
    }
    
    periodLabel.snp.makeConstraints {
      $0.top.equalTo(festivalLabel.snp.bottom)
      $0.leading.equalTo(festivalLabel)
      $0.trailing.lessThanOrEqualToSuperview()
        .inset(Constants.PeriodLabel.Inset.trailing)
      $0.bottom.equalToSuperview()
        .inset(Constants.PeriodLabel.Inset.bottom)
    }
  }
}

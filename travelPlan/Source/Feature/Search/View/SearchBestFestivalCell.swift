//
//  SearchBestFestivalCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/30.
//

import Combine
import UIKit

import SnapKit

final class SearchBestFestivalCell: UICollectionViewCell {
  // MARK: - Properties
  private var viewModel: SearchBestFestivalCellViewModel? {
    didSet {
      bind()
    }
  }
  private lazy var input = Input()
  private var subscriptions = Set<AnyCancellable>()
  
  static var id: String {
    return String(describing: self)
  }
  
  private let thumbnailImageView: UIImageView = .init().set {
    $0.layer.cornerRadius = Constants.ThumbnailImageView.cornerRadius
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
    $0.isUserInteractionEnabled = true // UIImageView의 터치 이벤트를 감지하기 위해 인터랙션을 활성화
  }
  
  private lazy var heartButton: SearchHeartButton = .init().set {
    $0.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
  }
  
  private let festivalLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .bold, size: Constants.FestivalLabel.fontSize)
    $0.textColor = .yg.gray00Background
    $0.numberOfLines = Constants.FestivalLabel.numberOfLines
    $0.textAlignment = .center
    $0.text = "축제명"
  }
  
  private let periodLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .semiBold, size: Constants.PeriodLabel.fontSize)
    $0.textColor = .yg.gray00Background
    $0.textAlignment = .center
    $0.text = "날짜"
    // shadowTODO: - shadow, blur 처리
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailImageView.image = nil
    heartButton.isSelected = false
    periodLabel.text = nil
    festivalLabel.text = nil
    subscriptions.removeAll()
  }
}

// MARK: - Actions
extension SearchBestFestivalCell {
  @objc private func didTapHeartButton() {
    input.didTapHeartButton.send()
  }
}

// MARK: - ViewBindCase
extension SearchBestFestivalCell: ViewBindCase {
  typealias Input = SearchBestFestivalCellViewModel.Input
  typealias ErrorType = SearchBestFestivalCellViewModel.ErrorType
  typealias State = SearchBestFestivalCellViewModel.State
  
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
      heartButton.isSelected.toggle()
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

// MARK: - Helpers
extension SearchBestFestivalCell {
  private func setupStyles() {
    contentView.backgroundColor = .systemBlue
  }
}

// MARK: - Configure
extension SearchBestFestivalCell {
  func configure(viewModel: SearchBestFestivalCellViewModel) {
    self.viewModel = viewModel
    
    festivalLabel.text = viewModel.title
    periodLabel.text = viewModel.periodString
    heartButton.isSelected = viewModel.isSelectedButton
    // imageTODO: - 이미지 적용
    thumbnailImageView.image = UIImage(named: viewModel.thumbnailImage ?? "tempThumbnail7")
  }
}

// MARK: - LayoutSupport
extension SearchBestFestivalCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
    thumbnailImageView.addSubview(heartButton)
    thumbnailImageView.addSubview(festivalLabel)
    thumbnailImageView.addSubview(periodLabel)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    heartButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constants.HeartButton.Inset.top)
      $0.trailing.equalToSuperview().inset(Constants.HeartButton.Inset.trailing)
      $0.size.equalTo(Constants.HeartButton.size)
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

//
//  FavoriteDetailCategoryAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit
import Combine

final class FavoriteDetailCategoryAreaView: UIView {
  enum Constant {
    enum CategoryStackView {
      static let height: CGFloat = 40
      static let interItemSpacing: CGFloat = 8
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 16
        static let trailing = leading
      }
    }
        
    enum TotalItemStateLabel {
      static let textColor: UIColor = .YG.gray3
      static let textSize: CGFloat = 13
      static let textWeight: CGFloat = 500
      enum Spacing {
        static let top: CGFloat = 16
        static let leaidng: CGFloat = 20
        static let trailing = leaidng
      }
    }
  }
  
  enum CategoryState: String {
    case travelReview = "글"
    case travelLocation = "장소"
    
    func convertTotalItemTextFormat(with totalItem: Int) -> String {
      return "찜한 " + self.rawValue + " " + totalItem.zeroPaddingString + "개"
    }
  }
  
  // MARK: - Properties
  private lazy var categoryStackView = UIStackView(arrangedSubviews: [travelReviewLabel, travelLocationLabel]).set {
    typealias Const = Constant.CategoryStackView
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = Const.interItemSpacing
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  private let travelReviewLabel = PrimaryColorToneRoundLabel(currentState: .selected).set {
    $0.text = "여행 리뷰"
  }
  
  private let travelLocationLabel = PrimaryColorToneRoundLabel().set {
    $0.text = "장소"
  }
  
  private lazy var totalItemStateLabel: UILabel = UILabel(frame: .zero).set {
    typealias Const = Constant.TotalItemStateLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.textAlignment = .left
    $0.textColor = Const.textColor
    
    $0.font = UIFont.systemFont(ofSize: Const.textSize, weight: .init(Const.textWeight))
    // $0.font = UIFont(pretendard: .medium, size: 13)
    print("마마마", $0.font.fontName)
    $0.text = "찜한 글 " + totalItemCount.zeroPaddingString + "개"
    $0.sizeToFit()
  }
  
  var travelReviewTapHandler: (() -> Int)?
  
  var travelLocationTapHandler: (() -> Int)?
  
  // TODO: - 이건 트래벌 리뷰 눌르면 그때 하위 뷰컨에서 얼마나 컨텐츠 보유중인지 확인 후 다시 여기에 새로 갱신해야할거같음.
  @Published private var totalItemCount: Int = 0
  
  @Published private var categoryState: CategoryState = .travelReview
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    bind()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    bind()
  }
}

// MARK: - Helpers
extension FavoriteDetailCategoryAreaView {
  func plusStoredPost() {
    totalItemCount += 1
  }
  
  func minusStoredPost() -> Bool {
    if totalItemCount == 0 {
      return false
    }
    totalItemCount -= 1
    return true
  }
}

// MARK: - Private Helpers
extension FavoriteDetailCategoryAreaView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  private func bind() {
    $categoryState
      .sink { [weak self] in
        if $0 == .travelReview {
          self?.travelReviewLabel.isUserInteractionEnabled = false
          self?.travelLocationLabel.isUserInteractionEnabled = true
        } else {
          self?.travelLocationLabel.isUserInteractionEnabled = false
          self?.travelReviewLabel.isUserInteractionEnabled = true
        }
      }.store(in: &subscriptions)
    
    $totalItemCount
      .sink { [weak self] in
        guard $0 >= 0 else { return }
        self?.totalItemStateLabel.text = self?.categoryState.convertTotalItemTextFormat(with: $0)
      }.store(in: &subscriptions)
    
    travelReviewLabel.tapHandler = { [weak self] in
      if self?.categoryState == .travelLocation {
        self?.categoryState = .travelReview
        self?.travelLocationLabel.toggleCurrentState()
        self?.totalItemCount = self?.travelReviewTapHandler?() ?? 0
      }
    }
    
    travelLocationLabel.tapHandler = { [weak self] in
      if self?.categoryState == .travelReview {
        self?.categoryState = .travelLocation
        self?.travelReviewLabel.toggleCurrentState()
        self?.totalItemCount = self?.travelLocationTapHandler?() ?? 0
      }
    }
  }
}

// MARK: - LayoutSupport
extension FavoriteDetailCategoryAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      categoryStackView,
      totalItemStateLabel
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      categoryStackViewConstraints,
      totalItemStateLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension FavoriteDetailCategoryAreaView {
  var categoryStackViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CategoryStackView
    typealias Spacing = Const.Spacing
    return [
      categoryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      categoryStackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      categoryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      categoryStackView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var totalItemStateLabelConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TotalItemStateLabel
    typealias Spacing = Const.Spacing
    return [
      totalItemStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leaidng),
      totalItemStateLabel.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: Spacing.top),
      totalItemStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing)]
  }
}

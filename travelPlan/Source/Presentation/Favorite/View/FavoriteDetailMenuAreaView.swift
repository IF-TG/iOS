//
//  FavoriteDetailMenuAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit
import Combine

final class FavoriteDetailMenuAreaView: UIView {
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
    enum Shadow {
      static let radius: CGFloat = 10.0
      static let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
      static let offset = CGSize(width: 0, height: 1)
    }
  }
  enum MenuState: String {
    case travelReview = "글"
    case travelLocation = "장소"
    func convertTotalItemTextFormat(with totalItem: Int) -> String {
      return "찜한 " + self.rawValue + " " + totalItem.zeroPaddingString + "개"
    }
  }
  
  // MARK: - Properties
  private lazy var menuStackView = UIStackView(arrangedSubviews: [travelReviewLabel, travelLocationLabel]).set {
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
    // TODO: - 기본 폰트가 아니라 다 pretendard 폰트로 변경해야합니다.
    $0.font = UIFont.systemFont(ofSize: Const.textSize, weight: .init(Const.textWeight))
    $0.text = "찜한 글 " + totalItemCount.zeroPaddingString + "개"
    $0.sizeToFit()
  }
  
  private var isSetShadow = false
  
  override var bounds: CGRect {
    didSet {
      if !isSetShadow {
        isSetShadow.toggle()
        configureShadow()
      }
    }
  }
  
  var travelReviewTapHandler: (() -> Int)?
  
  var travelLocationTapHandler: (() -> Int)?
  
  @Published private var totalItemCount: Int
  
  @Published private var categoryState: MenuState = .travelReview
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(frame: CGRect, totalItemCount: Int) {
    self.totalItemCount = totalItemCount
    super.init(frame: frame)
    configureUI()
    bind()
  }
  
  convenience init(totalItemCount: Int) {
    self.init(frame: .zero, totalItemCount: totalItemCount)
  }
  
  required init?(coder: NSCoder) {
    self.totalItemCount = 0
    super.init(coder: coder)
    configureUI()
    bind()
  }
}

// MARK: - Helpers
extension FavoriteDetailMenuAreaView {
  func updateTotalItemCount(_ count: Int) {
    totalItemCount = count
  }
}

// MARK: - Private Helpers
extension FavoriteDetailMenuAreaView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
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
  
  func configureShadow() {
    layer.shadowColor = Constant.Shadow.color
    layer.shadowRadius = Constant.Shadow.radius
    layer.shadowOffset = Constant.Shadow.offset
    layer.shadowOpacity = 1
    let shadowRect = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y,
      width: bounds.width,
      height: bounds.height + 1)
    let shadowPath = UIBezierPath(rect: shadowRect).cgPath
    layer.shadowPath = shadowPath
  }
}

// MARK: - LayoutSupport
extension FavoriteDetailMenuAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      menuStackView,
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
private extension FavoriteDetailMenuAreaView {
  var categoryStackViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CategoryStackView
    typealias Spacing = Const.Spacing
    return [
      menuStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      menuStackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      menuStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      menuStackView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var totalItemStateLabelConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TotalItemStateLabel
    typealias Spacing = Const.Spacing
    return [
      totalItemStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leaidng),
      totalItemStateLabel.topAnchor.constraint(equalTo: menuStackView.bottomAnchor, constant: Spacing.top),
      totalItemStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing)]
  }
}

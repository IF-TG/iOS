//
//  BasePlanCategorySelectionViewController.swift
//  travelPlan
//
//  Created by 양승현 on 6/26/24.
//

import UIKit
import Combine

@frozen enum PlanCategorySelectionType {
  /// 첫 선택
  case start
  
  /// 첫, 끝을 제외한 선택
  case middle
  
  /// 마지막 선택
  case end
}

public class BasePlanCategorySelectionViewController: UIViewController {
  // MARK: - UI Properties
  private let progressBar = ProgressView(
    progressTotalSteps: 3,
    progressTintColor: .yg.highlight,
    progressBackgroundColor: .yg.gray0)
  
  private let titleLabel = BaseLabel(
    fontType: .semiBold_600(fontSize: 18)
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.text = "카테고리를 선정해주세요."
  }
  
  /// 외부에서 구체적인 타입을 주입해야합니다.
  private let contentViewForCateogry: UIView
  
  private lazy var selectionDescriptionLabel = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 16.67, height: 16.67), iconPath: "circle_exclamation_icon"),
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: nil)
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setCountLabel(text: "다양한 선택을 할 수 있어요.")
  }
  
  private lazy var prevButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let nextButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  lazy var descriptionLabelForMakingAPlan = BaseLabel(fontType: .medium_500(fontSize: 12)).set {
    $0.alpha = 0
  }
  
  // MARK: - Properties
  @Published internal var hasSelected: Bool = false
  
  private let selectionType: PlanCategorySelectionType
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(contentViewForCateogry: UIView, selectionType: PlanCategorySelectionType) {
    self.contentViewForCateogry = contentViewForCateogry
    self.selectionType = selectionType
    super.init(nibName: nil, bundle: nil)
    configureTransitionButton()
    setupUI()
    bind()
  }
  
  /// 사용 안함!!!
  required public init?(coder: NSCoder) { nil }
}

// MARK: - Public Helpers
public extension BasePlanCategorySelectionViewController {
  func setTitleLabel(_ text: String, withHighlighted highlightedText: String) {
    titleLabel.text = text
    let highlightFontInfo = HighlightFontInfo(
      fontType: .semiBold_600(fontSize: 18),
      text: highlightedText,
      additionalAttributes: [.foregroundColor: UIColor.yg.primary.cgColor])
    titleLabel.setHighlight(with: highlightFontInfo)
  }
  
  func increaseProgress() {
    progressBar.increase()
  }
  
  func decreaseProgress() {
    progressBar.decrease()
  }
}

// MARK: - Private Helpers
private extension BasePlanCategorySelectionViewController {
  func configureTransitionButton() {
    switch selectionType {
    case .start:
      nextButton.setImage(UIImage(named: "chevron-right-icon"), for: .normal)
    case .middle:
      nextButton.setImage(UIImage(named: "chevron-right-icon"), for: .normal)
      prevButton.setImage(UIImage(named: "chevron-left-icon"), for: .normal)
      layoutPrevButton()
    case .end:
      prevButton.setImage(UIImage(named: "chevron-left-icon"), for: .normal)
      nextButton.setImage(UIImage(named: "arrow-narrow-right-icon"), for: .normal)
      layoutPrevButton()
      layoutDescriptionLabelForMakingAPlan()
    }
  }
  
  func animateForTransitionButton(_ animations: @escaping () -> Void) {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      animations()
    }
  }
  
  // MARK: - Transition Buttons
  func activeNextButton() {
    animateForTransitionButton {
      self.nextButton.alpha = 1
    }
    if selectionType == .end {
      animateForTransitionButton {
        self.descriptionLabelForMakingAPlan.alpha = 1.0
      }
    }
  }
  
  func deactiveNextButton() {
    animateForTransitionButton { self.nextButton.alpha = 0.3 }
    if selectionType == .end {
      animateForTransitionButton {
        self.descriptionLabelForMakingAPlan.alpha = 0.3
      }
    }
  }
  
  // MARK: - Layout for lazy UI component
  func layoutDescriptionLabelForMakingAPlan() {
    view.addSubview(descriptionLabelForMakingAPlan)
    NSLayoutConstraint.activate([
      descriptionLabelForMakingAPlan.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 7),
      descriptionLabelForMakingAPlan.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor)])
  }
  
  func layoutPrevButton() {
    view.addSubview(prevButton)
    NSLayoutConstraint.activate([
      prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      prevButton.widthAnchor.constraint(equalToConstant: 35),
      prevButton.heightAnchor.constraint(equalToConstant: 35)])
  }
  
  func bind() {
    $hasSelected
      .receive(on: RunLoop.current)
      .sink { [weak self] state in
        if state {
          self?.activeNextButton()
        } else {
          self?.deactiveNextButton()
        }
      }.store(in: &subscriptions)
  }
}

// MARK: - LayoutSupport
extension BasePlanCategorySelectionViewController: LayoutSupport {
  func addSubviews() {
    [
      progressBar,
      titleLabel,
      contentViewForCateogry,
      selectionDescriptionLabel,
      nextButton
    ].forEach(view.addSubview)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      progressBar.heightAnchor.constraint(equalToConstant: 3),
    
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      titleLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 20+77),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
      
      contentViewForCateogry.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentViewForCateogry.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      contentViewForCateogry.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentViewForCateogry.bottomAnchor.constraint(
        lessThanOrEqualTo: selectionDescriptionLabel.topAnchor, constant: -10),
      
      selectionDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      selectionDescriptionLabel.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -78),
      
      nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -27.5),
      nextButton.widthAnchor.constraint(equalToConstant: 35),
      nextButton.heightAnchor.constraint(equalToConstant: 35)
    ])
  }
}

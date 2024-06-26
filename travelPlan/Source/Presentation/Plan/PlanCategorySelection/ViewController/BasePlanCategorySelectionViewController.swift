//
//  BasePlanCategorySelectionViewController.swift
//  travelPlan
//
//  Created by 양승현 on 6/26/24.
//

import UIKit

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
  private let cateogryView: UIView
  
  private let selectionDescriptionLabel = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 16.67, height: 16.67), iconPath: "circle_exclamation_icon"),
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: nil))
  
  private lazy var prevButton = UIButton(frame: .zero)
  
  private let nextButton = UIButton(frame: .zero)
  
  lazy var descriptionLabelForMakingAPlan = BaseLabel(fontType: .medium_500(fontSize: 12)).set {
    $0.alpha = 0
  }
  
  // MARK: - Properties
  private let hasSelected: Bool = false
  
  private let selectionType: PlanCategorySelectionType
  
  init(cateogryView: UIView, selectionType: PlanCategorySelectionType) {
    self.cateogryView = cateogryView
    self.selectionType = selectionType
    super.init(nibName: nil, bundle: nil)
    configureTransitionButton()
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
    case .end:
      prevButton.setImage(UIImage(named: "chevron-left-icon"), for: .normal)
      nextButton.setImage(UIImage(named: "arrow-narrow-right-icon"), for: .normal)
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
  
  func activePrevButton() {
    animateForTransitionButton {
      self.prevButton.alpha = 1
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
  
  func deactivePrevButton() {
    if selectionType == .start { return }
    animateForTransitionButton {
      self.prevButton.alpha = 0.3
    }
  }
}

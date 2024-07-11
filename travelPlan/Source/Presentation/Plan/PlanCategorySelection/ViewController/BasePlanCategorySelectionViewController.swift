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
    $0.setLabelColor(.yg.gray0)
  }
  
  private let prevButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(UIImage(named: "chevron-left-icon"), for: .normal)
  }
  
  private let nextButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isUserInteractionEnabled = false
  }
  
  lazy var descriptionLabelForMakingAPlan = BaseLabel(fontType: .medium_500(fontSize: 12)).set {
    $0.alpha = 0.3
    $0.text = "플랜 세우기"
    $0.textColor = .yg.primary
  }
  
  // MARK: - Properties
  /// 하위 객체 및 외부 객체에서는 이 값 변경시  next 버튼이 활성화 or 비활성화 됩니다.
  @Published internal var hasSelected: Bool = false
  
  var nextButtonTapPublisher: AnyPublisher<Void, Never> {
    nextButton
      .tap
      .filter { [weak self] _ in self?.hasSelected == true }
      .map { [weak self] _ in
        self?.increaseProgress()
        self?.hasSelected = false
        self?.setNextSelection()
      }.eraseToAnyPublisher()
  }
  
  var prevButtonTapPublisher: AnyPublisher<Void, Never> {
    prevButton
      .tap
      .map { [weak self] _ in
        self?.decreaseProgress()
        self?.hasSelected = true
        self?.setPrevSelection()
      }.eraseToAnyPublisher()
  }
  
  private(set) var selectionType: PlanCategorySelectionType {
    didSet {
      configureTransitionButton()
    }
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(contentViewForCateogry: UIView, selectionType: PlanCategorySelectionType) {
    self.contentViewForCateogry = contentViewForCateogry
    self.selectionType = selectionType
    super.init(nibName: nil, bundle: nil)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureTransitionButton()
    bind()
    view.backgroundColor = .white
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
}

// MARK: - Private Helpers
private extension BasePlanCategorySelectionViewController {
  func configureTransitionButton() {
    switch selectionType {
    case .start:
      animateForTransitionButton {
        self.prevButton.alpha = 0
        self.descriptionLabelForMakingAPlan.alpha = 0
        self.nextButton.setImage(UIImage(named: "chevron-right-icon"), for: .normal)
        self.setTitleLabel("어느 지역으로 떠나시나요?", withHighlighted: "지역")
      }
    case .middle:
      animateForTransitionButton {
        self.prevButton.alpha = 1
        self.nextButton.setImage(UIImage(named: "chevron-right-icon"), for: .normal)
        self.descriptionLabelForMakingAPlan.alpha = 0
        self.setTitleLabel("함께하는 동반자가 있으신가요?", withHighlighted: "동반자")
      }
    case .end:
      animateForTransitionButton {
        self.prevButton.alpha = 1
        self.nextButton.setImage(UIImage(named: "arrow-narrow-right-icon"), for: .normal)
        self.descriptionLabelForMakingAPlan.alpha = 30
        self.setTitleLabel("이번 여행의 테마는 무엇인가요?", withHighlighted: "테마")
      }
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
    nextButton.isUserInteractionEnabled = true
    if selectionType == .end {
      animateForTransitionButton {
        self.descriptionLabelForMakingAPlan.alpha = 1.0
      }
    }
  }
  
  func deactiveNextButton() {
    animateForTransitionButton { self.nextButton.alpha = 0.3 }
    nextButton.isUserInteractionEnabled = false
    if selectionType == .end {
      animateForTransitionButton {
        self.descriptionLabelForMakingAPlan.alpha = 0.3
      }
    }
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
  
  func increaseProgress() {
    progressBar.increase()
  }
  
  func decreaseProgress() {
    progressBar.decrease()
  }
  
  func setNextSelection() {
    if selectionType == .start {
      selectionType = .middle
    } else if selectionType == .middle {
      selectionType = .end
    }
  }
  
  func setPrevSelection() {
    if selectionType == .end {
      selectionType = .middle
    } else if selectionType == .middle {
      selectionType = .start
    }
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
      nextButton,
      prevButton,
      descriptionLabelForMakingAPlan
    ].forEach { view.addSubview($0) }
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
      contentViewForCateogry.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
      
      selectionDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      selectionDescriptionLabel.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -78),
      selectionDescriptionLabel.heightAnchor.constraint(equalToConstant: 25),
      
      prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      prevButton.widthAnchor.constraint(equalToConstant: 35),
      prevButton.heightAnchor.constraint(equalToConstant: 35),
      
      nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -27.5),
      nextButton.widthAnchor.constraint(equalToConstant: 35),
      nextButton.heightAnchor.constraint(equalToConstant: 35),
      
      descriptionLabelForMakingAPlan.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 7),
      descriptionLabelForMakingAPlan.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor)
    ])
  }
}

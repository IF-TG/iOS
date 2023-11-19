//
//  ReviewWritingViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/3/23.
//

import UIKit
import SnapKit
import Combine

final class ReviewWritingViewController: UIViewController {
  enum KeyboardState {
    case willShow
    case willHide
  }
  
  // MARK: - Properties
  weak var coordinator: ReviewWritingCoordinatorDelegate?
  
  private lazy var titleView = NavigationTitleWithClickView(title: "테마 설정", layoutType: .rightImage).set {
    self.addGestureRecognizer(from: $0, action: #selector(didTapTitleView))
  }
  
  private let keyboardImage: UIImage = .init(named: "keyboard") ?? .init(systemName: "keyboard")!
  
  private lazy var leftButton = UIButton().set {
    $0.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.yg.gray7, for: .normal)
    $0.setTitleColor(.yg.gray7.withAlphaComponent(0.1), for: .highlighted)
    $0.titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
  
  private lazy var finishButton = UIButton().set {
    $0.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.yg.primary, for: .normal)
    $0.titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
  
  private lazy var scrollView = UIScrollView().set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    $0.addGestureRecognizer(tapGesture)
    $0.alwaysBounceVertical = true
  }
  private lazy var contentView = ReviewWritingContentView().set {
    $0.delegate = self
  }
  private lazy var bottomView = ReviewWritingBottomView().set {
    $0.delegate = self
  }
  private var subscriptions = Set<AnyCancellable>()
  private var scrollViewBottomConstraint: ConstraintMakerEditable?
  private let viewModel = ReviewWritingViewModel()
  private let input = ReviewWritingViewModel.Input()
  private var isViewDidAppearFirstCalled = false
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bindNotificationCenter()
    addGestureRecognizer(from: self.view, action:  #selector(dismissKeyboard))
    setContentViewClosures()
    
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
    (tabBarController as? MainTabBarController)?.hideShadowLayer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isViewDidAppearFirstCalled {
      contentView.bottomViewHeight(bottomView.frame.height)
      contentView.scrollViewHeight(scrollView.frame.height)
      isViewDidAppearFirstCalled = true
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
    (tabBarController as? MainTabBarController)?.showShadowLayer()
  }
  
  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    contentView.safeAreaTopInset(topInset: view.safeAreaInsets.top)
  }
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - ViewBindCase
extension ReviewWritingViewController: ViewBindCase {
  typealias Input = ReviewWritingViewModel.Input
  typealias ErrorType = Error
  typealias State = ReviewWritingViewModel.State
  
  func bind() {
    viewModel
      .transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        self?.render(state)
      }
      .store(in: &subscriptions)
  }
  
  func render(_ state: State) {
    switch state {
    case .popViewController:
      coordinator?.finish(withAnimated: true)
    case .presentAlbumViewController:
      contentView.addImageView()
    case .presentPlan:
      print("플랜화면 띄우기")
    case .keyboardDown:
      view.endEditing(true)
    case .manageTextViewDisplay:
      contentView.manageTextViewDisplay()
    case .presentThemeSetting:
      print("테마 설정 화면 띄우기")
    }
  }
  
  func handleError(_ error: ErrorType) { }
}

// MARK: - Private Helpers
extension ReviewWritingViewController {
  private func addGestureRecognizer(from view: UIView, action: Selector?) {
    let tapGesture = UITapGestureRecognizer(target: self, action: action)
    view.addGestureRecognizer(tapGesture)
  }
  
  private func bindNotificationCenter() {
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.changeLeftButtonUI(currentState: .willShow)
      }
      .store(in: &subscriptions)
    
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillHideNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.setScrollViewBottomInset(inset: .zero)
        self?.changeLeftButtonUI(currentState: .willHide)
      }
      .store(in: &subscriptions)
  }
  
  private func changeLeftButtonUI(currentState: KeyboardState) {
    switch currentState {
    case .willShow:
      leftButton.setImage(keyboardImage, for: .normal)
      leftButton.setTitle(nil, for: .normal)
    case .willHide:
      leftButton.setImage(nil, for: .normal)
      leftButton.setTitle("취소", for: .normal)
    }
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = .init(customView: leftButton)
    navigationItem.rightBarButtonItem = .init(customView: finishButton)
    navigationItem.titleView = titleView
  }
  
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func setContentViewClosures() {
    contentView.scrollToLastView = { [weak self] cursorHeight, lastView in
      guard let scrollView = self?.scrollView else { return }
      let frameHeightIsSmallerThanContentHeight = scrollView.contentSize.height > scrollView.bounds.height
      guard frameHeightIsSmallerThanContentHeight else { return }
      
      if lastView is UITextView {
        scrollView.setContentOffset(
          CGPoint(x: .zero, y: scrollView.contentOffset.y + cursorHeight),
          animated: true
        )
      } else if lastView is UIImageView {
        scrollView.setContentOffset(
          CGPoint(x: .zero, y: scrollView.contentSize.height - scrollView.bounds.height),
          animated: true
        )
      }
    }
  }
  
  private func setScrollViewBottomInset(inset: CGFloat) {
    scrollView.verticalScrollIndicatorInsets.bottom = inset
    scrollView.contentInset.bottom = inset
  }
}

// MARK: - LayoutSupport
extension ReviewWritingViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    view.addSubview(bottomView)
  }
  
  func setConstraints() {
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalToSuperview().multipliedBy(0.73)
      scrollViewBottomConstraint = $0.bottom.equalTo(bottomView.snp.top)
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    bottomView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

// MARK: - Actions
private extension ReviewWritingViewController {
  @objc func didTapLeftButton() {
    let keyboardIsOnScreen = leftButton.image(for: .normal) != nil
    
    if keyboardIsOnScreen {
      input.didTapKeyboardDownButton.send()
    } else {
      input.didTapCancelButton.send()
    }
  }
  
  @objc func didTapFinishButton() {
    input.didTapFinishButton.send()
  }
  
  @objc func didTapTitleView() {
    input.didTapNavigationTitleView.send()
  }
  
  @objc func didTapScrollView() {
    print("didTapScrollView")
    input.didTapScrollView.send()
  }
  
  @objc func dismissKeyboard() {
    input.didTapView.send()
  }
}

// MARK: - DefaultTapGestureDelegate
extension ReviewWritingViewController: ReviewWritingBottomViewDelegate {
  func didTapPlanView(_ view: UIView) {
    input.didTapPlanView.send()
  }
  
  func didTapCameraButton(_ button: UIButton) {
    input.didTapAlbumButton.send()
  }
}

// MARK: - ReviewWritingContentDelegate
extension ReviewWritingViewController: ReviewWritingContentViewDelegate {
  func changeContentInset(bottomEdge: CGFloat) {
    setScrollViewBottomInset(inset: bottomEdge)
  }
}

extension ReviewWritingViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view !== scrollView {
      return false
    }
    return true
  }
}

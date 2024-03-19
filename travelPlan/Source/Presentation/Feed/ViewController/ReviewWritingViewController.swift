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
  
  private lazy var cancelButton = BaseNavigationLeftButton().set {
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  private lazy var finishButton = BaseNavigationRightButton().set {
    $0.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
  }
  
  private lazy var scrollView = UIScrollView().set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
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
  private let viewModel = ReviewWritingViewModel()
  private let input = ReviewWritingViewModel.Input()
  private var isViewDidAppearFirstCalled = false
  private weak var imageView: UIImageView?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bindNotificationCenter()
    addGestureRecognizer(from: self.view, action: #selector(didTapView))
    setContentViewClosures()
    
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
    (tabBarController as? MainTabBarController)?.hideShadowLayer()
    finishButton.isEnabled = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isViewDidAppearFirstCalled {
      contentView.bottomViewHeight(bottomView.frame.height)
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
      coordinator?.showPhotoViewController()
    case .presentPlan:
      print("플랜화면 띄우기")
    case .keyboardDown:
      view.endEditing(true)
    case .manageTextViewDisplay:
      contentView.manageContentOffsetYByLastView()
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
      cancelButton.setImage(keyboardImage, for: .normal)
      cancelButton.setTitle(nil, for: .normal)
    case .willHide:
      cancelButton.setImage(nil, for: .normal)
      cancelButton.setTitle("취소", for: .normal)
    }
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = .init(customView: cancelButton)
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
      
      if lastView is UITextView, let cursorHeight = cursorHeight {
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
    
    contentView.imageViewUpdated = { [weak self] newImageView in
      print("imageView tapped")
      self?.imageView = newImageView
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
      $0.bottom.equalTo(bottomView.snp.top)
    }
    
    contentView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(scrollView.contentLayoutGuide)
      $0.bottom.equalToSuperview().inset(80)
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
  @objc func didTapCancelButton() {
    let keyboardIsOnScreen = cancelButton.image(for: .normal) != nil
    
    if keyboardIsOnScreen {
      input.didTapKeyboardDownButton.send()
    } else {
      input.didTapCancelButton.send()
    }
  }
  
  @objc func didTapFinishButton() {
    let contentData = contentView.extractContentData()
    input.didTapFinishButton.send(contentData)
  }
  
  @objc func didTapTitleView() {
    input.didTapNavigationTitleView.send()
  }
  
  @objc func didTapScrollView() {
    input.didTapScrollView.send()
  }
  
  @objc func didTapView() {
    input.didTapView.send()
  }
}
// MARK: - Helpers
extension ReviewWritingViewController {
  func setImageView(to images: [UIImage]) {
    for image in images {
      contentView.addImageView(image: image)
    }
  }
}

// MARK: - ReviewWritingBottomViewDelegate
extension ReviewWritingViewController: ReviewWritingBottomViewDelegate {
  func didTapPlanView(_ view: UIView) {
    input.didTapPlanView.send()
  }
  
  func didTapCameraButton(_ button: UIButton) {
//    if contentView.firstMessageTextViewTextIsPlaceholder {
//      contentView.hideMessageTextView()
//    }
    input.didTapAlbumButton.send()
  }
}

// MARK: - ReviewWritingContentViewDelegate
extension ReviewWritingViewController: ReviewWritingContentViewDelegate {
  func changeContentInset(bottomEdge: CGFloat) {
    setScrollViewBottomInset(inset: bottomEdge)
  }
  
  func handleFinishButtonTitleColor(isEnabled: Bool) {
    finishButton.isEnabled = isEnabled
    if isEnabled {
      finishButton.setTitleColor(.yg.primary, for: .normal)
    } else {
      finishButton.setTitleColor(.yg.gray1, for: .normal)
    }
  }
}

// MARK: - UIGestureRecognizerDelegate
extension ReviewWritingViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldReceive touch: UITouch
  ) -> Bool {
    if touch.view === self.imageView, gestureRecognizer.view === scrollView {
      return false
    }
    return true
  }
}

//
//  ReviewWritingViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/3/23.
//

import UIKit
import SnapKit
import Combine
import Photos

final class ReviewWritingViewController: UIViewController {
  // MARK: - Nested  
  enum Constant {
    enum ScrollView {
      static let leading: CGFloat = 15
      static let trailing: CGFloat = 15
    }
  }
  
  // MARK: - Properties
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
  private let viewModel: any ReviewWritingViewModel
  private let photoService: any PhotoService
  private var isViewDidAppearFirstCalled = false
  private weak var imageView: UIImageView?
  private let input = ReviewWritingViewModelInput()
  
  // MARK: - LifeCycle
  init(viewModel: any ReviewWritingViewModel, photoService: any PhotoService) {
    self.viewModel = viewModel
    self.photoService = photoService
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    defer {
      bind()
      input.viewDidLoad.send()
    }
    setupUI()
    setupStyles()
    setupNavigationBar()
    bindNotificationCenter()
    addGestureRecognizer(from: self.view, action: #selector(didTapView))
    setContentViewClosures()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTabBarVisibility(false)
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
    updateTabBarVisibility(true)
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
extension ReviewWritingViewController {
  func bind() {
    viewModel
      .transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .configureImage(let sortedDatas):
          for data in sortedDatas {
            self?.contentView.addImageView(imageData: data, shouldScrollToLastView: true)
          }
        case .none:
          break
        case .manageTextViewDisplay:
          self?.contentView.manageContentOffsetYByLastView()
          break
        case let .setupContents(title, postContents):
          self?.contentView.setupContents(.init(title: title, contents: postContents))
        case .unexpectedError(description: let description):
          print("에러가 발생했습니다. error: \(description)")
        case .savedReviewWritingSuccessfully:
          self?.viewModel.pop()
        case .savedReviewWritingEditSuccessfully(post: let post):
          self?.viewModel.pop(with: post)
        }
      }
      .store(in: &subscriptions)
  }
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
      $0.leading.trailing.equalToSuperview().inset(Constant.ScrollView.leading)
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
    keyboardIsOnScreen ? _=view.endEditing(true) : viewModel.pop()
  }
  
  @objc func didTapFinishButton() {
    let contentViewInfo = contentView.extractContentData()
    input.didTapFinishButton.send((contentViewInfo.contents, contentViewInfo.title))
  }
  
  @objc func didTapTitleView() {
    viewModel.showCategoryBottomSheet()
  }
  
  @objc func didTapScrollView() {
    input.didTapScrollView.send()
  }
  
  @objc func didTapView() {
    view.endEditing(true)
  }
}

// MARK: - ReviewWritingBottomViewDelegate
extension ReviewWritingViewController: ReviewWritingBottomViewDelegate {
  func didTapPlanView(_ view: UIView) {
    viewModel.presentPlan()
  }
  
  func didTapAlbumButton(_ button: UIButton) {
    viewModel.didTapAlbumButton()
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

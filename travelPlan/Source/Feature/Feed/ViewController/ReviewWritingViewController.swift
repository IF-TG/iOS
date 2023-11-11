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
  // MARK: - Properties
  weak var coordinator: ReviewWritingCoordinatorDelegate?
  
  private lazy var titleView = NavigationTitleWithClickView(title: "테마 설정", layoutType: .rightImage).set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTitleView))
    $0.addGestureRecognizer(tapGesture)
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
    $0.addGestureRecognizer(tapGesture)
    $0.alwaysBounceVertical = true
  }
  private let contentView = ReviewWritingContentView()
  private lazy var bottomView = ReviewWritingBottomView().set {
    $0.delegate = self
  }
  private var subscriptions = Set<AnyCancellable>()
  private var scrollViewBottomConstraint: ConstraintMakerEditable?
  private let viewModel = ReviewWritingViewModel()
  private let input = ReviewWritingViewModel.Input()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bindNotificationCenter()
    addGestureRecognizer()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
    (tabBarController as? MainTabBarController)?.hideShadowLayer()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
    (tabBarController as? MainTabBarController)?.showShadowLayer()
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
  private func addGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
  }
  
  private func bindNotificationCenter() {
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] notification in
//        guard let bottomViewHeight = self?.bottomView.frame.height,
//              let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
//          .cgRectValue.height else { return }
//        
//        if self?.scrollView.contentOffset.y == 0 {
//          self?.scrollViewBottomConstraint?.constraint.update(inset: keyboardHeight - bottomViewHeight)
//        }
        
        // textView를 터치했을 때, 키보드가 올라오는데,
          // scrollView.contentOffset.y가 0이면 return
          // scrollView.
        // textView의 커서가 키보드보다 아래에 있는 경우, scrollVie
        
        
        // scrollView.contentOffset.y가 조정
          // 키보드가 떴을 때, 상수값 만큼 spacing
        
        self?.leftButton.setImage(self?.keyboardImage, for: .normal)
        self?.leftButton.setTitle(nil, for: .normal)
      }
      .store(in: &subscriptions)
    
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillHideNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.leftButton.setImage(nil, for: .normal)
        self?.leftButton.setTitle("취소", for: .normal)
      }
      .store(in: &subscriptions)
    
    contentView.scrollToLastView = { [weak self] in
      guard let scrollView = self?.scrollView else { return }
      let frameHeightIsSmallerThanContentHeight = scrollView.contentSize.height > scrollView.bounds.height
      
      if frameHeightIsSmallerThanContentHeight {
        scrollView.setContentOffset(
          CGPoint(x: .zero, y: scrollView.contentSize.height - scrollView.bounds.height),
          animated: true
        )
      }
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
    // TODO: - contentView에서 레이아웃이 잡혀있는 imageView의 개수를 bottomView에 띄우기
      // - 만약 imageView가 하나도 없다면, cameraWarningLabel의 textColor 변경하기
    input.didTapFinishButton.send()
  }
  
  @objc func didTapTitleView() {
    input.didTapNavigationTitleView.send()
  }
  
  @objc func didTapScrollView() {
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

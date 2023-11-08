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
  
  private lazy var titleView = TitleWithClickView(title: "테마 설정", layoutType: .rightImage).set {
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
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollViewFrameLayout))
    $0.addGestureRecognizer(tapGesture)
  }
  private let contentView = ReviewWritingContentView()
  private lazy var bottomView = ReviewWritingBottomView().set {
    $0.delegate = self
  }
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bind()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
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

// MARK: - Private Helpers
extension ReviewWritingViewController {
  private func bind() {
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
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
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    bottomView.snp.makeConstraints {
      $0.top.equalTo(scrollView.snp.bottom)
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
      view.endEditing(true)
    } else {
      coordinator?.finish(withAnimated: true)
    }
  }
  
  @objc func didTapFinishButton() {
    // TODO: - contentView에서 레이아웃이 잡혀있는 imageView의 개수를 bottomView에 띄우기
      // - 만약 imageView가 하나도 없다면, cameraWarningLabel의 textColor 변경하기
    print("완료버튼 클릭")
  }
  
  @objc func didTapTitleView() {
    print("타이틀뷰 클릭")
  }
  
  @objc func didTapScrollViewFrameLayout() {
    print("스크롤뷰 클릭!")
    contentView.manageTextViewDisplay()
  }
  
  @objc func dismissKeyboard() {
    print("뷰클릭")
    view.endEditing(true)
  }
}

// MARK: - DefaultTapGestureDelegate
extension ReviewWritingViewController: ReviewWritingBottomViewDelegate {
  func didTapPlanView(_ view: UIView) {
    print("플랜 불러오기 버튼 클릭!")
  }
  
  func didTapCameraButton(_ button: UIButton) {
    print("카메라 버튼 클릭!")
    contentView.addImageView()
  }
}

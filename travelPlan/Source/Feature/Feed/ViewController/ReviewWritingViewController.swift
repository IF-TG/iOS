//
//  ReviewWritingViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/3/23.
//

import UIKit
import SnapKit

final class ReviewWritingViewController: UIViewController {
  // MARK: - Properties
  weak var coordinator: ReviewWritingCoordinatorDelegate?
  
  private lazy var titleView = TitleWithClickView(title: "테마 설정", layoutType: .rightImage).set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTitleView))
    $0.addGestureRecognizer(tapGesture)
  }
  
  private lazy var cancelButton = UIButton().set {
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.yg.gray7, for: .normal)
    $0.setTitleColor(.yg.gray7.withAlphaComponent(0.1), for: .highlighted)
    $0.titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
  
  private lazy var finishButton = UIButton().set {
    $0.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.yg.gray1, for: .normal)
    $0.titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
  
  private lazy var scrollView = UIScrollView().set {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollViewFrameLayout))
    tapGesture.cancelsTouchesInView = false
    $0.addGestureRecognizer(tapGesture)
  }
  private let contentView = ReviewWritingContentView()
  private lazy var bottomView = ReviewWritingBottomView().set {
    $0.delegate = self
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
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
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = .init(customView: cancelButton)
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
  @objc func didTapCancelButton() {
    coordinator?.finish(withAnimated: true)
  }
  
  @objc func didTapFinishButton() {
    print("완료버튼 클릭")
  }
  
  @objc func didTapTitleView() {
    print("타이틀뷰 클릭")
  }
  
  @objc func didTapScrollViewFrameLayout() {
    print("스크롤뷰 클릭!")
    contentView.manageTextViewDisplay()
    // lastView가 textView인 경우, 해당 textView 포커싱
    // lastView가 imageView인 경우, imageView 밑에 새로운 textView를 제약조건을 통해 추가
  }
  
  @objc func dismissKeyboard() {
    print("뷰클릭")
    view.endEditing(true)
  }
}

// MARK: - DefaultTapGestureDelegate
extension ReviewWritingViewController: ReviewWritingBottomViewDelegate {
  func didTapPlanLoadingView(_ view: UIView) {
    print("플랜 불러오기 버튼 클릭!")
  }
  
  func didTapCameraButton(_ button: UIButton) {
    print("카메라 버튼 클릭!")
    contentView.addImageView()
  }
}

// 스크롤뷰가 눌렸을 때, contentView의 lastView가 이미지뷰이면 이미지뷰 아래에 textView 추가하고, lastView를 갱신
// contentView의 lastView가 textView라면 무시

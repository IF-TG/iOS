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
  
  private lazy var titleView = TitleWithClickView(title: "헬로", layoutType: .rightImage).set {
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
  
  private let reviewWritingView = ReviewWritingView()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
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
    view.addSubview(reviewWritingView)
  }
  
  func setConstraints() {
    reviewWritingView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(15)
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
}

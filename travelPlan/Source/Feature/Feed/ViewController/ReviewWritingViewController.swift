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
  private let titleView = TitleWithClickView(title: "헬로", layoutType: .rightImage)
  private let cancelButton = UIButton().set {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.yg.gray7, for: .normal)
    $0.setTitleColor(.yg.gray7.withAlphaComponent(0.1), for: .highlighted)
    $0.titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
  private let finishButton = UIButton().set {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.yg.gray1, for: .normal)
    $0.titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
  private let navigationBarDivider: UIView = .init().set {
    $0.backgroundColor = .yg.gray0
  }
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
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
  private func setNavigationBarEdgeGrayLine() {
    guard let naviBar = navigationController?.navigationBar else { return }
    naviBar.addSubview(navigationBarDivider)
      NSLayoutConstraint.activate([
        navigationBarDivider.leadingAnchor.constraint(equalTo: naviBar.leadingAnchor),
        navigationBarDivider.trailingAnchor.constraint(equalTo: naviBar.trailingAnchor),
        navigationBarDivider.heightAnchor.constraint(equalToConstant: 1),
        navigationBarDivider.bottomAnchor.constraint(equalTo: naviBar.bottomAnchor)])
  }
}

// MARK: - LayoutSupport
extension ReviewWritingViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(titleView)
  }
  
  func setConstraints() {
    titleView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

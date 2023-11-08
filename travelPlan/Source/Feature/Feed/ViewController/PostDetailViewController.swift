//
//  PostDetailViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .grouped).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 235
    $0.separatorInset = .zero
    $0.backgroundColor = .white
    $0.scrollIndicatorInsets = .init(top: 0, left: -1, bottom: 13, right: -1)
    if #available(iOS 15.0, *) {
      $0.sectionHeaderTopPadding = 0
    }
    
    $0.register(
      PostDetailCategoryHeaderView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCategoryHeaderView.id)
    $0.register(PostDetailTitleCell.self, forCellReuseIdentifier: PostDetailTitleCell.id)
    $0.register(
      PostDetailProfileAreaFooterView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailProfileAreaFooterView.id)
    
    $0.register(PostDetailContentTextCell.self, forCellReuseIdentifier: PostDetailContentTextCell.id)
    $0.register(PostDetailContentImageCell.self, forCellReuseIdentifier: PostDetailContentImageCell.id)
    $0.register(PostDetailContentFooterView.self, forHeaderFooterViewReuseIdentifier: PostDetailContentFooterView.id)
  }
  
  private let naviTitle = BaseLabel(fontType: .semiBold_600(fontSize: 16))
  
  private var naviTitleAnimator: UIViewPropertyAnimator?
  
  private var naviTItleOriginY: CGFloat = 0.0
  
  private var adapter: PostDetailTableViewAdapter?
  
  private let viewModel: PostDetailTableViewDataSource
  
  private var prevScrollDirection: UIScrollView.ScrollVerticalDirection = .down
  
  // MARK: - Lifecycle
  init(viewModel: PostDetailTableViewDataSource) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    adapter = PostDetailTableViewAdapter(
      dataSource: viewModel,
      delegate: self,
      tableView: tableView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let height = navigationController?.navigationBar.frame.size.height ?? 0
    naviTItleOriginY = (height - naviTitle.font.lineHeight)/2 - 2
    setTitleView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.topItem?.titleView = nil
  }
}

// MARK: - Private Helpers
private extension PostDetailViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupDefaultBackBarButtonItem(marginLeft: 0)
    setupUI()
  }
  
  func setTitleView() {
    guard let topItem = navigationController?.navigationBar.topItem else { return }
    if topItem.titleView == nil {
      topItem.titleView = naviTitle
      naviTitle.alpha = 0
    }
  }
}

// MARK: - PostDetailTableViewDelegate
extension PostDetailViewController: PostDetailTableViewAdapterDelegate {
  func willDisplayTitle() {
    guard let topItem = navigationController?.navigationBar.topItem else { return }
    naviTitleAnimator?.stopAnimation(true)
    naviTitleAnimator = UIViewPropertyAnimator(
      duration: 0.28,
      curve: .easeIn,
      animations: {
        topItem.titleView?.center.y += self.naviTitle.font.lineHeight
        topItem.titleView?.alpha = 0
      })
    naviTitleAnimator?.addCompletion { _ in
      topItem.titleView?.isHidden = true
    }
    naviTitleAnimator?.startAnimation()
                   
  }
  
  func disappearTitle(_ title: String) {
    guard let topItem = navigationController?.navigationBar.topItem else { 
      return
    }
    if naviTitle.text == nil {
      naviTitle.text = title
      topItem.titleView?.center.y += naviTitle.font.lineHeight
    }
    topItem.titleView?.isHidden = false
    naviTitleAnimator?.stopAnimation(true)
    naviTitleAnimator = UIViewPropertyAnimator(
      duration: 0.28,
      curve: .easeOut,
      animations: {
        topItem.titleView?.center.y = self.naviTItleOriginY
        topItem.titleView?.alpha = 1
      })
    naviTitleAnimator?.addCompletion { _ in
      topItem.titleView?.isHidden = false
    }
    naviTitleAnimator?.startAnimation()
  }
  
  func showUploadedUserProfilePage(with userId: Int) {
    print("업로드 유저 프로필 화면으로 이동!!")
  }
  
  func showCategoryDetailPage() {
    print("카데고리 상세 화면으로 이동!!!")
  }
}

extension PostDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(tableView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
  }
}

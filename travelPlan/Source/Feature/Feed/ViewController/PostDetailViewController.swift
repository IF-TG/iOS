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
    $0.contentInset = .zero
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
    $0.register(PostHeartAndShareAreaHeaderView.self, forHeaderFooterViewReuseIdentifier: PostHeartAndShareAreaHeaderView.id)
    
    $0.register(PostDetailCommentHeader.self, forHeaderFooterViewReuseIdentifier: PostDetailCommentHeader.id)
    $0.register(PostDetailReplyCell.self, forCellReuseIdentifier: PostDetailReplyCell.id)
  }
  
  private let commentInputView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yellow
  }
  
  private let naviTitle = BaseLabel(fontType: .semiBold_600(fontSize: 16))
  
  private var naviTitleAnimator: UIViewPropertyAnimator?
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    (self.tabBarController as? MainTabBarController)?.hideShadowLayer()
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setTitleView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.topItem?.titleView = nil
    (self.tabBarController as? MainTabBarController)?.showShadowLayer()
    self.tabBarController?.tabBar.isHidden = false
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
    navigationItem.titleView = naviTitle
    naviTitle.alpha = 0
  }
}

// MARK: - PostDetailTableViewDelegate
extension PostDetailViewController: PostDetailTableViewAdapterDelegate {
  func willDisplayTitle() {
    naviTitleAnimator?.stopAnimation(true)
    naviTitleAnimator = UIViewPropertyAnimator(
      duration: 0.28,
      curve: .easeIn,
      animations: {
        self.naviTitle.alpha = 0
        self.naviTitle.transform = .init(translationX: 0, y: self.naviTitle.font.lineHeight)
      })
    naviTitleAnimator?.addCompletion { _ in
      self.naviTitle.isHidden = true
    }
    naviTitleAnimator?.startAnimation()
                   
  }
  
  func disappearTitle(_ title: String) {
    if naviTitle.text == nil {
      naviTitle.text = title
      naviTitle.transform = .init(translationX: 0, y: naviTitle.font.lineHeight)
    }
    naviTitle.isHidden = false
    naviTitleAnimator?.stopAnimation(true)
    naviTitleAnimator = UIViewPropertyAnimator(
      duration: 0.28,
      curve: .easeOut,
      animations: {
        self.naviTitle.transform = .identity
        self.naviTitle.alpha = 1
      })
    naviTitleAnimator?.addCompletion { _ in
      self.naviTitle.isHidden = false
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
    [tableView, commentInputView].forEach {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      commentInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      commentInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      commentInputView.heightAnchor.constraint(equalToConstant: 60),
      commentInputView.topAnchor.constraint(equalTo: tableView.bottomAnchor)])
  }
}

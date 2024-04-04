//
//  PostDetailViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit
import Combine

final class PostDetailViewController: UITableViewController {
  // MARK: - Properties
  private let inputAccessory = PostDetailInputAccessoryWrapper()
  
  private let naviTitle = BaseLabel(fontType: .semiBold_600(fontSize: 16))
  
  private let starButton = SearchStarButton(normalType: .black)
  
  private var naviTitleAnimator: UIViewPropertyAnimator?
  
  private var isHandlingKeyboardEvent = false
  
  private var adapter: PostDetailTableViewAdapter?
  
  private let viewModel: any PostDetailViewModelable & PostDetailTableViewDataSource
  
  private var notificationSubscriptions = Set<AnyCancellable>()
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  override var inputAccessoryView: UIView? {
    return inputAccessory
  }
  
  private let input = PostDetailViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()
  
  weak var coordinator: PostDetailCoordinatorDelegate?

  // MARK: - Lifecycle
  init(viewModel: any PostDetailViewModelable & PostDetailTableViewDataSource) {
    self.viewModel = viewModel
    super.init(style: .grouped)
    adapter = PostDetailTableViewAdapter(
      dataSource: viewModel,
      delegate: self,
      tableView: tableView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func loadView() {
    super.loadView()
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 235
    tableView.separatorInset = .zero
    tableView.backgroundColor = .white
    tableView.scrollIndicatorInsets = .init(top: 0, left: -1, bottom: 0, right: -1)
    let minimaiSize = CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: minimaiSize))
    tableView.keyboardDismissMode = .interactive
    tableView.contentInset = .zero
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
    tableView.addGestureRecognizer(tap)
    registerReusableViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    inputAccessory.delegate = self
    bind()
    input.viewDidLoad.send()
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
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension PostDetailViewController: ViewBindCase {
  typealias Input = PostDetailViewModelInput
  typealias ErrorType = Error
  typealias State = PostDetailViewModelState
  
  func bind() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didHideKeyboard),
      name: UIResponder.keyboardDidHideNotification,
      object: nil)
    
    let output = viewModel.transform(input)
    output.receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
  }
  
  func render(_ state: PostDetailViewModelState) {
    switch state {
    case .none:
      break
    case .networkProcessing:
      startIndicator()
    case .reloadedData:
      stopIndicator()
      tableView.reloadData()
    case .reloadedComment:
      tableView.reloadData()
      tableView.scrollToRow(
        at: IndexPath(row: NSNotFound, section: viewModel.numberOfSections-1),
        at: .bottom, animated: false)
      stopIndicator()
    case .unexpectedError(description: let description):
      coordinator?.showAlertForError(with: description, completion: nil)
    case .loggedInUserInfo(userProfile: let userProfile):
      inputAccessory.configure(with: userProfile)
    case .nestedComment(let commentState):
      switch commentState {
      case .completionSend(let section):
        inputAccessory.hideKeyboard()
        /// 이상하게 reloadData하면 잘 됩니다.
        /// 테이블뷰 리로드 섹션할때 키보드 에니메이션도 동작되서그런건지 section내 특정 row가 위로 샤라락하면서 없어집니다.
        /// hideKeyboard() 애니메이션이 완료된 시점이후에 reloadSections를 해도 그렇습니다.
        tableView.reloadData()
        // tableView.reloadSections(IndexSet(integer: section), with: .fade)
        stopIndicator()
      case .replyCancel:
        inputAccessory.clearCommentInputState()
        inputAccessory.hideKeyboard()
      case .replyContinue:
        inputAccessory.showKeyboard()
      case .keyboardState(let keyboard):
        switch keyboard {
        case .willShow:
          tableView.keyboardDismissMode = .none
          inputAccessory.showKeyboard()
        case .willHide:
          break
        }
      case .replyCancellationAsk:
        coordinator?.showAnAlertToAskWhetherToCancelWrittingTheReply { [weak self] wannaCancel in
          self?.input.keyboardDidHideWhenReplyingToMessageNotifier.send(wannaCancel)
        }
      }
    }
  }
  
  func handleError(_ error: any ErrorType) { }
}

// MARK: - Private Helpers
private extension PostDetailViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupDefaultBackBarButtonItem(marginLeft: 0)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: starButton)
    starButton.translatesAutoresizingMaskIntoConstraints = false
    starButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    starButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    starButton.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
  }
  
  func setTitleView() {
    navigationItem.titleView = naviTitle
    naviTitle.alpha = 0
  }
  
  func registerReusableViews() {
    tableView.register(
      PostDetailCategoryHeaderView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCategoryHeaderView.id)
    tableView.register(
      PostDetailTitleCell.self,
      forCellReuseIdentifier: PostDetailTitleCell.id)
    tableView.register(
      PostDetailProfileAreaFooterView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailProfileAreaFooterView.id)
    
    tableView.register(
      PostDetailContentTextCell.self,
      forCellReuseIdentifier: PostDetailContentTextCell.id)
    tableView.register(
      PostDetailContentImageCell.self,
      forCellReuseIdentifier: PostDetailContentImageCell.id)
    tableView.register(
      PostDetailContentFooterView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailContentFooterView.id)
    tableView.register(
      PostHeartAndShareAreaHeaderView.self,
      forHeaderFooterViewReuseIdentifier: PostHeartAndShareAreaHeaderView.id)
    
    tableView.register(
      PostDetailCommentHeader.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCommentHeader.id)
    tableView.register(
      PostDetailReplyCell.self,
      forCellReuseIdentifier: PostDetailReplyCell.id)
  }
}

// MARK: - Actions
extension PostDetailViewController {
  @objc private func didTapTableView() {
    inputAccessory.hideKeyboard()
  }
  
  @objc private func didTapStarButton() {
    print("카운팅스타~ 밤하늘의 퍼어얼")
  }
  
  // MARK: - Keyboard Actions
  @objc private func didHideKeyboard(_ notification: Notification) {
    input.replyDismissalConfirmationNorifier.send()
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
  
  func showUploadedUserProfilePage(with userId: Int32) {
    print("업로드 유저 프로필 화면으로 이동!!")
  }
  
  func showCategoryDetailPage() {
    print("카데고리 상세 화면으로 이동!!!")
  }
}

// MARK: - PostDetailReplyCellDelegate
extension PostDetailViewController: PostDetailReplyCellDelegate {
  func didTapProfile(_ cell: UITableViewCell) {
    print("대댓 프로필 클릭")
  }
  
  func didTapHeart(_ cell: UITableViewCell, isOnHeart: Bool) {
    print("대댓 하트 뿅")
  }
  
  func didCanceledHeart(_ cell: UITableViewCell) {
    print("대댓 하트 취소")
  }
}

// MARK: - PostDetailCommentDelegate
extension PostDetailViewController: PostDetailCommentDelegate {
  func didTapHeart(_ header: PostDetailCommentHeaderIdentifiable, _ isOnHeart: Bool) {}
  
  func didTapCanceledHeart(_ header: PostDetailCommentHeaderIdentifiable) {}
  
  func didTapReply(_ header: PostDetailCommentHeaderIdentifiable) {
    guard let replySection = header.section else {
      coordinator?.showAlertForError(with: "대댓글을 작성할 수 없습니다.\n앱 서비스에 문제가 발생됬습니다.", completion: nil)
      return
    }
    input.replyStartNotifier.send(replySection)
  }
  
  func didTapProfile(_ header: PostDetailCommentHeaderIdentifiable) {}
}

// MARK: - PostDetailInputAccessoryWrapperDelegate
extension PostDetailViewController: PostDetailInputAccessoryWrapperDelegate {
  func didTouchSendIcon(_ text: String) {
    input.commentHandler.send(.commentSend(text))
  }
}

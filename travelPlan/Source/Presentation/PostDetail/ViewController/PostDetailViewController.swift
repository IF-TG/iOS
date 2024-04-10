//
//  PostDetailViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit
import Combine
import SHCoordinator

final class PostDetailViewController: UITableViewController {
  // MARK: - Dependencies
  private let viewModel: any PostDetailViewModelable & PostDetailTableViewDataSource
  
  // MARK: - UI Properties
  private let inputAccessory = PostDetailInputAccessoryWrapper()
  
  private let naviTitle = BaseLabel(fontType: .semiBold_600(fontSize: 16)).set {
    $0.alpha = 0
  }
  
  private let starButton = SearchStarButton(normalType: .black)
  
  private var naviTitleAnimator: UIViewPropertyAnimator?
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  override var inputAccessoryView: UIView? {
    return inputAccessory
  }
  
  // MARK: - Properties
  private var isHandlingKeyboardEvent = false
  
  private var adapter: PostDetailTableViewAdapter?
  
  private var notificationSubscriptions = Set<AnyCancellable>()
  
  private let input = PostDetailViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()

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
    //왜 ? viewDidApper에 타이틀뷰하지?
    // TODO: - 타이틀뷰 헤더 좌표계바꿔서 더 유연하게 사라지고 보여지도록 로직 개선해야합니다.
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

// MARK: - ViewBindCase
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
    case .unexpectedError(description: let description):
      stopIndicator()
      viewModel.showAlertForError(with: description, completion: nil)
    case .networkProcessing:
      startIndicator()
    case .viewDidLoad(let viewDidLoadState):
      handleViewDidLoadState(viewDidLoadState)
    case .comment(let commentState):
      handleCommentState(commentState)
    case .nestedComment(let commentState):
      handleNestedCommentState(commentState)
    case .postReport:
      stopIndicator()
      /// postReportNotifier, postAuthorBlockNotifier호출 완료 시점 postReport State를 전송해야 합니다.
      viewModel.showPostReportResult()
    }
  }
  
  // MARK: - View UI render helper
  func handleViewDidLoadState(_ viewDidLoadState: PostDetailViewDidLoadState) {
    switch viewDidLoadState {
    case .loggedInUserInfo(let userProfile):
      inputAccessory.configure(with: userProfile)
    case .reloadedCommentsWithPostFavoriteInfo(let isFavorite):
      tableView.reloadData()
      stopIndicator()
      starButton.isSelected = isFavorite
    }
  }
  
  func handleCommentState(_ commentState: PostDetailCommentState) {
    switch commentState {
    case .reloadedComment:
      tableView.reloadData()
      tableView.scrollToRow(
        at: IndexPath(row: NSNotFound, section: viewModel.numberOfSections-1),
        at: .bottom, animated: false)
      stopIndicator()
    case .reloadWhenCommentDelete(let section):
      UITableView.performWithoutAnimation {
        tableView.deleteSections(IndexSet(integer: section), with: .none)
        // tableView.reloadData()
      }
      stopIndicator()
    case .reloadWithNestedCommentsWhenCommentDelete(let section):
      UITableView.performWithoutAnimation {
        tableView.reloadSections(IndexSet(integer: section), with: .none)
      }
      stopIndicator()
    }
  }
  
  func handleNestedCommentState(_ nestedCommentState: PostDetailNestedCommentState) {
    switch nestedCommentState {
    case .sentSuccessfully(let section):
      inputAccessory.hideKeyboard()
      UITableView.performWithoutAnimation {
        tableView.reloadSections(IndexSet(integer: section), with: .none)
      }
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
      viewModel.showAnAlertToAskWhetherToCancelWrittingTheReply { [weak self] wannaCancel in
        self?.input.keyboardDidHideWhenReplyingToMessageNotifier.send(wannaCancel)
      }
    case .reload(let indexPath):
      UITableView.performWithoutAnimation {
        /// 특정 행만 제거하기 때문에 데이터 소스에서 제거 후 아래 함수 호출하는게 베스트지만, 아래 함수 이외에 다른 행들도 첫번째 대댓글인지 여부에 따라 태그가 추가되야
        /// 합니다.
        /// tableView.deleteRows(at: [indexPath], with: .top)
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .top)
      }
      stopIndicator()
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
}
  
// MARK: - Actions
extension PostDetailViewController {
  @objc private func didTapTableView() {
    inputAccessory.hideKeyboard()
  }
  
  @objc private func didTapStarButton() {
    starButton.isSelected.toggle()
    // TODO: - 토글전에! 찜 디렉터리 보여줘야 합니다!
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
      animations: { [weak self] in
        self?.naviTitle.alpha = 0
        self?.naviTitle.transform = .init(translationX: 0, y: self?.naviTitle.font.lineHeight ?? 0)
      })
    naviTitleAnimator?.addCompletion { [weak self] _ in
      self?.naviTitle.isHidden = true
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
      animations: { [weak self] in
        self?.naviTitle.transform = .identity
        self?.naviTitle.alpha = 1
      })
    naviTitleAnimator?.addCompletion { [weak self] _ in
      self?.naviTitle.isHidden = false
    }
    naviTitleAnimator?.startAnimation()
  }
  
  func showUploadedUserProfilePage(with userId: Int32) {
    print("업로드 유저 프로필 화면으로 이동!!")
  }
  
  func showCategoryDetailPage() {
    viewModel.showCategory()
  }
}

// MARK: - PostDetailReplyCellDelegate
extension PostDetailViewController: PostDetailReplyCellDelegate {
  func didTapOption(_ cell: UITableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      viewModel.showAlertForError(with: "대댓글 옵션을 선택할 수 없습니다.\n앱 서비스에 문제가 발생했습니다.", completion: nil)
      return
    }
    viewModel.showNestedCommentOption(indexPath: indexPath)
  }
  
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
  func didTapOption(_ header: UITableViewHeaderFooterView) {
    var section = -1
    (0..<viewModel.numberOfSections).forEach { i in
      let specificHeader = tableView.headerView(forSection: i)
      if specificHeader === header {
        section = i
        print("찾았당:\(i)")
      }
    }
    if section == -1 {
      print("못찾았땅")
      return
    }
    viewModel.showCommentOption(section: section)
  }
  
  func didTapHeart(_ header: UITableViewHeaderFooterView, _ isOnHeart: Bool) {}
  
  func didTapCanceledHeart(_ header: UITableViewHeaderFooterView) {}
  
  func didTapReply(_ header: UITableViewHeaderFooterView) {
    var section = -1
    (0..<viewModel.numberOfSections).forEach { i in
      let specificHeader = tableView.headerView(forSection: i)
      if specificHeader === header {
        section = i
        print("찾았당:\(i)")
      }
    }
    if section == -1 {
      print("못찾았땅")
      return
    }
//    guard let replySection = header.section else {
//      viewModel.showAlertForError(with: "대댓글을 작성할 수 없습니다.\n앱 서비스에 문제가 발생됬습니다.", completion: nil)
//      return
//    }
    input.replyStartNotifier.send(section)
  }
  
  func didTapProfile(_ header: UITableViewHeaderFooterView) {}
}

// MARK: - PostDetailInputAccessoryWrapperDelegate
extension PostDetailViewController: PostDetailInputAccessoryWrapperDelegate {
  func didTouchSendIcon(_ text: String) {
    input.commentSendHandler.send(text)
  }
}

// MARK: - PostHeartAndShareAreaHeaderViewDelegate
extension PostDetailViewController: PostHeartAndShareAreaHeaderViewDelegate {
  func didTapOption() {
    viewModel.showPostOption()
  }
  
  func didTapHeart(isFavorite: Bool) {
    print("포스트 하트클릭")
  }
  
  func didTapShare() {
    print("공유클릭 도깨비 아님주의.")
  }
}

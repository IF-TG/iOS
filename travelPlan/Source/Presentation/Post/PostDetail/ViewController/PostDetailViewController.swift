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
  typealias PostDetailViewModelType = (any PostDetailViewModelable &
                                       PostDetailTableViewDataSource &
                                       PostDetailViewModelPageDelegate)
  
  typealias PostDetailChatViewModelType = (any PostDetailChatViewModelable &
                                           PostDetailChatDataSource &
                                           PostDetailChatViewModelPageDelegate)
  
  typealias PostDetailOptionViewModelType = (any PostOptionViewModelable &
                                             PostOptionViewModelPageDelegate)
  
  // MARK: - Dependencies
  private let viewModel: PostDetailViewModelType
  
  private let chatViewModel: PostDetailChatViewModelType
  
  private let optionViewModel: PostDetailOptionViewModelType
  
  // MARK: - UI Properties
  private let inputAccessory = PostDetailInputAccessoryWrapper()
  
  private let naviTitle = BaseLabel(fontType: .semiBold_600(fontSize: 16)).set {
    $0.alpha = 0
    $0.textAlignment = .center
    
  }
  
  private let naviDuration = BaseLabel(fontType: .medium_500(fontSize: 12)).set {
    $0.alpha = 0
    $0.textAlignment = .center
  }
  
  private let naviTitleView = UIView(frame: .zero)
  
  private lazy var starButton = SearchStarButton(normalType: .black)
  
  private var naviTitleAnimator: UIViewPropertyAnimator?
  
  private var naviDurationAnimator: UIViewPropertyAnimator?
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  override var inputAccessoryView: UIView? {
    return inputAccessory
  }
  
  // MARK: - Properties
  private var adapter: PostDetailTableViewAdapter?
  
  private var notificationSubscriptions = Set<AnyCancellable>()
  
  private let input = PostDetailViewModelInput()
  
  private let chatInput = PostDetailChatViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()

  private lazy var editButton = UIButton().set {
    $0.setTitle("편집", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  init(
    viewModel: PostDetailViewModelType,
    chatViewModel: PostDetailChatViewModelType,
    optionViewModel: PostDetailOptionViewModelType
  ) {
    self.viewModel = viewModel
    self.chatViewModel = chatViewModel
    self.optionViewModel = optionViewModel
    super.init(style: .grouped)
    adapter = PostDetailTableViewAdapter(
      dataSource: viewModel,
      chatDataSource: chatViewModel,
      delegate: self,
      tableView: tableView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func loadView() {
    super.loadView()
    setTableView()
    registerReusableViews()
    bind()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    inputAccessory.delegate = self
    input.viewDidLoad.send()
    chatInput.viewDidLoad.send()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setTitleView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    (self.tabBarController as? MainTabBarController)?.hideShadowLayer()
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.topItem?.titleView = nil
    (self.tabBarController as? MainTabBarController)?.showShadowLayer()
    self.tabBarController?.tabBar.isHidden = false
  }
  
  deinit {
    print("deinit: \(Self.self)")
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
    output
      .receive(on: RunLoop.current)
      .sink { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
    
    let chatViewModelOutput = chatViewModel.transform(chatInput)
    chatViewModelOutput
      .receive(on: RunLoop.current)
      .sink { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
    
    let optionViewModelOutput = optionViewModel.transform(PostOptionViewModelInput())
    optionViewModelOutput
      .receive(on: RunLoop.current)
      .sink { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
  }
  
  // MARK: - render
  /// 화면 전환은 output을 받은 VC의 render내부 scope는 main thread에 의해 제어됨으로.
  ///   이때 뷰 관련 전환을 호출하도록 구현했습니다.
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
    case .failedToFetchPost(let description):
      stopIndicator()
      viewModel.showAlertAndDismiss(with: description)
    }
  }
  
  func render(_ state: PostDetailChatViewModelState) {
    switch state {
    case .none:
      break
    case .networkProcessing:
      startIndicator()
    case .unexpectedError(let description):
      stopIndicator()
      viewModel.showAlertForError(with: description, completion: nil)
    case .comment(let commentState):
      handleCommentState(commentState)
    case .nestedComment(let nestedCommentState):
      handleNestedCommentState(nestedCommentState)
    case .keyboard(let keyboardState):
      handleKeyboardOutputState(keyboardState)
    case .viewDidLoad(let chatViewDidLoadStream):
      switch chatViewDidLoadStream {
      case .reloadedCommentsWithPostFavoriteInfo(let isFavorite):
        stopIndicator()
        tableView.reloadData()
        starButton.isSelected = isFavorite
      }
    }
  }
  
  func render(_ state: PostOptionViewModelState) {
    switch state {
    case .networkProcessing:
      startIndicator()
    case .completeReport:
      stopIndicator()
    case .completeUserBlock:
      /// 이 시점에 노티피케이션을 통해서 추가적인 로직들이 실행됩니다.
      /// Notification.Name = hasUserBlocked
      stopIndicator()
    case .unexpectedError(let description):
      stopIndicator()
      optionViewModel.showAlertForError(with: description, completion: nil)
    }
  }
    
  // MARK: - View UI render helper
  func handleViewDidLoadState(_ viewDidLoadState: PostDetailViewDidLoadState) {
    switch viewDidLoadState {
    case .loggedInUserInfo(let userProfile, let isPostOwner):
      if isPostOwner {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
      } else {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: starButton)
      }
      inputAccessory.configure(with: userProfile)
    case .naviTitleInfo((let title, let duration)):
      naviTitle.text = title
      naviDuration.text = duration
      naviTitle.transform = .init(translationX: 0, y: naviTitle.font.lineHeight)
      naviDuration.transform = .init(translationX: 0, y: naviDuration.font.lineHeight)
      naviTitle.isHidden = true
    case .reloadData:
      stopIndicator()
      tableView.reloadData()
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
      }
      stopIndicator()
    case .reloadWithNestedCommentsWhenCommentDelete(let section):
      UITableView.performWithoutAnimation {
        tableView.reloadSections(IndexSet(integer: section), with: .none)
      }
      stopIndicator()
    case .reloadWhenCommentUpdate(let section):
      UITableView.performWithoutAnimation {
        tableView.reloadSections(IndexSet(integer: section), with: .none)
      }
      tableView.keyboardDismissMode = .interactive
      inputAccessory.clearEditingText()
      inputAccessory.hideKeyboard()
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
    case .reload(let indexPath):
      UITableView.performWithoutAnimation {
        /// 특정 행만 제거하기 때문에 데이터 소스에서 제거 후 아래 함수 호출하는게 베스트지만, 아래 함수 이외에 다른 행들도 첫번째 대댓글인지 여부에 따라 태그가 추가되야 합니다.
        /// tableView.deleteRows(at: [indexPath], with: .top)
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
      }
      stopIndicator()
    case .reloadWhenLastNestedCommentDelete(let indexPath):
      UITableView.performWithoutAnimation {
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
      }
      stopIndicator()
    case .reloadWhenCommentUpdate(let indexPath):
      UITableView.performWithoutAnimation {
        tableView.reloadRows(at: [indexPath], with: .none)
      }
      tableView.keyboardDismissMode = .interactive
      inputAccessory.clearEditingText()
      inputAccessory.hideKeyboard()
      stopIndicator()
    }
  }
  
  func handleKeyboardOutputState(_ keyboardState: PostDetailKeyboardState) {
    switch keyboardState {
    case .willShow:
      /// 대댓글 작성시
      tableView.keyboardDismissMode = .none
      inputAccessory.showKeyboard()
    case .willShowWhenCommentEditStart(let writtenComment):
      /// 대댓글, 댓글 편집시
      inputAccessory.clearCommentInputState()
      tableView.keyboardDismissMode = .none
      inputAccessory.setCommentForEditMode(writtenComment)
      inputAccessory.showKeyboard()
    case .hideToWritingCancel:
      inputAccessory.clearCommentInputState()
      inputAccessory.hideKeyboard()
      tableView.keyboardDismissMode = .interactive
    case .writingContinue:
      inputAccessory.showKeyboard()
    }
  }
  
  func handleError(_ error: any ErrorType) { }
}

// MARK: - Private Helpers
private extension PostDetailViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupDefaultBackBarButtonItem(marginLeft: 0)
    starButton.translatesAutoresizingMaskIntoConstraints = false
    starButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    starButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    starButton.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
  }
  
  func setTitleView() {
    [naviTitle, naviDuration].forEach { naviTitleView.addSubview($0) }
    
    NSLayoutConstraint.activate([
      naviTitle.leadingAnchor.constraint(equalTo: naviTitleView.leadingAnchor),
      naviTitle.topAnchor.constraint(equalTo: naviTitleView.topAnchor),
      naviTitle.trailingAnchor.constraint(equalTo: naviTitleView.trailingAnchor),
      naviDuration.leadingAnchor.constraint(equalTo: naviTitleView.leadingAnchor),
      naviDuration.topAnchor.constraint(equalTo: naviTitle.bottomAnchor),
      naviDuration.trailingAnchor.constraint(equalTo: naviTitleView.trailingAnchor),
      naviDuration.bottomAnchor.constraint(equalTo: naviTitleView.bottomAnchor)])
    navigationItem.titleView = naviTitleView
    naviTitle.alpha = 0
  }
}
  
// MARK: - Actions
extension PostDetailViewController {
  @objc private func didTapEditButton() {
    viewModel.showReviewWriting()
  }
  
  @objc func didTapTableView() {
    inputAccessory.hideKeyboard()
  }
  
  @objc private func didTapStarButton() {
    starButton.isSelected.toggle()
    // TODO: - 토글전에! 찜 디렉터리 보여줘야 합니다!
  }
  
  // MARK: - Keyboard Actions
  @objc private func didHideKeyboard(_ notification: Notification) {
    chatInput.keyboardHideNotifier.send()
  }
}

// MARK: - PostDetailTableViewDelegate
extension PostDetailViewController: PostDetailTableViewAdapterDelegate {
  func willDisplayDurationInTableView() {
    guard let naviHeight = navigationController?.navigationBar.bounds.height else { return }
    let naviTitleViewHeight = naviTitle.font.lineHeight + naviDuration.font.lineHeight
    let spacing = (naviHeight - naviTitleViewHeight)/2
    naviDurationAnimator?.stopAnimation(true)
    naviDurationAnimator = UIViewPropertyAnimator(
      duration: 0.28,
      curve: .easeIn,
      animations: { [weak self] in
        self?.naviDuration.alpha =  0
        self?.naviDuration.transform = .init(translationX: 0, y: self?.naviDuration.font.lineHeight ?? 0)
        self?.naviTitleView.transform = .init(translationX: 0, y: spacing)
      })
    naviDurationAnimator?.addCompletion { [weak self] _ in
      self?.naviDuration.isHidden = true
    }
    naviDurationAnimator?.startAnimation()
  }
  
  func disappearDurationInTableView() {
    naviDurationAnimator?.stopAnimation(true)
    naviDuration.isHidden = false
    guard let naviHeight = navigationController?.navigationBar.bounds.height else { return }
    let naviTitleViewHeight = naviTitle.font.lineHeight + naviDuration.font.lineHeight
    let spacing = (naviHeight - naviTitleViewHeight)/2
    naviTitleAnimator = UIViewPropertyAnimator(
      duration: 0.28,
      curve: .easeOut,
      animations: { [weak self] in
        self?.naviDuration.transform = .identity
        self?.naviDuration.alpha = 1
        self?.naviTitleView.transform = .init(translationX: 0, y: -spacing)
      })
    naviTitleAnimator?.addCompletion { [weak self] _ in
      self?.naviTitle.isHidden = false
    }
    naviTitleAnimator?.startAnimation()

  }
  
  func willDisplayTitleInTableView() {
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
  
  func disappearTitleInTableView() {
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
    chatViewModel.showNestedCommentOption(indexPath: indexPath)
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
    guard let section = tableView.section(
      for: header,
      numberOfSections: viewModel.numberOfSections + chatViewModel.numberOfSections
    ) else {
      viewModel.showAlertForError(with: "대댓글을 작성할 수 없습니다.\n앱 서비스에 문제가 발생됬습니다.", completion: nil)
      return
    }
    chatViewModel.showCommentOption(section: PostDetailSection(rawValue: section))
  }
  
  func didTapHeart(_ header: UITableViewHeaderFooterView, _ isOnHeart: Bool) {}
  
  func didTapCanceledHeart(_ header: UITableViewHeaderFooterView) {}
  
  func didTapReply(_ header: UITableViewHeaderFooterView) {
    guard let section = tableView.section(
      for: header,
      numberOfSections: viewModel.numberOfSections + chatViewModel.numberOfSections
    ) else {
      viewModel.showAlertForError(with: "대댓글을 작성할 수 없습니다.\n앱 서비스에 문제가 발생됬습니다.", completion: nil)
      return
    }
    chatInput.replyStartNotifier.send(section)
  }
  
  func didTapProfile(_ header: UITableViewHeaderFooterView) {}
}

// MARK: - PostDetailInputAccessoryWrapperDelegate
extension PostDetailViewController: PostDetailInputAccessoryWrapperDelegate {
  func didTouchSendIcon(_ text: String) {
    chatInput.commentSendHandler.send(text)
  }
}

// MARK: - PostHeartAndShareAreaHeaderViewDelegate
extension PostDetailViewController: PostHeartAndShareAreaHeaderViewDelegate {
  func didTapOption() {
    optionViewModel.showPostOption()
  }
  
  func didTapHeart(isFavorite: Bool) {
    print("포스트 하트클릭")
  }
  
  func didTapShare() {
    print("공유클릭 도깨비 아님주의.")
  }
}

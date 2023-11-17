//
//  ReviewWritingContentView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import Combine
import SnapKit

final class ReviewWritingContentView: UIView {
  // MARK: - Nested
  enum Constant {
    enum LastView {
      static let bottomSpacing: CGFloat = 40
    }
  }
  
  struct ValueRelatedToScrolling {
    var shouldScrollToLastView = false
    var keyboardHeight: CGFloat?
    var scrollViewHeight: CGFloat?
    var cursorHeight: CGFloat?
    var spacingFromCursorBoundaryToKeyboard: CGFloat {
      return Constant.LastView.bottomSpacing
    }
    var spacingFromScrollViewTopToCursorBoundary: CGFloat? {
      guard let b = self.keyboardHeight,
            let f = self.scrollViewHeight,
            let t = self.bottomViewHeight
      else { return nil }
      return f-(b-t)-spacingFromCursorBoundaryToKeyboard
    }
    var bottomViewHeight: CGFloat?
    var safeAreaTopInset: CGFloat?
  }
  
  // MARK: - Properties
  private var scrollValue = ValueRelatedToScrolling()
  weak var delegate: ReviewWritingContentViewDelegate?
  private var subscriptions = Set<AnyCancellable>()
  private lazy var titleTextView: UITextView = .init().set {
    $0.text = "제목(최대 60자)"
    $0.font = .init(pretendard: .regular_400(fontSize: 22))
    $0.textColor = .yg.gray1
    $0.isScrollEnabled = false
    $0.delegate = self
  }
  
  private lazy var messageTextView: UITextView = .init().set {
    $0.text = "이번 여행에 대한 나의 후기를\n자유롭게 작성해보세요. :)"
    $0.font = .init(pretendard: .regular_400(fontSize: 16))
    $0.textColor = .yg.gray1
    $0.isScrollEnabled = false
    $0.delegate = self
  }
  
  private let boundaryLineView: UIView = .init().set {
    $0.backgroundColor = .yg.gray0
  }
  
  private lazy var messageTextViewList: [UITextView] = {
    var list = [UITextView]()
    list.append(messageTextView)
    return list
  }()
  private var messageTextViewLastHeight: CGFloat = 0
  private var textViewList = [(textView: UITextView, lastChangedHeight: CGFloat)]()
  private var imageViewList = [UIImageView]()
  private var lastViewBottomConstraint: ConstraintMakerEditable?
  private lazy var lastView: UIView = messageTextView

  var scrollToLastView: ((_ cursorHeight: CGFloat, _ lastView: UIView) -> Void)?


  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if scrollValue.shouldScrollToLastView {
      guard let h = scrollValue.cursorHeight else { return }
      scrollToLastView?(h, lastView)
      scrollValue.shouldScrollToLastView = false
    }
  }
}

// MARK: - LayoutSupport
extension ReviewWritingContentView: LayoutSupport {
  func addSubviews() {
    addSubview(titleTextView)
    addSubview(boundaryLineView)
    addSubview(messageTextView)
  }
  
  func setConstraints() {
    titleTextView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(24)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50)
    }
    
    boundaryLineView.snp.makeConstraints {
      $0.top.equalTo(titleTextView.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(2)
      $0.height.equalTo(1)
    }
    
    let estimatedHeight = messageTextView.sizeThatFits(
      CGSize(width: messageTextView.frame.width, height: CGFloat.infinity))
      .height
    messageTextViewLastHeight = estimatedHeight
    textViewList.append((textView: messageTextView, lastChangedHeight: estimatedHeight))
    messageTextView.snp.makeConstraints {
      $0.top.equalTo(boundaryLineView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      self.lastViewBottomConstraint = $0.bottom.equalToSuperview().inset(Constant.LastView.bottomSpacing)
      $0.height.equalTo(estimatedHeight)
    }
  }
}

// MARK: - UITextViewDelegate
extension ReviewWritingContentView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    // TODO: - Bool 변수 사용해서 특정 조건일때만 호출되도록 하기
    if textView === titleTextView || textView === messageTextView {
      erasePlaceholder(of: textView)
    }
    // TODO: - Bool 변수 사용해서 h에 값 한번만 넣기
    scrollValue.cursorHeight = getCursorHeight(of: textView)
    manageScroll(at: textView)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    // TODO: - 오토레이아웃 성능 개선하기
    adjustHeight(of: textView)
    if let keyboardHeight = scrollValue.keyboardHeight,
       let bottomViewHeight = scrollValue.bottomViewHeight {
      delegate?.changeContentInset(
        bottomEdge: keyboardHeight - bottomViewHeight + scrollValue.spacingFromCursorBoundaryToKeyboard
      )
    }
    
    if textView === titleTextView {
      limitTextStringCount(at: textView)
    }
  }
  
  func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    // 제목설정 시, return키 금지
    if textView === titleTextView {
      let tapReturnKey = text == "\n"
      if tapReturnKey {
        return false
      }
    }
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    configurePlaceholder(of: textView)
  }
  
  // textView를 터치하거나 타이핑하는 경우
  func textViewDidChangeSelection(_ textView: UITextView) {
  }
}

// MARK: - Private Helpers
extension ReviewWritingContentView {
  private func cursorIsUnderTheBoundary(at textView: UITextView) -> Bool? {
    self.layoutIfNeeded()
    guard let a = self.getCursorY(of: textView),
          let v = scrollValue.spacingFromScrollViewTopToCursorBoundary else { return nil }
    return a > v
  }
  
  private func manageScroll(at textView: UITextView) {
    guard let keyboardHeight = scrollValue.keyboardHeight,
          let bottomViewHeight = scrollValue.bottomViewHeight,
          let scrollToFitContentOffset = cursorIsUnderTheBoundary(at: textView),
          scrollToFitContentOffset
    else { return }
    
    self.delegate?.changeContentInset(
      bottomEdge: keyboardHeight - bottomViewHeight + scrollValue.spacingFromCursorBoundaryToKeyboard
    )
  }
  
  private func getCursorHeight(of textView: UITextView) -> CGFloat? {
    guard let cursorFrame = cursorFrame(of: textView) else { return nil }
    return cursorFrame.height
  }
  
  /// ReviewWritingContentView의 좌표계를 기준으로 cursor의 y값을 반환합니다.
  private func getCursorY(of textView: UITextView) -> CGFloat? {
    guard let cursorFrame = cursorFrame(of: textView),
          let safeAreaTopInset = scrollValue.safeAreaTopInset
    else { return nil }
    
    return cursorFrame.origin.y - safeAreaTopInset
  }
  
  private func bind() {
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: RunLoop.main)
      .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
      .sink { [weak self] keyboardRect in
        self?.scrollValue.keyboardHeight = keyboardRect.height
      }
      .store(in: &subscriptions)
  }
  
  /// window 좌표계를 기준으로 cursor의 frame을 반환합니다.
  private func cursorFrame(of textView: UITextView) -> CGRect? {
    guard let textRange = textView.selectedTextRange
    else { return nil }
    let cursorRectInTextView = textView.caretRect(for: textRange.start)
    let cursorRectInWindow = textView.convert(cursorRectInTextView, to: nil)

    return cursorRectInWindow
  }
  
  private func limitTextStringCount(at textView: UITextView) {
    if titleTextView.text.count > 60 {
      // TODO: - 최대 글자 수를 넘으면 글자에 대한 헬퍼 뷰를 띄워야합니다.
      titleTextView.text.removeLast()
    }
  }
  
  private func erasePlaceholder(of textView: UITextView) {
    guard textView.textColor == .yg.gray1 else { return }
    textView.text = nil
    textView.textColor = .yg.gray7
  }
  
  private func configurePlaceholder(of textView: UITextView) {
    if textView.text.isEmpty {
      if textView === titleTextView {
        textView.textColor = .yg.gray1
        textView.text = "제목"
      } else if textView === messageTextView {
        textView.textColor = .yg.gray1
        textView.text = "이번 여행에 대한 나의 후기를\n자유롭게 작성해보세요. :)"
        adjustHeight(of: textView)
      }
    }
  }
  
  /// textView의 text를 기반으로 알맞은 autoLayout height으로 조정합니다.
  private func adjustHeight(of textView: UITextView) {
    let estimatedHeight = textView.sizeThatFits(
      CGSize(width: textView.frame.width, height: CGFloat.infinity)
    ).height
    textView.snp.updateConstraints {
      $0.height.equalTo(estimatedHeight)
    }
    scrollValue.shouldScrollToLastView = true
  }
  
  /// 제약조건 재설정 방식
   /// 1. lastView의 bottom과 superView의 bottom을 제거
   /// 2. lastView의 bottom과 view의 top 제약조건
   /// 3. view의 bottom과 superView의 bottom 제약 조건
     /// - 이때 view의 bottom과 superView의 bottom간의 constraints를 저장
   /// 4. view를 lastView로 갱신
  private func addLastView(lastView view: UIView) {
    lastViewBottomConstraint?.constraint.deactivate()
    addSubview(view)
    view.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(lastView.snp.bottom).offset(10)
      lastViewBottomConstraint = $0.bottom.equalToSuperview().inset(Constant.LastView.bottomSpacing)
    }
    lastView = view
    makeLastViewHeightConstraint()
    
    view.layoutIfNeeded() // view는 lastView. 이 시점에 lastView의 height이 결정
    scrollValue.shouldScrollToLastView = true
  }
  
  private func makeLastViewHeightConstraint() {
    if lastView is UITextView {
      lastView.snp.makeConstraints {
        $0.height.equalTo(40)
      }
    } else if lastView is UIImageView {
      lastView.snp.makeConstraints {
        $0.height.equalTo(100)
      }
    }
  }
  
  private func createNewTextView() -> UITextView {
    return UITextView().set {
      $0.font = .init(pretendard: .regular_400(fontSize: 16))
      $0.textColor = .yg.gray6
      $0.isScrollEnabled = false
      $0.delegate = self
    }
  }
  
  /// 텍스트뷰의 마지막 문자로 커서가 이동합니다.
  private func moveCursorPosition(textView: UITextView) {
    guard let text = textView.text,
          let cursorPosition = textView.position(
            from: textView.beginningOfDocument,
            offset: text.distance(from: text.startIndex, to: text.endIndex)
          ) else { return }
    
    textView.selectedTextRange = textView.textRange(from: cursorPosition, to: cursorPosition)
  }
}

// MARK: - Helpers
extension ReviewWritingContentView {
  func addImageView() {
    let imageView = UIImageView().set {
      $0.image = UIImage(named: "tempProfile1")
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
    }
    imageViewList.append(imageView)
    addLastView(lastView: imageView)
  }
  
  func manageTextViewDisplay() {
    // lastView가 textView인 경우, 해당 textView 포커싱
    // lastView가 imageView인 경우, imageView 밑에 새로운 textView를 제약조건을 통해 추가
    if let textView = lastView as? UITextView {
      moveCursorPosition(textView: textView)
    } else if lastView is UIImageView {
      let newTextView = createNewTextView()
      addLastView(lastView: newTextView)
      self.layoutIfNeeded()
//      textViewList.append((textView: newTextView, lastChangedHeight: newTextView.frame.height))
      if let keyboardHeight = scrollValue.keyboardHeight,
         let bottomViewHeight = scrollValue.bottomViewHeight {
        self.delegate?.changeContentInset(bottomEdge: keyboardHeight - bottomViewHeight + scrollValue.spacingFromCursorBoundaryToKeyboard)
      }
    }
    lastView.becomeFirstResponder()
  }
  
  func safeAreaTopInset(topInset: CGFloat) {
    scrollValue.safeAreaTopInset = topInset
  }
  
  func bottomViewHeight(_ bottomViewHeight: CGFloat) {
    scrollValue.bottomViewHeight = bottomViewHeight
  }
  
  func scrollViewHeight(_ scrollViewHeight: CGFloat) {
    scrollValue.scrollViewHeight = scrollViewHeight
  }
}
// TODO: - messageTextView가 아닌 textView인 경우, textView가 비어있을때 키보드로 문자 삭제키를 누를 경우, textView를 제거

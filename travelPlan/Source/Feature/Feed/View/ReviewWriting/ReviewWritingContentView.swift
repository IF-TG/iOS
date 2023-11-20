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
  private lazy var bottomSpacerView = createSpacerView()
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    let spacerViews = (0..<3).map { _ in self.createSpacerView() }
    _=[spacerViews[0],
       self.titleTextView,
       spacerViews[1],
       self.boundaryLineView,
       spacerViews[2],
       self.messageTextView]
      .map { stackView.addArrangedSubview($0) }
    
    spacerViews[0].heightAnchor.constraint(equalToConstant: 16).isActive = true
    spacerViews[1].heightAnchor.constraint(equalToConstant: 16).isActive = true
    spacerViews[2].heightAnchor.constraint(equalToConstant: 8).isActive = true
    
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 8
    stackView.alignment = .fill
    return stackView
  }()
  
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
  private var imageViewList = [UIImageView]()
  private var lastViewBottomConstraint: ConstraintMakerEditable?
  private lazy var lastView: UIView = messageTextView
  private var textViewPreviousHeight: [UITextView: CGFloat] = [:]
  var scrollToLastView: ((_ cursorHeight: CGFloat, _ lastView: UIView) -> Void)?
  private var shouldScrollToLastView = false
  private var isTextViewDidBeginEditingFirstCalled = false
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
    bind()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if shouldScrollToLastView {
      guard let h = scrollValue.cursorHeight else { return }
      scrollToLastView?(h, lastView)
      shouldScrollToLastView = false
    }
  }
}

// MARK: - LayoutSupport
extension ReviewWritingContentView: LayoutSupport {
  func addSubviews() {
    addSubview(stackView)
    addSubview(bottomSpacerView)
  }
  
  func setConstraints() {
    stackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(bottomSpacerView.snp.top)
    }
    bottomSpacerView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(40)
    }
    titleTextView.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    boundaryLineView.snp.makeConstraints {
      $0.height.equalTo(1)
    }
    
    let estimatedHeight = messageTextView.sizeThatFits(
      CGSize(width: messageTextView.frame.width, height: CGFloat.infinity)
    ).height
    messageTextViewLastHeight = estimatedHeight
    messageTextView.snp.makeConstraints {
      $0.height.equalTo(estimatedHeight)
    }
  }
}

// MARK: - UITextViewDelegate
extension ReviewWritingContentView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView === titleTextView || textView === messageTextView {
      erasePlaceholder(of: textView)
    }

    if !isTextViewDidBeginEditingFirstCalled {
      scrollValue.cursorHeight = getCursorHeight(of: textView)
      isTextViewDidBeginEditingFirstCalled = true
    }
    manageScroll(at: textView)
  }
  
  func textViewDidChange(_ textView: UITextView) {
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
    
    if let previousHeight = textViewPreviousHeight[textView], previousHeight != estimatedHeight {
      textView.snp.updateConstraints {
        $0.height.equalTo(estimatedHeight)
      }
      shouldScrollToLastView = true
      textViewPreviousHeight[textView] = estimatedHeight
    } else if textViewPreviousHeight[textView] == nil {
      textViewPreviousHeight[textView] = estimatedHeight
    }
  }
  
  /// 제약조건 재설정 방식
   /// 1. lastView의 bottom과 superView의 bottom을 제거
   /// 2. lastView의 bottom과 view의 top 제약조건
   /// 3. view의 bottom과 superView의 bottom 제약 조건
     /// - 이때 view의 bottom과 superView의 bottom간의 constraints를 저장
   /// 4. view를 lastView로 갱신
  private func addLastView(lastView view: UIView) {
//    lastViewBottomConstraint?.constraint.deactivate()
//    addSubview(view)
    stackView.addArrangedSubview(view)
//    view.snp.makeConstraints {
//      $0.leading.trailing.equalToSuperview()
//      $0.top.equalTo(lastView.snp.bottom).offset(10)
//      lastViewBottomConstraint = $0.bottom.equalToSuperview().inset(Constant.LastView.bottomSpacing)
//    }
    lastView = view
    makeLastViewHeightConstraint()
    
    view.layoutIfNeeded() // view는 lastView. 이 시점에 lastView의 height이 결정
    shouldScrollToLastView = true
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
  private func moveCursorToLastPosition(at textView: UITextView) {
    guard let text = textView.text,
          let cursorPosition = textView.position(
            from: textView.beginningOfDocument,
            offset: text.distance(from: text.startIndex, to: text.endIndex)
          ) else { return }
    
    textView.selectedTextRange = textView.textRange(from: cursorPosition, to: cursorPosition)
  }
  
  private func createSpacerView() -> UIView {
    return UIView().set {
      $0.backgroundColor = .clear
    }
  }
}

// MARK: - Helpers
extension ReviewWritingContentView {
  func addImageView() {
    let imageView = PictureImageView(imageName: "tempProfile1").set {
      $0.delegate = self
    }
    imageViewList.append(imageView)
    addLastView(lastView: imageView)
  }
  
  func manageTextViewDisplay() {
    // lastView가 textView인 경우, 해당 textView 포커싱
    // lastView가 imageView인 경우, imageView 밑에 새로운 textView를 제약조건을 통해 추가
    if let textView = lastView as? UITextView {
      moveCursorToLastPosition(at: textView)
    } else if lastView is UIImageView {
      let newTextView = createNewTextView()
      addLastView(lastView: newTextView)
      self.layoutIfNeeded()
      if let keyboardHeight = scrollValue.keyboardHeight,
         let bottomViewHeight = scrollValue.bottomViewHeight {
        self.delegate?.changeContentInset(
          bottomEdge: keyboardHeight - bottomViewHeight + scrollValue.spacingFromCursorBoundaryToKeyboard
        )
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

extension ReviewWritingContentView: PictureImageViewDelegate {
  func didTapDeleteButton(_ sender: UIButton) {
    print("이미지 삭제!")
    // 이미지뷰 삭제
    // 오토레이아웃 제거
  }
}

// TODO: - messageTextView가 아닌 textView인 경우, textView가 비어있을때 키보드로 문자 삭제키를 누를 경우, textView를 제거
// TODO: - imageView에 삭제버튼 만들고 기능 구현하기

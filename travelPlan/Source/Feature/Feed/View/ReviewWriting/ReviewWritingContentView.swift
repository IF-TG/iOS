//
//  ReviewWritingContentView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import Combine
import SnapKit

struct ReviewWritingContentViewInfo {
  var text: String = ""
  var imageDataList: [Data] = .init()
//  var isTextIndex: [Bool]
  /// text이면 1, imageData이면 0
  var isTextIndex: String = ""
}

final class ReviewWritingContentView: UIStackView {
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
  private var delimiter = TextDelimiterHelper()
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
  
  private(set) var messageTextViewHasPlaceholder = true
  private lazy var firstMessageTextView: UITextView = .init().set {
    $0.text = "이번 여행에 대한 나의 후기를\n자유롭게 작성해보세요. :)"
    $0.font = .init(pretendard: .regular_400(fontSize: 16))
    $0.textColor = .yg.gray1
    $0.isScrollEnabled = false
    $0.delegate = self
  }
  /// placeholder 여부에 따라 textView를 hidden 처리하므로, 그에 맞게 indexing
  private var firstContentIndex: Int {
    if !firstMessageTextView.isHidden {
      return arrangedSubviews.firstIndex(of: firstMessageTextView)!
    } else {
      return arrangedSubviews.firstIndex(of: firstMessageTextView)! + 1
    }
  }
  private let boundaryLineView: UIView = .init().set {
    $0.backgroundColor = .yg.gray0
  }
  
  private var lastView: UIView? {
    arrangedSubviews.last
  }
  private var textViewPreviousHeight: [UIView: CGFloat] = [:]
  var scrollToLastView: ((_ cursorHeight: CGFloat?, _ lastView: UIView) -> Void)?
  var imageViewUpdated: ((UIImageView) -> Void)?
  private var shouldScrollToLastView = false
  private var isTextViewDidBeginEditingFirstCalled = false

  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bind()
    configure()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if shouldScrollToLastView {
      guard let lastView = lastView else { return }
      scrollToLastView?(scrollValue.cursorHeight, lastView)
      shouldScrollToLastView = false
    }
  }
}

// MARK: - LayoutSupport
extension ReviewWritingContentView: LayoutSupport {
  func addSubviews() {
    let spacerViews = (0..<3).map { _ in self.createSpacerView() }
    _=[spacerViews[0],
       self.titleTextView,
       spacerViews[1],
       self.boundaryLineView,
       spacerViews[2],
       self.firstMessageTextView]
      .map { addArrangedSubview($0) }
  
    spacerViews[0].heightAnchor.constraint(equalToConstant: 16).isActive = true
    spacerViews[1].heightAnchor.constraint(equalToConstant: 16).isActive = true
    spacerViews[2].heightAnchor.constraint(equalToConstant: 8).isActive = true
  }
  
  func setConstraints() {
    titleTextView.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    boundaryLineView.snp.makeConstraints {
      $0.height.equalTo(1)
    }
    
    let estimatedHeight = firstMessageTextView.sizeThatFits(
      CGSize(width: firstMessageTextView.frame.width, height: CGFloat.infinity)
    ).height
    firstMessageTextView.snp.makeConstraints {
      $0.height.equalTo(estimatedHeight)
    }
  }
}

// MARK: - UITextViewDelegate
extension ReviewWritingContentView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView === titleTextView || textView === firstMessageTextView {
      erasePlaceholder(of: textView)
    }

    if !isTextViewDidBeginEditingFirstCalled {
      scrollValue.cursorHeight = cursorFrame(of: textView)?.height
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
    if textView === titleTextView {
      let tapReturnKey = text == "\n"
      if tapReturnKey {
        return false
      }
    }
    
    if textView !== firstMessageTextView,
       textView !== titleTextView,
       textView.text.isEmpty,
       text == "",
       let indexOfViewToBeRemoved = arrangedSubviews.firstIndex(of: textView) {
      arrangedSubviews[indexOfViewToBeRemoved-1].becomeFirstResponder()
      removeArrangedSubview(textView)
      textView.removeFromSuperview()
      return true
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
    if textView === firstMessageTextView {
      messageTextViewHasPlaceholder = false
    }
    textView.text = nil
    textView.textColor = .yg.gray7
  }
  
  private func configurePlaceholder(of textView: UITextView) {
    if textView.text.isEmpty {
      if textView === titleTextView {
        textView.textColor = .yg.gray1
        textView.text = "제목"
      } else if textView === firstMessageTextView,
                lastView === firstMessageTextView {
        textView.textColor = .yg.gray1
        textView.text = "이번 여행에 대한 나의 후기를\n자유롭게 작성해보세요. :)"
        messageTextViewHasPlaceholder = true
        adjustHeight(of: textView)
      }
    }
  }
  
  /// textView text와 알맞은 height로 autoLayout을 update합니다.
  private func adjustHeight(of textView: UITextView) {
    let estimatedHeight = textView.sizeThatFits(
      CGSize(width: textView.frame.width, height: CGFloat.infinity)
    ).height
    
    if let previousHeight = textViewPreviousHeight[textView], previousHeight != estimatedHeight {
      textView.snp.updateConstraints {
        $0.height.equalTo(estimatedHeight)
      }
      textViewPreviousHeight[textView] = estimatedHeight
    } else if textViewPreviousHeight[textView] == nil {
      textViewPreviousHeight[textView] = estimatedHeight
    }
  }
  
  private func setupLastView(lastView: UIView) {
    addArrangedSubview(lastView)
    if lastView is UITextView {
      lastView.snp.makeConstraints {
        $0.height.equalTo(40)
      }
    } else if lastView is UIImageView {
      lastView.snp.makeConstraints {
        $0.height.equalTo(100)
      }
    }
    lastView.layoutIfNeeded()
    shouldScrollToLastView = true
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
  
  private func configure() {
    axis = .vertical
    distribution = .fill
    spacing = 8
    alignment = .fill
  }
}

// MARK: - Helpers
extension ReviewWritingContentView {
  /// imageView를 생성해서 stackView 계층에 추가합니다.
  func addImageView() {
    let imageView = PictureImageView(imageName: "tempProfile1").set {
      $0.delegate = self
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
      $0.addGestureRecognizer(tapGesture)
    }
    setupLastView(lastView: imageView)
  }
  
  /// 스크롤뷰 터치 시 lastView의 종류에 따라 contentOffsetY를 관리합니다.
  func manageContentOffsetYByLastView() {
    if let textView = lastView as? UITextView {
      moveCursorToLastPosition(at: textView)
    } else if lastView is UIImageView {
      let newTextView = createNewTextView()
      setupLastView(lastView: newTextView)
      self.setNeedsLayout()
      if let keyboardHeight = scrollValue.keyboardHeight,
         let bottomViewHeight = scrollValue.bottomViewHeight {
        self.delegate?.changeContentInset(
          bottomEdge: keyboardHeight - bottomViewHeight + scrollValue.spacingFromCursorBoundaryToKeyboard
        )
      }
    }
    lastView?.becomeFirstResponder()
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
  
  func hideMessageTextView() {
    firstMessageTextView.isHidden = true
    firstMessageTextView.alpha = 0
  }

  func extractContentData() -> ReviewWritingContentViewInfo {
    var model = ReviewWritingContentViewInfo()
    guard !messageTextViewHasPlaceholder else { return model }
    
    for i in firstContentIndex..<arrangedSubviews.count {
      let subview = arrangedSubviews[i]
      if let text = (subview as? UITextView)?.text,
         !firstMessageTextView.isHidden {
        let delimiter = delimiter.getDelimiter()
        model.text += text + delimiter
        model.isTextIndex.append("1")
      } else if let imageData = (subview as? UIImageView)?.image?.jpegData(compressionQuality: 0.5) {
        model.imageDataList.append(imageData)
        model.isTextIndex.append("0")
      }
    }
    return model
  }
}
// MARK: - PictureImageViewDelegate
extension ReviewWritingContentView: PictureImageViewDelegate {
  func didTapDeleteButton(_ sender: UIButton) {
    guard let imageView = sender.superview as? PictureImageView else { return }
    if lastView === imageView,
       let imageViewIndex = arrangedSubviews.firstIndex(of: imageView),
       let firstMessageTextViewIndex = arrangedSubviews.firstIndex(of: firstMessageTextView),
       firstMessageTextViewIndex == imageViewIndex - 1 {
      firstMessageTextView.isHidden = false
      UIView.animate(withDuration: 0.3) {
        self.firstMessageTextView.alpha = 1
      }
    }
    
    removeArrangedSubview(imageView)
    imageView.removeFromSuperview()
  }
}

// MARK: - Actions
extension ReviewWritingContentView {
  @objc private func didTapImageView(_ imageView: UIImageView) {
    imageViewUpdated?(imageView)
  }
}

//
//  ReviewWritingContentView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import SnapKit

final class ReviewWritingContentView: UIView {
  // MARK: - Properties
  private lazy var titleTextView: UITextView = .init().set {
    $0.text = "제목"
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
  private var imageViewList = [UIImageView]()
  private var lastViewBottomConstraint: ConstraintMakerEditable?
  private lazy var lastView: UIView = messageTextView
  private var shouldScrollToLastView = false
  var scrollToLastView: (() -> Void)?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if shouldScrollToLastView {
      scrollToLastView?()
      shouldScrollToLastView = false
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
    messageTextView.snp.makeConstraints {
      $0.top.equalTo(boundaryLineView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      self.lastViewBottomConstraint = $0.bottom.equalToSuperview().inset(40)
      $0.height.equalTo(estimatedHeight)
    }
  }
}

// MARK: - UITextViewDelegate
extension ReviewWritingContentView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
      adjustHeight(of: textView)
      
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
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView === titleTextView {
      erasePlaceholder(of: textView)
    } else if textView === messageTextView {
      erasePlaceholder(of: textView)
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    // FIXME: - 타이핑 했다가 글을 전부 지우고 resignResponder를 할 때, adjustHeight(of:)함수 호출로 인해 텍스트 잘림 현상 해결하기
    configurePlaceholder(of: textView)
  }
}

// MARK: - Private Helpers
extension ReviewWritingContentView {
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
  
  private func adjustHeight(of textView: UITextView) {
    let estimatedHeight = textView.sizeThatFits(
      CGSize(width: textView.frame.width, height: CGFloat.infinity)
    ).height
    textView.snp.updateConstraints {
      $0.height.equalTo(estimatedHeight)
    }
    shouldScrollToLastView = true
  }
  
  private func addLastView(lastView view: UIView) {
    // 제약조건 재설정 방식
    // 1. lastView의 bottom과 superView의 bottom을 제거
    // 2. lastView의 bottom과 view의 top 제약조건
    // 3. view의 bottom과 superView의 bottom 제약 조건
      // - 이때 view의 bottom과 superView의 bottom간의 constraints를 저장
    // 4. view를 lastView로 갱신
    
    lastViewBottomConstraint?.constraint.deactivate()
    addSubview(view)
    view.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(lastView.snp.bottom).offset(10)
      lastViewBottomConstraint = $0.bottom.equalToSuperview().inset(40)
    }
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
  
  private func moveCursorPosition(textView: UITextView) {
    // 누른 텍스트 뷰의 마지막 문자에 커서 이동
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
    let imageView = UIImageView()
    imageView.image = UIImage(named: "tempProfile1")
    imageViewList.append(imageView)
    addLastView(lastView: imageView)
  }
  
  func manageTextViewDisplay() {
    // lastView가 textView인 경우, 해당 textView 포커싱
    // lastView가 imageView인 경우, imageView 밑에 새로운 textView를 제약조건을 통해 추가
    if let textView = lastView as? UITextView {
      textView.becomeFirstResponder()
      moveCursorPosition(textView: textView)
    } else if lastView is UIImageView {
      let newTextView = createNewTextView()
      addLastView(lastView: newTextView)
      newTextView.becomeFirstResponder()
    }
  }
}

// 버튼 클릭 시, 사진 추가
// textView 아래에 이미지 추가(오토레이아웃)
// 이미지는 1~20개 추가 가능
// 맨 마지막 이미지 아래에 textView 추가

// CASE: 키보드가 왔을 때
// 키보드가 contentView의 lastView + padding을 가리는 경우
  // - scrollView의 contentOffset을 조절해서 contentView를 보이게 한다.
  // contentOffset 조절 방법:
    //
// 키보드가 contentView의 lastView + padding을 가리지 않는 경우
  // - 그냥 놔둔다.

// TODO: - messageTextView가 아닌 textView인 경우, textView가 비어있을때 키보드로 문자 삭제키를 누를 경우, textView를 제거
  //  오토레이아웃 삭제..
// TODO: - imageView 추가 시, LastView가 messageTextView인 경우, 미리 messageTextView 오토레이아웃 제거하기

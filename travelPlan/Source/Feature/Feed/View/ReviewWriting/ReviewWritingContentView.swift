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
    $0.font = .init(pretendard: .bold_700(fontSize: 22))
    $0.textColor = .yg.gray1
    $0.isScrollEnabled = false
    $0.delegate = self
  }
  
  private lazy var messageTextView: UITextView = .init().set {
    $0.text = "이번 여행에 대한 나의 후기를 자유롭게 작성해보세요. :)"
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
  private var lastView: UIView!
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////    super.touchesBegan(touches, with: event)
//    
//    self.subviews.forEach { subView in
//      if let textView = subView as? UITextView {
//        textView.resignFirstResponder()
//      }
//    }
//  }
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
      $0.leading.trailing.equalToSuperview().inset(17)
      $0.height.equalTo(1)
    }
    
    self.lastView = messageTextView
    messageTextView.snp.makeConstraints {
      $0.top.equalTo(boundaryLineView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      self.lastViewBottomConstraint = $0.bottom.equalToSuperview()
      $0.height.equalTo(100)
    }
  }
}

// MARK: - UITextViewDelegate
extension ReviewWritingContentView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
      adjustHeight(of: textView)
    
    if titleTextView.text.count > 60 {
      // TODO: - 최대 글자 수를 넘으면 글자에 대한 헬퍼 뷰를 띄워야합니다.
      titleTextView.text.removeLast()
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
    configurePlaceholder(of: titleTextView)
    configurePlaceholder(of: messageTextView)
  }
}

// MARK: - Private Helpers
extension ReviewWritingContentView {
  private func erasePlaceholder(of textView: UITextView) {
    guard textView.textColor == .yg.gray1 else { return }
    textView.text = nil
    textView.textColor = .yg.gray7
  }
  
  private func configurePlaceholder(of textView: UITextView) {
    if textView.text.isEmpty {
      if textView === titleTextView {
        textView.text = "제목"
      } else if textView === messageTextView {
        textView.text = "이번 여행에 대한 나의 후기를 자유롭게 작성해보세요. :)"
      }
      
      textView.textColor = .yg.gray1
    }
  }
  
  private func adjustHeight(of textView: UITextView) {
    let size = CGSize(width: textView.frame.width, height: CGFloat.infinity)
    let newSize = textView.sizeThatFits(size)
    textView.snp.updateConstraints {
      $0.height.equalTo(newSize.height)
    }
  }
  
  private func addLastView(view: UIView) {
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
      lastViewBottomConstraint = $0.bottom.equalToSuperview()
    }
    
    if view is UITextView {
      view.snp.makeConstraints {
        $0.height.equalTo(40)
      }
    } else if view is UIImageView {
      view.snp.makeConstraints {
        $0.height.equalTo(100)
      }
    }
    
    lastView = view
  }
}

// MARK: - Helpers
extension ReviewWritingContentView {
  func addImageView() {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "tempProfile1")
    imageViewList.append(imageView)
    addLastView(view: imageView)
  }
  
  func manageTextViewDisplay() {
    if let textView = lastView as? UITextView { // lastView가 textView인 경우, 해당 textView 포커싱
      textView.becomeFirstResponder()
      
      if let text = textView.text { // 누른 텍스트 뷰의 마지막 문자에 커서 이동
        let endIndex = text.endIndex
        if let cursorPosition = textView.position(
          from: textView.beginningOfDocument,
          offset: text.distance(from: text.startIndex, to: endIndex)
        ) {
          textView.selectedTextRange = textView.textRange(from: cursorPosition, to: cursorPosition)
        }
      }
    } else if lastView is UIImageView { // lastView가 imageView인 경우, imageView 밑에 새로운 textView를 제약조건을 통해 추가
      
      let newTextView = UITextView().set {
        $0.font = .init(pretendard: .regular_400(fontSize: 16))
        $0.textColor = .yg.gray6
        $0.isScrollEnabled = false
        $0.delegate = self
      }
      addLastView(view: newTextView)
    }
  }
}

// lastCostraints의 bottom은 현재 추가된 constraints의 top과 오토레이아웃 설정

// 버튼 클릭 시, 사진 추가
// textView 아래에 이미지 추가(오토레이아웃)
// 이미지는 1~20개 추가 가능
// 맨 마지막 이미지 아래에 textView 추가

// 마지막이 텍스트인지 이미지인지 파악
// - var isLastComponentImage: Bool
// - true인 경우: 이미지 밑에 textView 추가
// - false인 경우: return


// 제약조건 재설정 방식
// 1. lastView의 bottom과 superView의 bottom을 제거
// 2. lastView의 bottom과 newView의 top 제약조건
// 3. newView의 bottom과 superView의 bottom 제약 조건
// 4. newView를 lastView로 갱신

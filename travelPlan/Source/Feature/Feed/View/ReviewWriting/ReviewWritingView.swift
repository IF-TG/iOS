//
//  ReviewWritingView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/4/23.
//

import UIKit
import SnapKit

final class ReviewWritingView: UIView {
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
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    titleTextView.resignFirstResponder()
  }
}

// MARK: - LayoutSupport
extension ReviewWritingView: LayoutSupport {
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
    
    messageTextView.snp.makeConstraints {
      $0.top.equalTo(boundaryLineView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
//      $0.height.equalTo(100)
    }
  }
}

extension ReviewWritingView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if textView === titleTextView {
      adjustHeight(of: textView)
    } else if textView === messageTextView {
      adjustHeight(of: textView)
    }
    
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
    let tapReturnKey = text == "\n"
    
    if tapReturnKey {
      return false
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
extension ReviewWritingView {
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
    let size = CGSize(width: textView.frame.width, height: self.frame.height)
    let newSize = textView.sizeThatFits(size)
    textView.snp.updateConstraints {
      $0.height.equalTo(newSize.height)
    }
  }
}

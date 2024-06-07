//
//  PostOptionViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 6/7/24.
//

import Combine
import Foundation

protocol PostOptionViewModelPageDelegate: AnyObject {
  func showPostOption()
  func showPostReportResult()
  func showAlertForError(with descrption: String, completion: (() -> Void)?)
}

struct PostOptionViewModelActions {
  let showPostOption: (((PostOption) -> Void)?) -> Void
  
  let showPostReport: (((PostReportType) -> Void)?) -> Void
  let showPostReportResult: (PostOption) -> Void
  
  /// 이 글 그만보기를 누를 경우 포스트 저자를 차단합니다.
  let showPostAuthorBlock: (String, ((Bool) -> Void)?) -> Void
  
  let showAlertForError: (String, (() -> Void)?) -> Void
}

struct PostOptionViewModelInput { }

@frozen enum PostOptionViewModelState {
  case networkProcessing
  case completeReport
  /// 이 글 그만보기를 누른 경우
  case completeUserBlock
  
  case unexpectedError(description: String)
}

protocol PostOptionViewModelable: ViewModelable
where Input == PostOptionViewModelInput,
      State == PostOptionViewModelState,
      Output == AnyPublisher<State, Never> { }

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
  typealias Completion = () -> Void
  let showPostOption: (((PostOption) -> Void)?) -> Void
  
  /// showPostOption -> 자신의 포스트인 경우 호출해야 합니다.
  let showPostOptionForMine: (Completion?) -> Void
  
  let showPostReport: (((PostReportType) -> Void)?) -> Void
  let showPostReportResult: (PostOption) -> Void
  
  /// 이 글 그만보기를 누를 경우 포스트 저자를 차단합니다.
  let showPostAuthorBlock: (String, ((Bool) -> Void)?) -> Void
  
  let showAlertForError: (String, (() -> Void)?) -> Void
}

struct PostOptionViewModelInput {
  /// 피드 상세 화면이 아닌 피드 화면에서는 특정 피드 데이터를 받은 후에 포스트 옵션을 실행해야합니다.
  let postInfoSubject: PassthroughSubject<PostOptionInfo, Never>

  init() {
    postInfoSubject = .init()
  }
}

@frozen enum PostOptionViewModelState {
  case none
  
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

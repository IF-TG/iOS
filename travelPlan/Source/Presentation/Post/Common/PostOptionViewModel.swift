//
//  PostOptionViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 6/7/24.
//

import Combine
import Foundation

/// 이 객체에서는 신고하기, 차단하기 로직 담당 서버에 반영된 경우 알림창 담당 completion을 노티피케이션으로 전송합니다.
final class PostOptionViewModel {
  // MARK: - Dependencies
  private let ownerRepository: LoggedInUserRepository
  
  private let userBlockUseCase: UserBlockUseCase
  
  // MARK: - Properties
  private let actions: PostOptionViewModelActions
  
  private var postOption: PostOption? = .none
  
  // TODO: - PostAuthor가 존재하지 않는 경우 유니버셜 링크를 통해 이동했기 때문입니다. 이때는 PostDetailVM에서 받은 후에 노티를 통해
  // 옵션에서 받아야 합니다.때까지 대기해야 합니다.
  private var dataSource: PostOptionViewModelInfo
  
  // MARK: - Combine Properties
  private let postReportNotifier = PassthroughSubject<PostReportType, Never>()
  
  private let postReportHandler = PassthroughSubject<PostReportType, Never>()
  
  private let postAuthorBlockNotifier = PassthroughSubject<Void, Never>()
  
  private let postAuthorBlockHandler = PassthroughSubject<Void, Never>()
  
  // MARK: - Lifecycle
  // TODO: - postAuthorId가 존재하지 않을 수있음. 이 경우는 유니버셜 링크를 타고 들어오는 경우이고, 이때 메인에서 fetch하면 노티로 여기서 postId,
  // 저자 닉네임, 저자 이름 받도록 구현해야함.
  
  // postId가 nil인 경우는 피드에서 사용됩니다.
  init(
    dataSource: PostOptionViewModelInfo,
    actions: PostOptionViewModelActions,
    ownerRepository: LoggedInUserRepository,
    userBlockUseCase: UserBlockUseCase
  ) {
    self.dataSource = dataSource
    self.actions = actions
    self.ownerRepository = ownerRepository
    self.userBlockUseCase = userBlockUseCase
  }
}

// MARK: - PostOptionViewModelPageDelegate
extension PostOptionViewModel: PostOptionViewModelPageDelegate {
  /// 해당 포스트가 타인일 경우 포소트 신고하기, 포스트 차단하기 액션 시트창이 보여집니다.
  ///   자기자신의 포스트일 경우 공유하기 액션 시트창이 보여집니다.
  ///
  ///   Int32(ownerRepository.id!)! == dataSource.postAuthorId
  func showPostOption() {
    print("hihi")
    // TODO: - id Int32로 수정해야합니다.
    if let postId = dataSource.postId,
       let postTitle = dataSource.postTitle {
      actions.showPostOptionForMine {
        PostNotificationManager.shared.notifyUserWantToSharePost(postId: postId, postTitle: postTitle)
      }
      return
    }
    print("hihihi")
    actions.showPostOption { [weak self] optionState in
      guard let postAuthorNickname = self?.dataSource.postAuthorNickname else {
        self?.actions.showAlertForError("여행 후기 포스트 저자의 식별자가 유효하지 않습니다.", nil)
        return
      }
      self?.postOption = optionState
      switch optionState {
      case .postBlock:
        self?.actions.showPostAuthorBlock(postAuthorNickname) { wannaBlock in
          if wannaBlock {
            self?.postAuthorBlockNotifier.send()
          } else {
            self?.postOption = nil
          }
        }
      case .postReport:
        self?.actions.showPostReport { reportType in
          if reportType == .stopRequest {
            self?.postOption = nil
            return
          }
          self?.postReportNotifier.send(reportType)
        }
      }
    }
  }
  
  func showPostReportResult() {
    guard let postOption else {
      actions.showAlertForError("앱 내부 문제가 발생됬습니다.", nil)
      return
    }
    
    /// 차단 아이콘 보여주면서 노티피케이션 발송됩니다.
    /// postOptionLocation이 postDetail인 경우 포스트 상세 화면에서 차단 아이콘 -> 포스트 상세 화면 에서 뒤로가기, -> 포스트 피드에서 해당 포스트 제거가 됩니다.
    /// postOptionLocation이 postSummary인 경우 포스트 차단 아이콘 -> 포스트 피드에서 해당 포스트가 제거됩니다.
    actions.showPostReportResult(postOption)
    guard let postId = dataSource.postId else {
      self.postOption = nil
      actions.showAlertForError("포스트 식별이 불가능합니다. 개발자팀에게 문의 주시면 감사합니다.", nil)
      return
    }
    if postOption == .postBlock {
      PostNotificationManager.shared.notifyPostHasBlocked(
        postId: postId,
        postOptionLocation: dataSource.postOptionLocation)
    }
    self.postOption = nil
  }
  
  func showAlertForError(with descrption: String, completion: (() -> Void)?) {
    actions.showAlertForError(descrption, completion)
  }
}

// MARK: - PostOptionViewModelable
extension PostOptionViewModel: PostOptionViewModelable {
  func transform(_ input: PostOptionViewModelInput) -> Output {
    return Publishers.MergeMany([
      postInfoSubjectStream(input),
      postReportNotifierStream(),
      postAuthorBlockNotifierStream(),
      postReportHandlerStream(),
      postAuthorBlockHandlerStream()
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Stream Helpers
private extension PostOptionViewModel {
  /// 포스트 섬네일 화면에서 사용됩니다.
  /// 포스트 섬네일(서머리)화면은 여러 포스트가 있고, 그중 특정한 포스트에 대한 정보는 포스트 옵션 버튼 클릭을 통해서만 얻을 수 있습니다.
  ///
  /// 또한 포스트 상세 화면에서 포스트를 수정한 경우(제목을 수정한 경우)에도 이 input을 통해 새로 변경된 데이터들을 PostDetailVM에서 보내야 합니다.
  func postInfoSubjectStream(_ input: Input) -> Output {
    return input.postInfoSubject.map { [weak self] postOptionInfo in
      self?.dataSource.postId = postOptionInfo.postId
      self?.dataSource.postAuthorId = postOptionInfo.authorId
      self?.dataSource.postAuthorNickname = postOptionInfo.authorName
      self?.dataSource.postTitle = postOptionInfo.postTitle
      return .none
    }.eraseToAnyPublisher()
  }
  func postReportNotifierStream() -> Output {
    return postReportNotifier
      .map { reportType -> State in
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          self?.postReportHandler.send(reportType)
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func postAuthorBlockNotifierStream() -> Output {
    return postAuthorBlockNotifier
      .map { _ -> State in
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          self?.postAuthorBlockHandler.send()
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func postReportHandlerStream() -> Output {
    return postReportHandler.flatMap { responseType in
      // TODO: - 포스트 신고하기 api 없음.
      print(responseType)
      // 참고로 지금시점 네트워크 프로세싱 중.
      // 여기서 이제 레포지토리로 리포트 사유를 같이 보낸 후에 성공 아님 실패 결과 반환하면 됩 니다.
      // 신고 완료 후
      // return postResult 호출해야합니다. 그 곳에서 postDetailOption을 nil 처리합니다.
      //      switch responseType {
      //      case .inaccurateInformation:
      //
      //      case .personalInformationExposure:
      //
      //      case .spamOrRepetitiveContent:
      //
      //      case .vulgarOrAbusiveLanguage:
      //
      //      case .obsceneContent:
      //
      //      case .harmfulToMinors:
      //
      //      case .stopRequest:
      //
      //      }
      // MARK: - completeReport 보내기.
      return Just(State.unexpectedError(description: "포스트 신고하기 api가 없습니다."))
        .eraseToAnyPublisher()
      
    }.eraseToAnyPublisher()
  }

  func postAuthorBlockHandlerStream() -> Output {
    return postAuthorBlockHandler.flatMap { [weak self] _ -> Output in
      guard let self else {
        return Just(State.unexpectedError(description: "앱 내부 에러가 발생됬습니다.")).eraseToAnyPublisher()
      }
      
      guard let postAuthorId = dataSource.postAuthorId else {
        return Just(.unexpectedError(description: "여행 후기 포스트 저자의 식별자가 유효하지 않습니다.")).eraseToAnyPublisher()
      }
      
      return userBlockUseCase.blockUser(with: String(postAuthorId))
        .map { [weak self, postAuthorId] _ in
          self?.ownerRepository.addBlockedUser(with: String(postAuthorId))
          return .completeUserBlock
        }
        .catch { error in
          return Just(State.unexpectedError(description: error.localizedDescription)).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
}

//
//  NoticeViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import Combine
import Foundation

final class NoticeViewModel {
  // MARK: - Dependencies
  private let noticeUseCase: NoticeUseCase
  
  // MARK: - Properties
  private var notices: [NoticeCellInfo] = []
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(noticeUseCase: NoticeUseCase) {
    self.noticeUseCase = noticeUseCase
    bind()
  }
}

// MARK: - NoticeViewModelable
extension NoticeViewModel: NoticeViewModelable {
  func transform(_ input: NoticeViewInput) -> AnyPublisher<NoticeViewState, Never> {
    return Publishers.MergeMany([
      viewDidLoadChains(input),
      didTapNoticeChains(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Input chains
private extension NoticeViewModel {
  func viewDidLoadChains(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ in
        self?.noticeUseCase.fetchNotices()
        return .none
      }.eraseToAnyPublisher()
  }
  
  func didTapNoticeChains(_ input: Input) -> Output {
    return input.didTapNotice
      .map { [weak self] in
        self?.notices[$0.indexPath.row].isExpended = $0.isExpected
        return .none
      }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension NoticeViewModel {
  func bind() {
    noticeUseCase.noticeEntities
      .receive(on: DispatchQueue.main)
      .sink { [weak self] noticeEntities in
        self?.notices = noticeEntities.map {
          .init(title: $0.title, date: $0.date, details: $0.details, isExpended: false)
        }
      }.store(in: &subscriptions)
  }
}

// MARK: - NoticeViewAdapterDataSource
extension NoticeViewModel: NoticeViewAdapterDataSource {
  var numberOfItems: Int {
    notices.count
  }
  
  func getItem(_ indexPath: IndexPath) -> NoticeCellInfo {
    return notices[indexPath.row]
  }
}

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

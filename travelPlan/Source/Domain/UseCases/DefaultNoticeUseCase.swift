//
//  DefaultNoticeUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine
import Foundation

final class DefaultNoticeUseCase: NoticeUseCase {
  var noticeEntities: CurrentValueSubject<[NoticeEntity], Never> = .init([])
  
  func fetchNotices() {
    
  }
}

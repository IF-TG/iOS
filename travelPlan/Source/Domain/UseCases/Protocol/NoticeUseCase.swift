//
//  NoticeUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine

protocol NoticeUseCase {
  var noticeEntities: CurrentValueSubject<[NoticeEntity], Never> { get }
  
  func fetchNotices()
}

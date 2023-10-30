//
//  NoticeViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Foundation

protocol NoticeViewAdapterDelegate: AnyObject {
  func noticeViewAdapter(
    _ noticeViewAdapter: NoticeViewAdapter,
    didSelectRowAt indexPath: IndexPath,
    isExpended: Bool)
}

//
//  EmptyStateBasedContentViewCheckable.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import Combine

protocol EmptyStateBasedContentViewCheckable: AnyObject {
  var hasItem: CurrentValueSubject<Bool, Never> { get }
  var isShowingFirstAnimation: Bool { get }
}

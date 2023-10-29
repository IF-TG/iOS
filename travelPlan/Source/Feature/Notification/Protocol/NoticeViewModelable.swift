//
//  NoticeViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Combine

protocol NoticeViewModelable: ViewModelable
where Input == NoticeViewInput,
      State == NoticeViewState,
      Output == AnyPublisher<State, Never>{ }

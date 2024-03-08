//
//  FeedPostViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Combine

protocol FeedPostViewModelable: ViewModelable
where Input == FeedPostViewControllerInput,
      State == FeedPostViewControllerState,
      Output == AnyPublisher<State, Never> { }

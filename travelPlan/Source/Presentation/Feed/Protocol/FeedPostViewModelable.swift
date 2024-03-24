//
//  FeedPostViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Combine

protocol FeedPostViewModelable: ViewModelable
where Input == FeedPostViewModel.Input,
      State == FeedPostViewModel.State,
      Output == AnyPublisher<State, Never> { }

//
//  FeedViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/17/23.
//

import Foundation

protocol FeedViewModelable: ViewModelable
where Input == FeedViewModel.Input,
      State == FeedViewModel.State,
      Output == AnyPublisher<State, FeedViewModel.ErrorType> { }

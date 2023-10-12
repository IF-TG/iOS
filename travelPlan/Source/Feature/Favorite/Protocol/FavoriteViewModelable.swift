//
//  FavoriteViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/9/23.
//

import Combine

protocol FavoriteViewModelable: ViewModelable
where Input == FavoriteViewInput,
      State == FavoriteViewState,
      Output == AnyPublisher<State, Never> { }

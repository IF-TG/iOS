//
//  MyInformationViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Combine

protocol MyInformationViewModelable: ViewModelable
where Input == MyInformationViewModel.Input,
      State == MyInformationViewModel.State,
      Output == AnyPublisher<State, MyInforMationViewError> { }

//
//  DestinationDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/2/24.
//

import Foundation
import Combine

protocol DestinationDetailViewModelDataSourceable {
  var dataSource: [DestinationDetailSection] { get }
}

protocol DestinationDetailViewModel: ViewModelable, DestinationDetailViewModelDataSourceable
where Input == DestinationDetailViewModelInput,
      State == DestinationDetailViewModelState,
      Output == AnyPublisher<State, Never> { }

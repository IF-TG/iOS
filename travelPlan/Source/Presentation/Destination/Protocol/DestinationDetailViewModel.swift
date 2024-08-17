//
//  DestinationDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/2/24.
//

import Foundation
import Combine

typealias DestinationDetailViewModel = DestinationDetailViewModelable 
& DestinationDetailViewModelDataSourceable
& DestinationDetailViewModelPageDelegate

protocol DestinationDetailViewModelable: ViewModelable
where Input == DestinationDetailViewModelInput,
      State == DestinationDetailViewModelState,
      Output == AnyPublisher<State, Never> { }

protocol DestinationDetailViewModelDataSourceable {
  func numberOfSections() -> Int
  func numberOfItemsInSection(sectionIndex: Int) -> Int
  func destinationDetailSection(sectionIndex: Int) -> DestinationDetailSection
}

protocol DestinationDetailViewModelPageDelegate: AnyObject {
  func pop()
}

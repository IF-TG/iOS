//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/7/24.
//

import Foundation

protocol SearchViewModel: ViewModelable, SearchViewModelDataSourceable
where Input == SearchViewModelInput,
      State == SearchViewModelState {}

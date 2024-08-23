//
//  ReviewWritingViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/23/24.
//

import Foundation
import Combine

typealias ReviewWritingViewModel = ReviewWritingViewModelable

protocol ReviewWritingViewModelable: ViewModelable
where Input == ReviewWritingViewModelInput,
      State == ReviewWritingViewModelState {}

// TODO: - DataSourceable

// TODO: - PageDelegate

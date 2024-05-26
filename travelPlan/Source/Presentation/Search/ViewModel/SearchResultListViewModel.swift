//
//  SearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 5/23/24.
//

import Foundation
import Combine

enum SearchResultSectionModel {
  case category([String])
  case destination([TravelDestinationInfo])
}

protocol SearchResultDataSourceable {
  var dataSource: [SearchResultSectionModel] { get }
}

protocol SearchResultListViewModel: ViewModelable, SearchResultDataSourceable
where Input == SearchResultListViewModelInput,
      State == SearchResultListViewModelState { }

struct SearchResultListViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<IndexPath, Never> = .init()
}

enum SearchResultListViewModelState {
  case none
  case reloadData
}

final class DefaultSearchResultListViewModel: SearchResultListViewModel {
  // MARK: - Properties
  var dataSource = [SearchResultSectionModel]()
  
  // MARK: - LifeCycle
  init() {
    
  }
  
  // MARK: - Transform
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapStarButtonStream(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultSearchResultListViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
          self?.dataSource.append(.category(["전체"] + TourType.allCases.map { $0.toString }))
          
          let travelInfos = [
            TravelDestinationInfo(place: "타이틀1", category: TourType.accommodation.toString, location: "강릉",
                                  isButtonSelected: true, imageData: TempSource.imageData, id: 123),
            TravelDestinationInfo(place: "타이틀2", category: TourType.attraction.toString, location: "인천",
                                  isButtonSelected: false, imageData: TempSource.imageData, id: 234),
            TravelDestinationInfo(place: "타이틀3", category: TourType.cultureFacility.toString, location: "대전",
                                  isButtonSelected: false, imageData: TempSource.imageData, id: 345),
            TravelDestinationInfo(place: "타이틀4", category: TourType.leports.toString, location: "전주",
                                  isButtonSelected: true, imageData: TempSource.imageData, id: 456),
            TravelDestinationInfo(place: "타이틀4", category: TourType.leports.toString, location: "전주",
                                  isButtonSelected: true, imageData: TempSource.imageData, id: 456),
            TravelDestinationInfo(place: "타이틀4", category: TourType.leports.toString, location: "전주",
                                  isButtonSelected: true, imageData: TempSource.imageData, id: 456),
            TravelDestinationInfo(place: "타이틀4", category: TourType.leports.toString, location: "전주",
                                  isButtonSelected: true, imageData: TempSource.imageData, id: 456),
          ]
          self?.dataSource.append(.destination(travelInfos))
        }
        return State.reloadData
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .map { _ in State.none }
      .eraseToAnyPublisher()
  }
}

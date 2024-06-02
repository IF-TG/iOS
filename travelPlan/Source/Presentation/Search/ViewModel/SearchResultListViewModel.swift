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
  case firstReloadData
  case reloadItems(IndexPath)
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
      .flatMap { [weak self] _ in
        return Future { promise in
          DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
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
                                    isButtonSelected: true, imageData: TempSource.imageData, id: 456)
            ]
            self?.dataSource.append(.destination(travelInfos))
            promise(.success(State.firstReloadData))
          }
        }.eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .flatMap { [weak self] indexPath in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
          return self.saveButtonState(indexPath: indexPath)
      }
      .eraseToAnyPublisher()
  }
  
  private func saveButtonState(indexPath: IndexPath) -> AnyPublisher<State, Never> {
    // TODO: - id값을 통해 서버에 데이터 저장을 요청하고, 성공 시 하트버튼의 색깔을 변경해야 합니다.
    return Future { [weak self] promise in
      // fake network. 추후 네트워크 통신 이후, promise로 값을 방출해야 합니다.
      DispatchQueue.global().asyncAfter(wallDeadline: .now() + 0.5) {
        DispatchQueue.main.async {
          print("DEBUG: FakeNetwork 통신 성공!")
          guard let self = self else {
            promise(.success(.none))
            return
          }
          
          if case .destination(var infos) = self.dataSource[indexPath.section] {
            infos[indexPath.item].isButtonSelected.toggle()
            self.dataSource[indexPath.section] = .destination(infos)
            
            promise(.success(.reloadItems(indexPath)))
          }
          promise(.success(.none))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

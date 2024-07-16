//
//  SearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 5/23/24.
//

import Foundation
import Combine

protocol SearchResultListViewModelPageDelegate: AnyObject {
  func pop()
  func showDetail()
}

struct SearchResultListViewModelActions {
  let pop: () -> Void
  let showDetail: () -> Void
}

enum SearchResultSectionModel {
  case category([TravelDestinationCategoryInfo])
  case destination([TravelDestinationInfo])
}

protocol SearchResultDataSourceable {
  var dataSource: [SearchResultSectionModel] { get }
}

protocol SearchResultListViewModel: ViewModelable, SearchResultDataSourceable, SearchResultListViewModelPageDelegate
where Input == SearchResultListViewModelInput,
      State == SearchResultListViewModelState { }

struct SearchResultListViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let didTapStarButton: PassthroughSubject<(IndexPath, Int), Never> = .init()
  let didTapSearchButton: PassthroughSubject<String, Never> = .init()
  let didChangeSearchTextField: AnyPublisher<String, Never>
  let didTapCategoryItem: PassthroughSubject<(Int, Int), Never> = .init()
}

enum SearchResultListViewModelState {
  case none
  case firstReloadData(String)
  case reloadSection(Int)
  case reloadItems(IndexPath)
  case changeButtonColor(Bool)
}

final class DefaultSearchResultListViewModel: SearchResultListViewModel {
  // MARK: - Dependencies
  private let actions: SearchResultListViewModelActions
  private let useCase: any DestinationSearchResultUseCase
  private var searchKeyword: String
  
  // MARK: - Properties
  var dataSource = [SearchResultSectionModel]()
  private var originalDestinationInfos = [TravelDestinationInfo]()
  
  // MARK: - LifeCycle
  init(
    actions: SearchResultListViewModelActions,
    searchKeyword: String,
    useCase: any DestinationSearchResultUseCase
  ) {
    self.actions = actions
    self.useCase = useCase
    self.searchKeyword = searchKeyword
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Transform
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    Publishers.MergeMany(
      viewDidLoadStream(input),
      didTapStarButtonStream(input),
      didTapDetailStream(input),
      didChangeSearchTextFieldStream(input),
      didTapSearchButtonStream(input),
      didTapCategoryItem(input)
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultSearchResultListViewModel {
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad.flatMap { [weak self] _ in
      guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
      
      return self.useCase.fetchDestinationList(keyword: searchKeyword, page: nil, perPage: nil)
        .map { (thumbnailDestinations: [ThumbnailDestination]) in
          self.dataSource.append(.category(
            [TravelDestinationCategoryInfo(contentTypeId: nil, title: "전체")] +
            TourType.allCases.map { TravelDestinationCategoryInfo(contentTypeId: $0.rawValue, title: $0.toString) }
          ))
          
          let travelDestinationInfos = thumbnailDestinations.map {
            TravelDestinationInfo(place: $0.title,
                                  contentTypeId: $0.id.contentTypeId,
                                  category: $0.category.largeCategory,
                                  location: $0.address,
                                  isButtonSelected: $0.isScraped,
                                  imageData: $0.thumbnailImageData,
                                  id: $0.id.id)
          }
          
          self.dataSource.append(.destination(travelDestinationInfos))
          return State.firstReloadData(self.searchKeyword)
        }
        .catch { _ in return Just(State.none).eraseToAnyPublisher() }
        .eraseToAnyPublisher()
    }
      .eraseToAnyPublisher()
    
    
    
    
//    return input.viewDidLoad
//      .flatMap { [weak self] _ in
//        return Future { promise in
//          DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            self?.dataSource.append(.category(
//              [TravelDestinationCategoryInfo(categoryId: nil, title: "전체")] +
//              TourType.allCases.map { TravelDestinationCategoryInfo(categoryId: $0.rawValue, title: $0.toString) }
//            ))
//            
//            let travelInfos = [
//              TravelDestinationInfo(place: "숙박 mock", categoryId: TourType.accommodation.rawValue, 
//                                    category: TourType.accommodation.toString, location: "강릉",
//                                    isButtonSelected: true, imageData: TempSource.imageData, id: 1),
//              TravelDestinationInfo(place: "관광지 mock", categoryId: TourType.attraction.rawValue, 
//                                    category: TourType.attraction.toString, location: "인천",
//                                    isButtonSelected: false, imageData: TempSource.imageData, id: 2),
//              TravelDestinationInfo(place: "문화시설 mock", categoryId: TourType.cultureFacility.rawValue,
//                                    category: TourType.cultureFacility.toString, location: "대전",
//                                    isButtonSelected: false, imageData: TempSource.imageData, id: 3),
//              TravelDestinationInfo(place: "레포츠 mock", categoryId: TourType.leports.rawValue,
//                                    category: TourType.leports.toString, location: "전주",
//                                    isButtonSelected: true, imageData: TempSource.imageData, id: 4),
//              TravelDestinationInfo(place: "레포츠 mock2", categoryId: TourType.leports.rawValue,
//                                    category: TourType.leports.toString, location: "전주",
//                                    isButtonSelected: true, imageData: TempSource.imageData, id: 5),
//              TravelDestinationInfo(place: "레포츠 mock3", categoryId: TourType.leports.rawValue,
//                                    category: TourType.leports.toString, location: "전주",
//                                    isButtonSelected: true, imageData: TempSource.imageData, id: 6),
//              TravelDestinationInfo(place: "레포츠 mock4", categoryId: TourType.leports.rawValue,
//                                    category: TourType.leports.toString, location: "전주",
//                                    isButtonSelected: true, imageData: TempSource.imageData, id: 7)
//            ]
//            self?.originalDestinationInfos = travelInfos
//            self?.dataSource.append(.destination(travelInfos))
//            promise(.success(State.firstReloadData))
//          }
//        }.eraseToAnyPublisher()
//      }
//      .eraseToAnyPublisher()
  }
  
  private func didTapStarButtonStream(_ input: Input) -> Output {
    return input.didTapStarButton
      .flatMap { [weak self] indexPath, id in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        return self.saveButtonState(indexPath: indexPath, id: id)
      }
      .eraseToAnyPublisher()
  }
  
  private func saveButtonState(indexPath: IndexPath, id: Int) -> AnyPublisher<State, Never> {
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
            for (i, info) in self.originalDestinationInfos.enumerated()
            where self.originalDestinationInfos[i].id == id {
              self.originalDestinationInfos[i].isButtonSelected.toggle()
              break
            }
    
            self.dataSource[indexPath.section] = .destination(infos)
            
            promise(.success(.reloadItems(indexPath)))
          }
          promise(.success(.none))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  private func didTapDetailStream(_ input: Input) -> Output {
    // TODO: - 상세화면으로 이동해야합니다.
    return Just(State.none).eraseToAnyPublisher()
  }
  
  private func didChangeSearchTextFieldStream(_ input: Input) -> Output {
    return input.didChangeSearchTextField
      .map { [weak self] in
        State.changeButtonColor(self?.isValueChanged(text: $0) ?? false)
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapSearchButtonStream(_ input: Input) -> Output {
    // TODO: - text 키워드를 기반으로 서버에 다시 요청해야합니다.
    return input.didTapSearchButton
      .map { [weak self] text in
        print("search: \(text)")
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapCategoryItem(_ input: Input) -> Output {
    return input.didTapCategoryItem
      .map { [weak self] item, contentTypeId in
        if case .destination(let infos) = self?.dataSource[1] {
          guard let self = self else { return State.none }
          
          if item == .zero {
            self.dataSource[1] = .destination(originalDestinationInfos)
          } else {
            self.dataSource[1] = .destination(
              originalDestinationInfos.filter {
                $0.contentTypeId == contentTypeId
              }
            )
          }
          return State.reloadSection(1)
        }
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func isValueChanged(text: String) -> Bool {
    if text.count > 0 {
      return true
    } else { return false }
  }
}

// MARK: - SearchResultListViewModelPageDelegate
extension DefaultSearchResultListViewModel {
  func pop() {
    actions.pop()
  }
  
  func showDetail() {
    actions.showDetail()
  }
}

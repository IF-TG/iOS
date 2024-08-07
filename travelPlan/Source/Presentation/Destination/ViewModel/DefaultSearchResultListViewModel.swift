//
//  DefaultSearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 5/23/24.
//

import Foundation
import Combine

struct SearchResultListViewModelActions {
  let pop: () -> Void
  let showDestinationDetail: (DestinationIdEntity) -> Void
}

enum SearchResultSectionModel {
  case category([TravelDestinationCategoryInfo])
  case destination([TravelDestinationInfo])
}

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
    // TODO: - 네트워크 결과 보이기 전까지 인디케이터 작동시키기
    return input.viewDidLoad.flatMap { [weak self] _ in
      guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
      
      return self.useCase.fetchDestinationList(keyword: searchKeyword, page: nil, perPage: nil)
        .map { (thumbnailDestinations: [ThumbnailDestination]) -> SearchResultListViewModelState in
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
    // 클릭된 cell에서 destinationId를 가져와서 actions를 통해 destinationDetailCoordinator에게 id를 넘겨야 한다.!!!!!!
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
  
  func showDestinationDetailPage(id: Int, contentTypeId: Int) {
    let destinationId = DestinationIdEntity(id: id, contentTypeId: contentTypeId)
    actions.showDestinationDetail(destinationId)
  }
}

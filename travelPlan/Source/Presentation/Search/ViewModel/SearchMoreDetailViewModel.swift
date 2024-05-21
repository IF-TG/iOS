//
//  SearchMoreDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import Foundation
import Combine

final class SearchMoreDetailViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  struct Input {
    let viewDidLoad: PassthroughSubject<SearchSectionType, Never>
    let didSelectItem: PassthroughSubject<IndexPath, Never>
    
    init(viewDidLoad: PassthroughSubject<SearchSectionType, Never> = .init(),
         didSelectItem: PassthroughSubject<IndexPath, Never> = .init()
    ) {
      self.viewDidLoad = viewDidLoad
      self.didSelectItem = didSelectItem
    }
  }
  enum State {
    case setNavigationTitle(title: String?)
    case showDetail
  }
  enum ErrorType: Error {
    case none
    case unexpected
  }
  
  // MARK: - Properties
  /// festival, camping이 해당 프로퍼티를 공통으로 사용합니다.
//  private(set) var travelDestinationCellViewModels: [TravelDestinationCellViewModel]?
  private(set) var headerInfo: SearchDetailHeaderInfo?
  private(set) var itemInfos: [TravelDestinationItemInfo]?
}

// MARK: - ViewModelCase
extension SearchMoreDetailViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany(
      viewDidLoadStream(input),
      didSelecetItemStream(input)
    ).eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    input.viewDidLoad
      .map { [weak self] type in
        self?.fetchData(type: type)
        let title = self?.navigationTitle()
        return .setNavigationTitle(title: title)
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
  
  private func didSelecetItemStream(_ input: Input) -> Output {
    input.didSelectItem
      .map { [weak self] indexPath in
        // TODO: - 해당 item을 기반으로 상세페이지로 이동합니다.
        print("DEBUG: [\(indexPath.section)], [\(indexPath.item)] clicked")
        return State.showDetail
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
}

// TODO: - import 지우기
import UIKit

// MARK: - Private Helpers
extension SearchMoreDetailViewModel {
  private func fetchData(type: SearchSectionType) {
    switch type {
    case .festival:
      fetchFestivalModel()
    case .leports:
      fetchLeportsModel()
    }
  }
  
  private func fetchFestivalModel() {
    let image = UIImage(named: "tempThumbnail1")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    self.itemInfos = [
      TravelDestinationItemInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isSelectedButton: false, imageData: imageData, id: 12345456),
      TravelDestinationItemInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isSelectedButton: false, imageData: imageData, id: 12345456),
      TravelDestinationItemInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isSelectedButton: false, imageData: imageData, id: 12345456),
      TravelDestinationItemInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isSelectedButton: false, imageData: imageData, id: 12345456),
      TravelDestinationItemInfo(place: "축제 타이틀", category: "축제", location: "24.01.01~24.02.10", isSelectedButton: false, imageData: imageData, id: 12345456)
    ]
    self.headerInfo = SearchDetailHeaderInfo.festivalMock
  }
  
  private func fetchLeportsModel() {
    let image = UIImage(named: "tempThumbnail1")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    self.itemInfos = [
      TravelDestinationItemInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isSelectedButton: false, imageData: imageData, id: 12344),
      TravelDestinationItemInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isSelectedButton: false, imageData: imageData, id: 12344),
      TravelDestinationItemInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isSelectedButton: false, imageData: imageData, id: 12344),
      TravelDestinationItemInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isSelectedButton: false, imageData: imageData, id: 12344),
      TravelDestinationItemInfo(place: "레포츠 타이틀", category: "레포츠", location: "강원도 ~~~", isSelectedButton: false, imageData: imageData, id: 12344)
    ]
  }
  
//  private func fetchCampingModel() {
//    let models = SearchCampingModel.mockModels.map {
//      TravelDestinationModel(id: $0.id,
//                             imagePath: $0.imagePath,
//                             place: $0.place,
//                             secondText: $0.category,
//                             thirdText: $0.location,
//                             isSelectedButton: $0.isSelectedButton)
//    }
//    let cellViewModels = models.map { TravelDestinationCellViewModel(model: $0) }
//    self.travelDestinationCellViewModels = .init()
//    _ = cellViewModels.map { self.travelDestinationCellViewModels?.append($0) }
//    self.headerInfo = SearchDetailHeaderInfo.campingMock
//  }
  
  private func navigationTitle() -> String? {
    return headerInfo?.title
  }
}

// MARK: - Helpers
extension SearchMoreDetailViewModel {
  func numberOfItems(type: SearchSectionType) -> Int {
    switch type {
    case .festival, .leports:
      return itemInfos?.count ?? .zero
    }
  }
}

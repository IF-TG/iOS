//
//  FavoriteViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/22.
//

import Foundation
import Combine

// 임시
struct FavoriteHeaderDirectoryEntity {
  let categoryCount: Int
  let imageURLs: [String?]
}

struct FavoriteDirectoryEntity {
  var id: Int
  var title: String
  var innerItemCount: Int
  var imageURL: String?
}

final class FavoriteViewModel {
  // MARK: - Dependencies
  
  // MARK: - Properties
  private var headerDirectory: FavoriteHeaderDirectoryEntity
  private var favoriteDirectories: [FavoriteDirectoryEntity]
  
  // MARK: - Lifecycles
  init() {
    var mockData = MockFavoriteUseCase()
    headerDirectory = mockData.favoriteHeader
    favoriteDirectories = mockData.favoriteDirectories
  }
}

// MARK: - FavoriteListTableViewAdapterDataSource
extension FavoriteViewModel: FavoriteTableViewAdapterDataSource {
  var numberOfItems: Int {
    favoriteDirectories.count
  }
  
  var headerItem: FavoriteHeaderDirectoryEntity {
    return headerDirectory
  }
  
  func cellItem(at index: Int) -> FavoriteCellInfo {
    let item = favoriteDirectories[index]
    return FavoriteCellInfo(title: item.title, innerItemCount: item.innerItemCount, imageURL: item.imageURL)
  }
}

// MARK: - FavoriteViewModelable
extension FavoriteViewModel: FavoriteViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      appearStream(input),
      detailPageStream(input),
      changeDirectoryNameStream(input),
      didTapNewDirectoryStream(input),
      newDirectoryStream(input),
      directoryNameSettingPageStream(input),
      deleteDirectoryStream(input)
    ]).eraseToAnyPublisher()
  }
  
  private func appearStream(_ input: Input) -> Output {
    return input.appear
      .map {
        return .none
      }.eraseToAnyPublisher()
  }
  
  private func detailPageStream(_ input: Input) -> Output {
    return input.detailPage
      .map { indexPath -> State in
        // TODO: - 세부 디렉터리 식별자 키 찾아서 전송해야합니다.
        print("무야호")
        return .showDetailPage(indexPath)
      }.eraseToAnyPublisher()
  }
  
  private func changeDirectoryNameStream(_ input: Input) -> Output {
    return input.updateDirectoryName
      .map { [weak self] (title, index) -> State in
        self?.favoriteDirectories[index].title = title
        let indexPath = IndexPath(row: index, section: 0)
        return .updatedDirecrotyName(indexPath)
      }.eraseToAnyPublisher()
  }
  
  private func didTapNewDirectoryStream(_ input: Input) -> Output {
    return input.didTapNewDirectory
      .map {
        return .showNewDirectoryCreationPage
      }.eraseToAnyPublisher()
  }
  
  private func newDirectoryStream(_ input: Input) -> Output {
    return input.addNewDirectory
      .compactMap { $0 }
      .map { [weak self] title in
        let newDirectory = FavoriteDirectoryEntity(
          id: 0,
          title: title,
          innerItemCount: 0,
          imageURL: nil)
        self?.favoriteDirectories.append(newDirectory)
        let indexPath = IndexPath(item: (self?.numberOfItems ?? 1)-1, section: 0)
        return .newDirectory(indexPath)
      }.eraseToAnyPublisher()
  }
  
  private func directoryNameSettingPageStream(_ input: Input) -> Output {
    return input.directoryNameSettingPage
      .map { indexPath -> State in
        return .showDirectoryNameSettingPage(indexPath.row)
      }.eraseToAnyPublisher()
  }
  
  private func deleteDirectoryStream(_ input: Input) -> Output {
    return input.deleteDirectory
      .map { [weak self] indexPath -> State in
        self?.favoriteDirectories.remove(at: indexPath.row)
        return .deleteDirectory(indexPath)
      }.eraseToAnyPublisher()
  }
}

//
//  PostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

final class PostViewModel {
  // MARK: - Properties
  private let data: [PostModel]
  
    var count: Int {
      data.count
    }
  
  // MARK: - Properteis
  init(data: [PostModel]) {
    self.data = data
  }
}

// MARK: - Public helpers
extension PostViewModel {
  func cellItem(_ indexPath: IndexPath) -> PostModel {
    return data[indexPath.row]
  }
  
  func contentText(_ indexPath: IndexPath) -> String {
    return data[indexPath.row].content.text
  }
}

// MARK: - PostViewDataSource
extension PostViewModel: PostViewDataSource {
  var numberOfItems: Int {
    data.count
  }
  
  func postViewCellItem(at index: Int) -> PostModel {
    return data[index]
  }

  func contentText(at index: Int) -> String {
    return data[index].content.text
  }
}

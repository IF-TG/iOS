//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation

final class PostDetailViewModel {
  private let texts: [String] = [
      """
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      \n
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      """,
      """
      내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2
      내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2
      내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2
      """,
      """
      내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3
      내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3
      내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3
      """,
      """
      내용4\n\n\n내용4내용4내용4내용4\n\n내용4내용4내용4내용4내용4
      """]
  private lazy var contents: [PostDetailContentInfo] = [
    .text(texts[0]), .image("tempThumbnail6"),
    .text(texts[1]), .image("tempThumbnail7"),
    .text(texts[2]), .image("tempThumbnail8"), .text(texts[3])]

}

// MARK: - PostDetailTableViewDataSource
extension PostDetailViewModel: PostDetailTableViewDataSource {
  var numberOfSections: Int {
    1
  }
  
  func numberOfItems(in section: Int) -> Int {
    switch section {
    case 0:
      return contents.count
    default:
      return 0
    }
  }
  
  func postContentItem(at index: Int) -> PostDetailContentInfo {
    return contents[index]
  }
}

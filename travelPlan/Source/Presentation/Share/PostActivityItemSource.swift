//
//  PostActivityItemSource.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import UIKit.UIActivityItemProvider
import LinkPresentation

final class PostActivityItemSource: NSObject, UIActivityItemSource {
  // MARK: - Properties
  private let title: String
  private let postId: Int
  private var metadata: LPLinkMetadata?
  
  init(title: String, postId: Int) {
    self.title = title
    self.postId = postId
    metadata = Self.makeMetaData(with: postId, title: title)
    super.init()
  }
  
  func activityViewControllerPlaceholderItem(
    _ activityViewController: UIActivityViewController
  ) -> Any {
    return title
  }
  
  /// 링크로 반환할 때 이미지가 보이지 않음.
  /// 이미지로 반환할 때 링크가 보이지 않음.
  /// 여기서는 하나의 값을 반환해야하고, 액티비티 뷰 컨트롤러에 아이템 추가할 때 여러개 보여줄 항목들 추가하면 해결.
  func activityViewController(
    _ activityViewController: UIActivityViewController,
    itemForActivityType activityType: UIActivity.ActivityType?
  ) -> Any? {
    return metadata?.url
  }
  
  // https://stackoverflow.com/questions/57850483/ios13-share-sheet-how-to-set-preview-thumbnail-when-sharing-uiimage
  func activityViewControllerLinkMetadata(
    _ activityViewController: UIActivityViewController
  ) -> LPLinkMetadata? {
    return metadata
  }
}

fileprivate extension PostActivityItemSource {
  static func makeMetaData(with postId: Int, title: String) -> LPLinkMetadata {
    return {
      $0.iconProvider = NSItemProvider(object: UIImage(named: "AppIcon")!)
      $0.title = title
      if let universalLinkURL = URL(string: "https://yeoga.onelink.me/HMyx/06lwa3b9?postId=\(postId)") {
        $0.originalURL = universalLinkURL
        $0.url = universalLinkURL
      } 
      return $0
    }(LPLinkMetadata())
  }
}

//
//  PostActivityItemSource.swift
//  travelPlan
//
//  Created by 양승현 on 12/22/23.
//

import UIKit
import LinkPresentation

final class PostActivityItemSource: NSObject, UIActivityItemSource {
  // MARK: - Properties
  private let image: UIImage
  private let title: String
  
  init(image: UIImage, title: String) {
    self.image = image
    self.title = title
    
    super.init()
  }
  
  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return title
  }
  
  func activityViewController(
    _ activityViewController: UIActivityViewController,
    itemForActivityType activityType: UIActivity.ActivityType?
  ) -> Any? {
    return image
  }
  
  // FIXME: - 공유할 때 icon이 꽉 찬게 아니라 뒤에 여백이 있습니다.
  // 스택오버플로우 글 을 보면 최소 40*40 이면 된다는데,, 안되는 문제가..
  // https://stackoverflow.com/questions/57850483/ios13-share-sheet-how-to-set-preview-thumbnail-when-sharing-uiimage
  func activityViewControllerLinkMetadata(
    _ activityViewController: UIActivityViewController
  ) -> LPLinkMetadata? {
    guard let icon = UIImage(named: "AppIcon") else { return .init() }
    return {
      $0.iconProvider = NSItemProvider(object: icon)
      $0.title = title
      $0.originalURL = URL(fileURLWithPath: "Yeoga.com")
      return $0
    }(LPLinkMetadata())
  }
}

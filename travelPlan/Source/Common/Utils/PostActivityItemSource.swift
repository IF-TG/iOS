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
  private let postId: Int
  private var metadata: LPLinkMetadata?
  
  init(image: UIImage, title: String, postId: Int) {
    self.image = image
    self.title = title
    self.postId = postId
    guard let icon = UIImage(named: "AppIcon") else { 
      super.init()
      return
    }
    metadata = {
      $0.iconProvider = NSItemProvider(object: icon)
      $0.title = title
      if let deepLinkURL = URL(string: "yeoga://post/\(postId)") {
        $0.originalURL = deepLinkURL
      }
      return $0
    }(LPLinkMetadata())
    
    super.init()
  }
  
  func activityViewControllerPlaceholderItem(
    _ activityViewController: UIActivityViewController
  ) -> Any {
    return title
  }
  
  /// 링크로할 때 이미지가 보이지 않음..
  /// 이미지로. 할때 링크가 보이지 않음..ㅋㅋ
  // TODO: - 공유 버튼 작아서 잘 안눌림. 여백 포함으로 키우기
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
    return metadata
  }
}

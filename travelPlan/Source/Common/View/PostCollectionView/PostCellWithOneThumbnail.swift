//
//  PostCellWithOneThumbnail.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithOneThumbnail: BasePostCell {
  // MARK: - Nested
  private final class PostOneThumbnailView: UIImageView, BasePostCellThumbnailConfigurable {
    override init(frame: CGRect) {
      super.init(frame: frame)
      translatesAutoresizingMaskIntoConstraints = false
      contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
      nil
    }
    
    func configureThumbnail(with images: [String]?) {
      guard let images else {
        image = nil
        return
      }
      image = UIImage(named: images[0])
    }
  }
  
  static let id = String(describing: PostCellWithOneThumbnail.self)
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    let contentView = PostOneThumbnailView(frame: .zero)
    super.init(frame: frame, thumbnailView: contentView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

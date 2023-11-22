//
//  PostCellWithTwoThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithTwoThumbnails: BasePostCell {
  // MARK: - Nested
  private final class PostTwoThumbnailsView: UIStackView, BasePostCellThumbnailConfigurable {
    private var imageViews: [UIImageView] = []
    init() {
      super.init(frame: .zero)
      imageViews = (0...1).map { _ -> UIImageView in
        return UIImageView(frame: .zero).set {
          $0.contentMode = .scaleAspectFill
        }
      }
    }
    
    required init(coder: NSCoder) {
      fatalError()
    }
    
    func configureThumbnail(with images: [String]?) {
      guard let images else {
        imageViews.forEach { $0.image = nil }
        return
      }
      imageViews.enumerated().forEach {
        $1.image = UIImage(named: images[$0])
      }
    }
  }

  static let id = String(describing: PostCellWithTwoThumbnails.self)
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    let contentView = PostTwoThumbnailsView()
    super.init(frame: frame, thumbnailView: contentView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

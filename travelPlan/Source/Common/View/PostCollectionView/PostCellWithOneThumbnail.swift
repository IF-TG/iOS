//
//  PostCellWithOneThumbnail.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithOneThumbnail: BasePostCell {
  // MARK: - Nested
  private final class PostOneThumbnailView: UIImageView {
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
  
  // MARK: - Properties
  private var thumbnailView: PostOneThumbnailView?
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    let thumbnailView = PostOneThumbnailView(frame: .zero)
    self.thumbnailView = thumbnailView
    super.init(frame: frame, thumbnailView: thumbnailView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailView?.configureThumbnail(with: nil)
  }
  
  // MARK: - Helpers
  override func configure(with post: PostInfo?) {
    super.configure(with: post)
    
  }
}

//
//  PostCellWithOneThumbnail.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

private final class PostOneThumbnailView: UIImageView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .scaleAspectFill
  }
  
  required init?(coder: NSCoder) { nil }
  
  func configureThumbnail(with images: [Data]?) {
    guard let images, images.count > 0 else {
      self.image = nil
      return
    }
    image = UIImage(data: images[0])
  }
}

final class PostCellWithOneThumbnail: BasePostCell, BasePostViewDelegator, PostHeartsConfigurable, 
                                      PostCellEdgeDividable {
  // MARK: - Properties
  private let thumbnailView: PostOneThumbnailView
  
  internal let postView: BasePostView
  
  weak var postViewDelegate: PostViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let thumbnailView = PostOneThumbnailView(frame: .zero)
    self.thumbnailView = thumbnailView
    postView = BasePostView(frame: frame, thumbnailView: thumbnailView)
    thumbnailView.heightAnchor.constraint(equalToConstant: 118).isActive = true
    super.init(frame: frame)
    setupUI()
    postView.baseDelegate = self
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
}

// MARK: - PostCellConfigurable
extension PostCellWithOneThumbnail: PostCellConfigurable {
  func configure(with post: PostInfo?) {
    postView.configure(with: post)
    thumbnailView.configureThumbnail(with: post?.content.thumbnailImageDataList)
  }
}

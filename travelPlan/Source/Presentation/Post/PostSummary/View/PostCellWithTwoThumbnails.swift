//
//  PostCellWithTwoThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

private final class PostTwoThumbnailsView: UIStackView {
  private var imageViews: [UIImageView] = []
  
  init() {
    super.init(frame: .zero)
    configureDefaultPostThumbnail(with: .horizontal)
    imageViews = (0...1).map { _ -> UIImageView in
      return UIImageView(frame: .zero).set {
        $0.contentMode = .scaleAspectFill
        $0.heightAnchor.constraint(equalToConstant: 118).isActive = true
        $0.clipsToBounds = true
      }
    }
    imageViews.forEach { addArrangedSubview($0) }
  }
  
  required init(coder: NSCoder) { fatalError() }
  
  func configureThumbnail(with images: [Data]?) {
    guard let images else {
      imageViews.forEach { $0.image = nil }
      return
    }
    images.enumerated().forEach {
      imageViews[$0].image = UIImage(data: $1)
    }
  }
}

final class PostCellWithTwoThumbnails: BasePostCell, BasePostViewDelegator, PostHeartsConfigurable {
  // MARK: - Properties
  private let thumbnailView: PostTwoThumbnailsView
  
  internal let postView: BasePostView
  
  weak var postViewDelegate: PostViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostTwoThumbnailsView()
    self.thumbnailView = contentView
    postView = BasePostView(frame: frame, thumbnailView: contentView)
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
extension PostCellWithTwoThumbnails: PostCellConfigurable {
  func configure(with info: PostInfo?) {
    postView.configure(with: info)
    thumbnailView.configureThumbnail(with: info?.content.thumbnailImageDataList)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithTwoThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

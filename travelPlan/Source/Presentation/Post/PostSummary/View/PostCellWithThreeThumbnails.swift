//
//  PostCellWithThreeThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

private final class PostThreeThumbnailsView: UIStackView {
  private var imageViews: [UIImageView] = []
  
  init() {
    super.init(frame: .zero)
    configureDefaultPostThumbnail(with: .horizontal)
    imageViews = (0...2).map { _ -> UIImageView in
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

final class PostCellWithThreeThumbnails: BasePostCell, BasePostViewDelegator {
  // MARK: - Properties
  private let thumbnailView: PostThreeThumbnailsView
  
  internal let postView: BasePostView
  
  weak var postViewDelegate: PostViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostThreeThumbnailsView()
    self.thumbnailView = contentView
    self.postView = BasePostView(frame: frame, thumbnailView: contentView)
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
extension PostCellWithThreeThumbnails: PostCellConfigurable {
  func configure(with info: PostInfo?) {
    postView.configure(with: info)
    thumbnailView.configureThumbnail(with: info?.content.thumbnailImageDataList)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithThreeThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - PostHeartsConfigurable
extension PostCellWithThreeThumbnails: PostHeartsConfigurable {
  func setPostHearts(with hearts: Int32) {
    postView.setPostHearts(with: hearts)
  }
}

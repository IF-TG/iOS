//
//  PostCellWithFiveThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

private final class PostFiveThumbnailsView: UIStackView {
  private var imageViews: [UIImageView] = []
  
  init() {
    super.init(frame: .zero)
    imageViews = (0...4).map { index -> UIImageView in
      return UIImageView(frame: .zero).set {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        let height = index == 0 ? 118.0 : (118 - 1)/2.0
        $0.heightAnchor.constraint(equalToConstant: height).isActive = true
      }
    }
    let rightTopStackView = UIStackView(arrangedSubviews: [imageViews[1], imageViews[2]])
    let rightBottomStackView = UIStackView(arrangedSubviews: [imageViews[3], imageViews[4]])
    let rightContentStackView = UIStackView(arrangedSubviews: [rightTopStackView, rightBottomStackView])
    [imageViews[0], rightContentStackView].forEach { addArrangedSubview($0) }
    
    self.configureDefaultPostThumbnail(with: .horizontal)
    rightContentStackView.configureDefaultPostThumbnail(with: .vertical)
    rightTopStackView.configureDefaultPostThumbnail(with: .horizontal)
    rightBottomStackView.configureDefaultPostThumbnail(with: .horizontal)
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

final class PostCellWithFiveThumbnails: BasePostCell, BasePostViewDelegator, PostHeartsConfigurable,
                                        PostCellEdgeDividable {
  // MARK: - Properties
  private let thumbnailView: PostFiveThumbnailsView
  
  internal let postView: BasePostView
  
  weak var postViewDelegate: PostViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostFiveThumbnailsView()
    self.thumbnailView = contentView
    thumbnailView.clipsToBounds = true
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
extension PostCellWithFiveThumbnails: PostCellConfigurable {
  func configure(with info: PostInfo?) {
    postView.configure(with: info)
    thumbnailView.configureThumbnail(with: info?.content.thumbnailImageDataList)
  }
}

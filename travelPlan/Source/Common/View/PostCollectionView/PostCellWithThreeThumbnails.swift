//
//  PostCellWithThreeThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithThreeThumbnails: BasePostCell {
  static let id = String(describing: PostCellWithTwoThumbnails.self)
  
  // MARK: - Nested
  private final class PostThreeThumbnailsView: UIStackView {
    private var imageViews: [UIImageView] = []
    init() {
      super.init(frame: .zero)
      axis = .horizontal
      spacing = 1
      distribution = .equalSpacing
      alignment = .fill
      imageViews = (0...2).map { _ -> UIImageView in
        return UIImageView(frame: .zero).set {
          $0.contentMode = .scaleAspectFill
        }
      }
      imageViews.forEach { addArrangedSubview($0) }
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
  
  // MARK: - Properties
  private var thumbnailView: PostThreeThumbnailsView?
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    let contentView = PostThreeThumbnailsView()
    self.thumbnailView = contentView
    super.init(frame: frame, thumbnailView: contentView)
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
    thumbnailView?.configureThumbnail(with: post?.content.thumbnailURLs)
  }
}

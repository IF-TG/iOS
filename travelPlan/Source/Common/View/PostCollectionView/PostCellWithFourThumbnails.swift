//
//  PostCellWithFourThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithFourThumbnails: BasePostCell {
  static let id = String(describing: PostCellWithFourThumbnails.self)
  
  // MARK: - Nested
  private final class PostFourThumbnailsView: UIStackView {
    private var imageViews: [UIImageView] = []
    init() {
      super.init(frame: .zero)
      imageViews = (0...3).map { _ -> UIImageView in
        return UIImageView(frame: .zero).set {
          $0.contentMode = .scaleAspectFill
        }
      }
      let rightBottomStackView = UIStackView(arrangedSubviews: [imageViews[2], imageViews[3]])
      let rightContentStackView = UIStackView(arrangedSubviews: [imageViews[1], rightBottomStackView])
      [imageViews[0], rightContentStackView].forEach { addArrangedSubview($0) }
      setStackView(self, axis: .horizontal)
      setStackView(rightBottomStackView, axis: .horizontal)
      setStackView(rightContentStackView, axis: .vertical)
    }
    
    required init(coder: NSCoder) {
      fatalError()
    }
    
    // MARK: - Helpers
    func setStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
      _=stackView.set {
        $0.axis = axis
        $0.spacing = 1
        $0.distribution = .equalSpacing
        $0.alignment = .fill
      }
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
  private var thumbnailView: PostFourThumbnailsView?
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    let contentView = PostFourThumbnailsView()
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

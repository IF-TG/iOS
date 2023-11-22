//
//  PostCellWithTwoThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithTwoThumbnails: UICollectionViewCell {
  static let id = String(describing: PostCellWithTwoThumbnails.self)
  
  // MARK: - Nested
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
  private let thumbnailView: PostTwoThumbnailsView
  
  private let postView: BasePostView
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostTwoThumbnailsView()
    self.thumbnailView = contentView
    postView = BasePostView(frame: frame, thumbnailView: contentView)
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
  
  // MARK: - Helpers
  func configure(with post: PostInfo?) {
    postView.configure(with: post)
    thumbnailView.configureThumbnail(with: post?.content.thumbnailURLs)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithTwoThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - LayoutSupport
extension PostCellWithTwoThumbnails: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(postView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      postView.topAnchor.constraint(equalTo: contentView.topAnchor),
      postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}

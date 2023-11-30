//
//  PostCellWithOneThumbnail.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithOneThumbnail: UICollectionViewCell {
  static let id = String(describing: PostCellWithOneThumbnail.self) 
  
  // MARK: - Nested
  private final class PostOneThumbnailView: UIImageView {
    override init(frame: CGRect) {
      super.init(frame: frame)
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
  
  // MARK: - Properties
  private let thumbnailView: PostOneThumbnailView
  
  private let postView: BasePostView
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let thumbnailView = PostOneThumbnailView(frame: .zero)
    self.thumbnailView = thumbnailView
    postView = BasePostView(frame: frame, thumbnailView: thumbnailView)
    thumbnailView.heightAnchor.constraint(equalToConstant: 118).isActive = true
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
}

// MARK: - PostCellConfigurable
extension PostCellWithOneThumbnail: PostCellConfigurable {
  func configure(with post: PostInfo?) {
    postView.configure(with: post)
    thumbnailView.configureThumbnail(with: post?.content.thumbnailURLs)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithOneThumbnail: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - LayoutSupport
extension PostCellWithOneThumbnail: LayoutSupport {
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

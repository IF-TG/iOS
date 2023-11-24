//
//  PostCellWithFiveThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithFiveThumbnails: UICollectionViewCell {
  static let id = String(describing: PostCellWithFiveThumbnails.self)
  
  // MARK: - Nested
  private final class PostFiveThumbnailsView: UIStackView {
    private var imageViews: [UIImageView] = []
    init() {
      super.init(frame: .zero)
      imageViews = (0...4).map { index -> UIImageView in
        return UIImageView(frame: .zero).set {
          $0.contentMode = .scaleAspectFill
          $0.layer.masksToBounds = true
          var height = index == 0 ? 118.0 : (118 - 1)/2.0
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
  private let thumbnailView: PostFiveThumbnailsView
  
  private let postView: BasePostView
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostFiveThumbnailsView()
    self.thumbnailView = contentView
    thumbnailView.clipsToBounds = true
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
extension PostCellWithFiveThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - LayoutSupport
extension PostCellWithFiveThumbnails: LayoutSupport {
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

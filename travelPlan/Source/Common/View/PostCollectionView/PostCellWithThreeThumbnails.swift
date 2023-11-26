//
//  PostCellWithThreeThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithThreeThumbnails: UICollectionViewCell {
  static let id = String(describing: PostCellWithThreeThumbnails.self)
  
  // MARK: - Nested
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
  private let thumbnailView: PostThreeThumbnailsView
  
  private let postView: BasePostView
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostThreeThumbnailsView()
    self.thumbnailView = contentView
    self.postView = BasePostView(frame: frame, thumbnailView: contentView)
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
extension PostCellWithThreeThumbnails: PostCellConfigurable {
  func configure(with info: PostInfo?) {
    postView.configure(with: info)
    thumbnailView.configureThumbnail(with: info?.content.thumbnailURLs)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithThreeThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - LayoutSupport
extension PostCellWithThreeThumbnails: LayoutSupport {
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

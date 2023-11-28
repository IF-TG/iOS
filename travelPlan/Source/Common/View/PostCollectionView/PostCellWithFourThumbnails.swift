//
//  PostCellWithFourThumbnails.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit

final class PostCellWithFourThumbnails: UICollectionViewCell {
  static let id = String(describing: PostCellWithFourThumbnails.self)
  
  // MARK: - Nested
  private final class PostFourThumbnailsView: UIStackView {
    private var imageViews: [UIImageView] = []
    init() {
      super.init(frame: .zero)
      imageViews = (0...3).map { index -> UIImageView in
        return UIImageView(frame: .zero).set {
          $0.contentMode = .scaleAspectFill
          $0.clipsToBounds = true
          let height = index == 0 ? 118.0 : (118 - 1)/2.0
          $0.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
      }
      let rightBottomStackView = UIStackView(arrangedSubviews: [imageViews[2], imageViews[3]])
      let rightContentStackView = UIStackView(arrangedSubviews: [imageViews[1], rightBottomStackView])
      [imageViews[0], rightContentStackView].forEach { addArrangedSubview($0) }
      self.configureDefaultPostThumbnail(with: .horizontal)
      rightBottomStackView.configureDefaultPostThumbnail(with: .horizontal)
      rightContentStackView.configureDefaultPostThumbnail(with: .vertical)
    }
    
    required init(coder: NSCoder) {
      fatalError()
    }
    
    // MARK: - Helpers
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
  private var thumbnailView: PostFourThumbnailsView
  
  private let postView: BasePostView
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostFourThumbnailsView()
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
}

// MARK: - PostCellConfigurable
extension PostCellWithFourThumbnails: PostCellConfigurable {
  func configure(with info: PostInfo?) {
    postView.configure(with: info)
    thumbnailView.configureThumbnail(with: info?.content.thumbnailURLs)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithFourThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - LayoutSupport
extension PostCellWithFourThumbnails: LayoutSupport {
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
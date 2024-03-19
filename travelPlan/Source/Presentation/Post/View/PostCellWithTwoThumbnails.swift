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
    private let imageIO = ImageIO()
    private let imageLoadQueue = {
      $0.name = "TwoImageLoadQueue"
      $0.maxConcurrentOperationCount = 2
      return $0
    }(OperationQueue())
    private let imageCache = ImageMemoryCache()
    
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
      imageLoadQueue.cancelAllOperations()
      guard let images else {
        imageViews.forEach { $0.image = nil }
        return
      }
      imageViews.enumerated().forEach { index, imageView in
        let width = (UIScreen.main.bounds.width - 43) / 2
        let size = CGSize(width: width, height: 118)
        if let image = imageCache[images[index]] {
          imageView.image = image
          return
        }
        let operation = BlockOperation { [weak self] in
          let data = UIImage(named: images[index])!.pngData()!
          let createType = ImageIO.ImageSourceCreateType.data(data)
          let options = ImageIO.DownsampledOptions(imagePixelSize: size)
          guard let cgImage = self?.imageIO.setDownsampledCGImage(at: createType, for: options) else { return }
          DispatchQueue.main.async {
            imageView.image = UIImage(cgImage: cgImage)
            self?.imageCache[images[index]] = imageView.image
          }
        }
        imageLoadQueue.addOperation(operation)

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
}

// MARK: - PostCellConfigurable
extension PostCellWithTwoThumbnails: PostCellConfigurable {
  func configure(with info: PostInfo?) {
    postView.configure(with: info)
    thumbnailView.configureThumbnail(with: info?.content.thumbnailURLs)
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

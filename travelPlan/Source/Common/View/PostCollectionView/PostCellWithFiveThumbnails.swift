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
    private let imageIO = ImageIO()
    private var imageViews: [UIImageView] = []
    private let imageLoadQueue = {
      $0.name = "TwoImageLoadQueue"
      $0.maxConcurrentOperationCount = 2
      return $0
    }(OperationQueue())
    private let imageCache = ImageMemoryCache()
    
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
  private let thumbnailView: PostFiveThumbnailsView
  
  private let postView: BasePostView
  
  weak var delegate: PostCellDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let contentView = PostFiveThumbnailsView()
    self.thumbnailView = contentView
    thumbnailView.clipsToBounds = true
    postView = BasePostView(frame: frame, thumbnailView: contentView)
    super.init(frame: frame)
    setupUI()
    postView.delegate = self
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
    thumbnailView.configureThumbnail(with: info?.content.thumbnailURLs)
  }
}

// MARK: - PostCellEdgeDividable
extension PostCellWithFiveThumbnails: PostCellEdgeDividable {
  func hideCellDivider() {
    postView.hideCellDivider()
  }
}

// MARK: - BasePostViewDelegate
extension PostCellWithFiveThumbnails: BasePostViewDelegate {
  func didTapOptionButton() {
    delegate?.didTapOption(in: self)
  }
  
  func didTapHeart() {
    delegate?.didTapHeart(in: self)
  }
  
  func didTapComment() {
    delegate?.didTapComment(in: self)
  }
  
  func didTapShare() {
    delegate?.didTapShare(in: self)
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

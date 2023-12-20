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
    private let imageIO = ImageIO()
    private let imageLoadQueue = {
      $0.name = "TwoImageLoadQueue"
      $0.maxConcurrentOperationCount = 2
      return $0
    }(OperationQueue())
    private let imageCache = ImageMemoryCache()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      contentMode = .scaleAspectFill
      
    }
    
    required init?(coder: NSCoder) {
      nil
    }
    
    func configureThumbnail(with images: [String]?) {
      imageLoadQueue.cancelAllOperations()
      guard let images else {
        image = nil
        return
      }
      let width = UIScreen.main.bounds.width - 43
      let size = CGSize(width: width, height: 118)
      if let image = imageCache[images[0]] {
        self.image = image
        return
      }
      let operation = BlockOperation { [weak self] in
        let data = UIImage(named: images[0])!.pngData()!
        let createType = ImageIO.ImageSourceCreateType.data(data)
        let options = ImageIO.DownsampledOptions(imagePixelSize: size)
        guard let cgImage = self?.imageIO.setDownsampledCGImage(at: createType, for: options) else { return }
        DispatchQueue.main.async {
          self?.image = UIImage(cgImage: cgImage)
          self?.imageCache[images[0]] = self?.image
        }
      }
      imageLoadQueue.addOperation(operation)
    }
  }
  
  // MARK: - Properties
  private let thumbnailView: PostOneThumbnailView
  
  private let postView: BasePostView
  
  weak var delegate: PostCellDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    let thumbnailView = PostOneThumbnailView(frame: .zero)
    self.thumbnailView = thumbnailView
    postView = BasePostView(frame: frame, thumbnailView: thumbnailView)
    thumbnailView.heightAnchor.constraint(equalToConstant: 118).isActive = true
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

// MARK: - BasePostViewDelegate
extension PostCellWithOneThumbnail: BasePostViewDelegate {
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

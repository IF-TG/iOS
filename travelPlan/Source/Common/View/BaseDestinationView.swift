//
//  BaseDestinationView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/24.
//

import UIKit
import SnapKit
import Combine

/// imageView + centerView + starButton로 구성되어 있습니다.
///
/// centerView를 커스텀해서 생성자 시점에 주입합니다.
/// imageView는 type에 따라 설정할 수 있습니다. custom인 경우, 연관값으로 커스텀 이미지뷰를 넣어주어야 합니다.
/// starButton의 이벤트를 정의해야 되는 경우, StarButtonDelegate를 준수해야 합니다.
class BaseDestinationView<CenterView>: UIView where CenterView: UIView & CellConfigurable {
  struct BaseDestinationViewInfo {
    let imageData: Data?
    let isSelectedButton: Bool
  }
  
  enum Constant {
    enum ThumbnailImageView {
      static var cornerRadius: CGFloat { 3 }
      static var width: CGFloat { 110 }
      enum Spacing {
        static var top: CGFloat { 5 }
        static var bottom: CGFloat { 5 }
      }
      static var defaultCornerRadius: CGFloat { 7 }
    }
  }
  
  enum ImageViewType {
    case `default`
    case custom(imageView: UIImageView)
    
    var imageView: UIImageView {
      switch self {
      case .default:
        return UIImageView().set {
          $0.contentMode = .scaleAspectFill
          
          $0.layer.cornerRadius = Constant.ThumbnailImageView.defaultCornerRadius
          $0.clipsToBounds = true
        }
      case let .custom(imageView):
        return imageView
      }
    }
  }
  
  // MARK: - Properties
//  weak var delegate: StarButtonDelegate?
  private let thumbnailImageView: UIImageView
  private let centerView: CenterView
  private lazy var starButton: SearchStarButton = .init(normalType: .black).set {
    $0.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
  }
  private let starButtonClicked = PassthroughSubject<Void, Never>()
  
  var starButtonPublisher: AnyPublisher<Void, Never> {
    return starButtonClicked.eraseToAnyPublisher()
  }
  
  // MARK: - LifeCycle
// centerView를 직접 추가해야 합니다. imageView는 type에 따라서 설정할 수 있습니다.
//  convenience init(centerView: CenterView, imageViewType: ImageViewType) {
//    self.init(frame: .zero, centerView: centerView, imageViewType: imageViewType)
//  }
  
  init(centerView: CenterView, imageViewType: ImageViewType) {
    self.centerView = centerView
    self.thumbnailImageView = imageViewType.imageView
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Actions
  @objc private func didTapStarButton(_ button: UIButton) {
    starButtonClicked.send()
  }
}

// MARK: - Helpers
extension BaseDestinationView {
  func clearThumbnailImage() {
    thumbnailImageView.image = nil
  }
  
  func clearButtonSelectedState() {
    starButton.isSelected = false
  }
  
  func toggleStarButtonState() {
    starButton.isSelected.toggle()
  }
  
  func configure(
    centerViewInfo: CenterView.Info,
    imageData: Data?,
    isSelectedButton: Bool
  ) {
    centerView.configure(with: centerViewInfo)
    
    starButton.isSelected = isSelectedButton
    // TODO: - 비어있는 이미지 사진을 지정해야합니다.
    guard let imageData = imageData, let image = UIImage(data: imageData)
    else { thumbnailImageView.image = UIImage(named: "tempProfile4"); return }
    
    thumbnailImageView.image = UIImage(data: imageData)
  }
}

// MARK: - LayoutSupport
extension BaseDestinationView: LayoutSupport {
  func addSubviews() {
    _ = [
      thumbnailImageView,
      centerView,
      starButton
    ].map { self.addSubview($0) }
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalToSuperview().inset(5)
      $0.bottom.equalToSuperview().inset(5)
      $0.width.equalTo(110)
    }
    
    centerView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing)
        .offset(15)
      $0.trailing.lessThanOrEqualTo(starButton.snp.leading)
        .offset(-20)
      $0.top.equalTo(thumbnailImageView)
    }
    
    starButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(5)
      $0.trailing.equalToSuperview().inset(16)
      $0.size.equalTo(24)
    }
  }
}

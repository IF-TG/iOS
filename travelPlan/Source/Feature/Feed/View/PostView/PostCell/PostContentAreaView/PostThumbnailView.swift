//
//  PostThumbnailView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/13.
//

import UIKit

final class PostThumbnailView: UIView {
  enum Constants {
    private static let intrinsicWidth = (UIScreen.main.bounds.width - PostContentAreaView
      .Constants.Thumbnail.Spacing.leading*2)
    static let spacing: CGFloat = 1
    static let cornerRadius: CGFloat = 10
    static let height: CGFloat = 117
    static let smallWidth: CGFloat = {
      (((intrinsicWidth-spacing)/2) - spacing) / 2
    }()
    static let smallHeight: CGFloat = 58
    static let mediumWidth: CGFloat = {
      ( intrinsicWidth - spacing ) / 2
    }()
  }
  
  // MARK: - Properties
  private var imageViews: [UIImageView] = []
  private var isSetupfuncCalled = false
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true
    layer.cornerRadius = Constants.cornerRadius
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Action event
extension PostThumbnailView {
  @objc func didTapThumbnail() {
    print("썸네일 터치")
  }
}

// MARK: - Public helpers
extension PostThumbnailView {
  func configure(with data: [UIImage]) {
    setImageViews(with: data)
    if !isSetupfuncCalled {
      isSetupfuncCalled = true
      setupUI()
    }
  }
}

// MARK: - Helpers
private extension PostThumbnailView {
  func setImageViews(with images: [UIImage]) {
    imageViews = images
      .map { return initImageview(with: $0) }
  }
  
  // Default is horizontal
  func initStackView(
    arrangeSubviews subviews: [UIView],
    axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat) -> UIStackView {
      return UIStackView(arrangedSubviews: subviews).set {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = axis
        $0.spacing = spacing
        $0.distribution = .fillEqually
        $0.alignment = .fill
      }
    }
  
  func initImageview(with image: UIImage) -> UIImageView {
    return UIImageView().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.clipsToBounds = true
      $0.contentMode = .scaleAspectFill
      $0.image = image
      $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
      let touch = UITapGestureRecognizer(target: self, action: #selector(didTapThumbnail))
      $0.isUserInteractionEnabled = true
      $0.addGestureRecognizer(touch)
    }
  }
  
  func setLayoutEqualToSuperView(
    _ view: UIView
  ) -> [NSLayoutConstraint] {
    return [
      view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
      view.topAnchor.constraint(equalTo: topAnchor),
      view.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
      view.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)]
  }
}

// MARK: - Create stackView just convenience :)
private extension PostThumbnailView {
  // 이미지 4개, 5개일때 가장 작은 이미지 2개를 stackView로 생성할 수 있습니다.
  enum RightThumbnailCase {
    case fourBottom
    case fifthTop
    case fifthBottom
  }
  
  func smallImageViews(
    _ list: [UIImageView],
    type: RightThumbnailCase
  ) -> [UIImageView] {
    switch type {
    case .fourBottom: return (2...3).map { list[$0] }
    case .fifthTop: return (1...2).map { list[$0] }
    case .fifthBottom: return (3...4).map { list[$0] }
    }
  }
  
  func smallStackView(_ type: RightThumbnailCase) -> UIStackView {
    var views: [UIImageView] = []
    switch type {
    case .fourBottom:
      views = smallImageViews(imageViews, type: .fourBottom)
    case .fifthTop:
      views = smallImageViews(imageViews, type: .fifthTop)
    case .fifthBottom:
      views = smallImageViews(imageViews, type: .fifthBottom)
    }
    return initStackView(
      arrangeSubviews: views,
      spacing: Constants.spacing).set {
        addSubview($0)
        NSLayoutConstraint.activate([
          $0.widthAnchor.constraint(
            lessThanOrEqualToConstant: Constants.mediumWidth),
          $0.heightAnchor.constraint(
            equalToConstant: Constants.smallHeight)])
      }
  }
}

// MARK: - LayoutSupport
extension PostThumbnailView: LayoutSupport {
  func addSubviews() {
    _=imageViews.map { addSubview($0) }
  }
  
  func setConstraints() {
    switch imageViews.count {
    case 1:
      NSLayoutConstraint.activate(firstConstraints)
    case 2:
      NSLayoutConstraint.activate(
        secondOrThirdConstraints(type: .two))
    case 3:
      NSLayoutConstraint.activate(
        secondOrThirdConstraints(type: .three))
    case 4:
      NSLayoutConstraint.activate(fourthConstraints)
    case 5:
      NSLayoutConstraint.activate(fifthConstraints)
    default:
      break
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostThumbnailView {
  var firstConstraints: [NSLayoutConstraint] {
    [imageViews[0].leadingAnchor.constraint(equalTo: leadingAnchor),
     imageViews[0].topAnchor.constraint(equalTo: topAnchor),
     imageViews[0].trailingAnchor.constraint(equalTo: trailingAnchor),
     imageViews[0].bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)]
  }
  
  func secondOrThirdConstraints(
    type: PostThumbnailType
  ) -> [NSLayoutConstraint] {
    var ivList: [UIImageView] = [imageViews[0], imageViews[1]]
    if type == .three { ivList.append(imageViews[2]) }
    let sv = initStackView(
      arrangeSubviews: ivList,
      spacing: Constants.spacing)
    addSubview(sv)
    return setLayoutEqualToSuperView(sv)
  }
  
  var fourthConstraints: [NSLayoutConstraint] {
    let rightBottomSv = smallStackView(.fourBottom)
    let smallMediumSv = initStackView(
      arrangeSubviews: [imageViews[1], rightBottomSv],
      axis: .vertical,
      spacing: Constants.spacing)
    
    addSubview(smallMediumSv)
    NSLayoutConstraint.activate([
      smallMediumSv.heightAnchor.constraint(
        lessThanOrEqualToConstant: Constants.smallHeight*2 + 1),
      smallMediumSv.widthAnchor.constraint(
        lessThanOrEqualToConstant: Constants.mediumWidth)])
    
    let bigSv = initStackView(
      arrangeSubviews: [imageViews[0], smallMediumSv],
      spacing: Constants.spacing)
    addSubview(bigSv)
    return setLayoutEqualToSuperView(bigSv)
  }
  
  var fifthConstraints: [NSLayoutConstraint] {
    let rightTopSv = smallStackView(.fifthTop)
    let rightBottomSv = smallStackView(.fifthBottom)
    let rightSv = initStackView(
      arrangeSubviews: [rightTopSv, rightBottomSv],
      axis: .vertical,
      spacing: Constants.spacing)
    addSubview(rightSv)
    let totalSv = initStackView(
      arrangeSubviews: [imageViews.first!, rightSv],
      spacing: Constants.spacing)
    addSubview(totalSv)
    return setLayoutEqualToSuperView(totalSv)
  }
}

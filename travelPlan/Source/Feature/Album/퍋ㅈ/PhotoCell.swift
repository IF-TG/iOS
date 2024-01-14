//
//  PhotoCell.swift
//  travelPlan
//
//  Created by SeokHyun on 1/7/24.
//

import UIKit
import SnapKit
import Photos

enum SelectionOrder {
  case none
  case selected(Int)
}

struct PhotoCellInfo {
  let asset: PHAsset
  let image: UIImage?
  var selectedOrder: SelectionOrder
}

final class PhotoCell: UICollectionViewCell {
  // MARK: - Nested
  enum Const {
    static let orderViewSize: CGFloat = 20
  }
  
  // MARK: - Properties
  weak var delegate: PhotoCellDelegate?
  
  static var id: String {
    return String(describing: Self.self)
  }
  
  private let imageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private let highlightedView: UIView = .init().set {
    $0.backgroundColor = .clear
    $0.isUserInteractionEnabled = false
  }
  
  private lazy var orderView: UIView = .init().set {
    $0.backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    $0.layer.borderColor = UIColor.yg.littleWhite.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = Const.orderViewSize / 2
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(didTapOrderView(_:)))
    $0.addGestureRecognizer(tapGesture)
  }
  
  private let orderLabel: UILabel = .init().set {
    $0.textColor = .yg.gray00Background
    $0.font = .init(pretendard: .medium_500(fontSize: 14))
    $0.clipsToBounds = true
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension PhotoCell {
  func configure(with info: PhotoCellInfo?) {
    imageView.image = info?.image
    
    if case let .selected(order) = info?.selectedOrder {
      highlightedView.backgroundColor = .white.withAlphaComponent(0.5)
      orderView.backgroundColor = .yg.primary
      orderView.layer.borderColor = UIColor.clear.cgColor
      orderView.layer.borderWidth = 0
      orderLabel.text = String(order)
      orderLabel.isHidden = false
    } else {
      highlightedView.backgroundColor = .clear
      orderView.backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
      orderView.layer.borderColor = UIColor.yg.littleWhite.cgColor
      orderView.layer.borderWidth = 1
      orderLabel.isHidden = true
    }
  }
}

// MARK: - LayoutSupport
extension PhotoCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(imageView)
    imageView.addSubview(highlightedView)
    highlightedView.addSubview(orderView)
    orderView.addSubview(orderLabel)
  }
  
  func setConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    highlightedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    orderView.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(7)
      $0.size.equalTo(Const.orderViewSize)
    }
    
    orderLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

// MARK: - Action
private extension PhotoCell {
  @objc func didTapOrderView(_ view: UIView) {
    delegate?.didTapOrderView(view)
    print("사진 체크!")
  }
}

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

enum PhotoCellQuadrant {
  case first
  case `else`
}

struct PhotoCellInfo {
  let image: UIImage?
  let selectedOrder: SelectionOrder
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
  
  private let orderView: UIView = .init().set {
    $0.backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    $0.layer.borderColor = UIColor.yg.littleWhite.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = Const.orderViewSize / 2
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    highlightedView.backgroundColor = .clear
    orderView.backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    orderView.layer.borderColor = UIColor.yg.littleWhite.cgColor
    orderView.layer.borderWidth = 1
    orderLabel.text = ""
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    
    let point = touch.location(in: self)
    if point.x >= self.frame.width / 2,
       point.y <= self.frame.height / 2 {
      delegate?.touchBegan(self, quadrant: .first)
    } else {
      delegate?.touchBegan(self, quadrant: .else)
    }
  }
}

// MARK: - Helpers
extension PhotoCell {
  func configure(with cellInfo: PhotoCellInfo) {
    imageView.image = cellInfo.image
    if case let .selected(order) = cellInfo.selectedOrder {
      highlightedView.backgroundColor = .white.withAlphaComponent(0.5)
      orderView.backgroundColor = .yg.primary
      orderView.layer.borderColor = UIColor.clear.cgColor
      orderView.layer.borderWidth = 0
      orderLabel.text = String(order)
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

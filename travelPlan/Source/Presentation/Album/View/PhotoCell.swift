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
  // MARK: - Properties
  weak var delegate: PhotoCellDelegate?
  private let orderView = PhotoOrderView()
  
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
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell(_:)))
    addGestureRecognizer(tapGesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    highlightedView.backgroundColor = .clear
    orderView.initializeUI()
  }
}

// MARK: - Helpers
extension PhotoCell {
  func configure(with cellInfo: PhotoCellInfo) {
    imageView.image = cellInfo.image
    if case let .selected(order) = cellInfo.selectedOrder {
      highlightedView.backgroundColor = .white.withAlphaComponent(0.5)
      orderView.configureOrderView(orderText: String(order))
    }
  }
}

// MARK: - LayoutSupport
extension PhotoCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(imageView)
    imageView.addSubview(highlightedView)
    highlightedView.addSubview(orderView)
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
      $0.size.equalTo(20)
    }
  }
}

// MARK: - Actions
private extension PhotoCell {
  @objc func didTapCell(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: self.contentView)
    
    if location.x >= contentView.frame.width / 2,
       location.y <= contentView.frame.height / 2 {
      delegate?.touchBegan(self, quadrant: .first)
    } else {
      delegate?.touchBegan(self, quadrant: .else)
    }
  }
}

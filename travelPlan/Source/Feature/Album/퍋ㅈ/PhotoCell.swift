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
  
  // MARK: - Properties
  static var id: String {
    return String(describing: Self.self)
  }
  
  private let imageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFill
  }
  
  private let highlightedView: UIView = .init().set {
    $0.backgroundColor = .clear
    $0.layer.borderWidth = 2
    $0.layer.borderColor = UIColor.green.cgColor
    $0.isUserInteractionEnabled = false
  }
  
  private let orderLabel: UILabel = .init().set {
    $0.textColor = .green
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
//    layer.masksToBounds = true // 이 값을 안주면 이미지가 셀의 다른 영역을 침범하는 영향을 준다
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
      orderLabel.text = String(order)
      highlightedView.isHidden = false
    } else {
      highlightedView.isHidden = true
    }
  }
}

// MARK: - LayoutSupport
extension PhotoCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(imageView)
    imageView.addSubview(highlightedView)
    highlightedView.addSubview(orderLabel)
  }
  
  func setConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    highlightedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    orderLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().inset(4)
    }
  }
}

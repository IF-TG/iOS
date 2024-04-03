//
//  AlbumPhotoDetailViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 1/24/24.
//

import UIKit
import SnapKit
import Combine

final class AlbumPhotoDetailViewController: UIViewController {
  
  // MARK: - Properties
  private let photoOrderView = PhotoOrderView()
  
  private let imageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
}

// MARK: - LayoutSupport
extension AlbumPhotoDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(imageView)
    view.addSubview(photoOrderView)
  }
  
  func setConstraints() {
    /*
     - PHAsset을 통해 사진의 가로 세로 비율 알 수 있음. (비율 해결)
     - 가로 세로 중, 더 큰 것의 값을 고정하고, 더 작은 값은 유동적으로 줄이기 (비율 알고, 하나의 값을 고정하면 나머지의 값을 알 수 있는 원리)
     - 이렇게 코드 짜면 이미지뷰의 제약조건 해결될듯
     */
    imageView.snp.makeConstraints {
      $0.centerY.leading.trailing.equalTo(view)
//      $0.height
    }
    
    photoOrderView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
      $0.trailing.equalToSuperview().inset(20)
      $0.size.equalTo(35)
    }
  }
}

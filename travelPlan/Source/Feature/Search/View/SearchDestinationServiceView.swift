//
//  SearchDestinationServiceView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/29/23.
//

import UIKit
import SnapKit

class SearchDestinationServiceView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel().set {
    $0.text = "제목"
    $0.font = .init(pretendard: .medium_500(fontSize: 12))
    $0.textColor = .yg.gray6
  }
  
  private let imageView = UIImageView().set {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - LifeCycle
  convenience init(title: String, image: UIImage) {
    self.init(frame: .zero, title: title, image: image)
  }
  
  init(frame: CGRect, title: String, image: UIImage) {
    self.titleLabel.text = title
    self.imageView.image = image
    super.init(frame: frame)
    setupUI()
    setupStyles()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension SearchDestinationServiceView: LayoutSupport {
  func addSubviews() {
    addSubview(imageView)
    addSubview(titleLabel)
  }
  
  func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      
    }
  }
}

// MARK: - Private Helpers
extension SearchDestinationServiceView {
  private func setupStyles() {
    backgroundColor = .gray
  }
}

//
//  SearchDestinationServiceTypeView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/30/23.
//

import UIKit

final class SearchDestinationServiceTypeView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel().set {
    $0.text = "제목"
    $0.font = .init(pretendard: .medium_500(fontSize: 12))
    $0.textColor = .yg.gray6
    $0.numberOfLines = 2
  }
  
  private let imageView = UIImageView().set {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - LifeCycle
  convenience init(title: String?, imageName: String) {
    self.init(frame: .zero, title: title, imageName: imageName)
  }
  
  init(frame: CGRect, title: String?, imageName: String) {
    titleLabel.text = title
    imageView.image = .init(named: imageName)
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension SearchDestinationServiceTypeView: LayoutSupport {
  func addSubviews() {
    addSubview(imageView)
    addSubview(titleLabel)
  }
  
  func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(25)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(16.5)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().inset(6)
    }
  }
}

// MARK: - Private Helpers
extension SearchDestinationServiceTypeView {
  private func setupStyles() {
    backgroundColor = .brown
  }
}

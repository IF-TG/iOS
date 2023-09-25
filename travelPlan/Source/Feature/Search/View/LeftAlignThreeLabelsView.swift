//
//  LeftAlignThreeLabelsView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/23.
//

import UIKit

final class LeftAlignThreeLabelsView: UIStackView {
  struct Model {
    let place: String
    let category: String
    let location: String
  }
  
  enum Constants {
    enum TitleLabel {
      static let fontSize: CGFloat = 16
      static let numberOfLines = 2
    }
    enum SecondLabel {
      static let fontSize: CGFloat = 14
      static let numberOfLines = 1
    }
    enum ThirdLabel {
      static let size: CGFloat = 14
      static let numberOfLines = 1
    }
  }
  
  // MARK: - Properties
  private let titleLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .semiBold, size: Constants.TitleLabel.fontSize)
    $0.text = "n/a"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.TitleLabel.numberOfLines
  }
  
  private let secondLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.SecondLabel.fontSize)
    $0.textColor = .yg.gray6
    $0.text = "n/a"
    $0.numberOfLines = Constants.SecondLabel.numberOfLines
  }
  
  private let thirdLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.ThirdLabel.size)
    $0.text = "n/a"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.ThirdLabel.numberOfLines
  }
  
  // MARK: - LifeCycle
  convenience init() {
    self.init(frame: .zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
    setupUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension LeftAlignThreeLabelsView {
  private func setupStyles() {
    self.axis = .vertical
    self.spacing = .zero
    self.alignment = .leading
  }
}

// MARK: - ConfigurableCenterView
extension LeftAlignThreeLabelsView: CellConfigurable {
  func configure(model: Model) {
    titleLabel.text = model.place
    secondLabel.text = model.category
    thirdLabel.text = model.location
  }
}

// MARK: - LayoutSupport
extension LeftAlignThreeLabelsView: LayoutSupport {
  func addSubviews() {
    _ = [titleLabel, secondLabel, thirdLabel]
      .map { self.addArrangedSubview($0) }
  }
  
  func setConstraints() { }
}

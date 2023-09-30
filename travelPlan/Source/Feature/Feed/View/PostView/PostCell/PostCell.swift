//
//  PostViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

final class PostCell: UICollectionViewCell {
  enum Constants {
    enum Line {
      static let bgColor: UIColor = .yg.gray0
      static let height: CGFloat = 1
      enum Spacing {
        static let leading: CGFloat = 11
        static let trailing: CGFloat = 11
      }
    }
    
    enum HeaderView {
      static let height: CGFloat = 43
      enum Spacing {
        static let leading: CGFloat = 10
        static let top: CGFloat = 8.5
        static let trailing: CGFloat = 65
      }
    }
    
    enum FooterView {
      enum Spacing {
        static let bottom: CGFloat = 17
        static let top: CGFloat = 17
      }
    }
    
    enum OptionView {
      static let size = CGSize(width: 1.67 + 5 + 5, height: 13.33 + 3 + 3)
      static let selectedImage = UIImage(named: "feedOption")
      static let unselectedImage = UIImage(named: "feedOption")?.setColor(.yg.gray4.withAlphaComponent(0.5))
      struct Spacing {
        // inset 길이만큼 뺐습니다.
        static let top: CGFloat = 38.33 - 3 - 3
        static let trailing: CGFloat = 39.67 - 5
      }
      // 옵션 버튼이 너무 작아서 터치가 안되서 버튼의 크기를 늘리겠습니다.
      struct Inset {
        static let top: CGFloat = 3
        static let leading: CGFloat = 5
        static let trailing: CGFloat = 5
        static let bottom: CGFloat = 3
      }
    }
  }
  
  // MARK: - Identifier
  static let id: String = String(describing: PostCell.self)
  
  // MARK: - Properties
  private let headerView = PostHeaderProfileAndInfoView()

  private lazy var optionButton = makeOptionButton()
  
  private let contentAreaView = PostContentAreaView()
  
  private let footerView = PostFooterView()
  
  private let line = OneUnitHeightLine(color: .yg.gray0)
  
  var vm: PostCellViewModel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
  
  // MARK: - Helper
  func configure(with post: PostModel?) {
    vm = PostCellViewModel(postModel: post)
    setHeaderWithData()
    setContentAreaWithData()
    setFooterWithData()
    configureUI()
  }

  // MARK: - Private helper
  private func configureUI() {
    line.setConstraint(
      fromSuperView: contentView,
      spacing: .init(
        leading: Constants.Line.Spacing.leading,
        trailing: Constants.Line.Spacing.trailing))
  }
  
  private func setHeaderWithData() {
    headerView.configure(with: vm.headerModel)
  }
  
  private func setContentAreaWithData() {
    guard vm.isValidatedContentAreaModel() else {
      contentAreaView.configure(with: vm.defaultContentAreaModel)
      return
    }
    contentAreaView.configure(with: vm.contentAreaModel)
  }

  private func setFooterWithData() {
    guard vm.isValidatedFooterModel() else {
      footerView.configure(with: vm.defaultFooterModel)
      return
    }
    footerView.configure(with: vm.footerModel)
  }
  
  private func makeOptionButton() -> UIButton {
    return UIButton().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setImage(
        Constants.OptionView.selectedImage,
        for: .normal)
      $0.setImage(
        Constants.OptionView.unselectedImage,
        for: .highlighted)
      $0.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
      $0.contentEdgeInsets = UIEdgeInsets(
        top: Constants.OptionView.Inset.top,
        left: Constants.OptionView.Inset.leading,
        bottom: Constants.OptionView.Inset.bottom,
        right: Constants.OptionView.Inset.trailing)
    }
    
  }
  
  // MARK: - Action
  @objc func didTapOption() {
    print("DEBUG: pop up option scene !!")
    UIView.touchAnimate(optionButton)
  }
}

// MARK: - LayoutSupport
extension PostCell: LayoutSupport {
  func addSubviews() {
    _=[
      headerView,
      contentAreaView,
      footerView
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      headViewConstraints,
      contentAreaViewConstraints,
      footerViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constraints
private extension PostCell {
  var headViewConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constants.HeaderView.Spacing
    typealias Const = Constants.HeaderView
    return [
      headerView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: Spacing.leading),
      headerView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      headerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Spacing.trailing),
      headerView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var contentAreaViewConstraints: [NSLayoutConstraint] {
    [contentAreaView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
     contentAreaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
     contentAreaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)]
  }

  var footerViewConstraints: [NSLayoutConstraint] {
    [footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
     footerView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor),
     footerView.topAnchor.constraint(
      equalTo: contentAreaView.bottomAnchor,
      constant: Constants.FooterView.Spacing.top),
     footerView.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor,
      constant: -Constants.FooterView.Spacing.bottom)]
  }
}

//
//  PostViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

final class PostCell: UICollectionViewCell {
  enum Constants {
    static var maximumHeight: CGFloat {
      HeaderView.height
      + HeaderView.Spacing.top
      + ContentView.maximumHeight
      + FooterView.height
      + FooterView.Spacing.top
      + FooterView.Spacing.bottom
    }
    
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
    
    enum ContentView {
      static let maximumHeight = PostContentAreaView.Constants.maximumHeight
      static let minimumHeight = PostContentAreaView.Constants.minimumHeight
    }
    
    enum FooterView {
      static let height: CGFloat = 20
      enum Spacing {
        static let top: CGFloat = 5
        static let bottom: CGFloat = 10
      }
    }
    
    enum OptionView {
      static let size = CGSize(width: 20, height: 20)
      static let selectedImage = UIImage(named: "feedOption")
      static let unselectedImage = UIImage(named: "feedOption")?.setColor(.yg.gray4.withAlphaComponent(0.5))
      struct Spacing {
        static let top: CGFloat = 15
        static let trailing: CGFloat = 15
      }

      struct Inset {
        static let top: CGFloat = 3
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
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
    hideCellDivider()
  }
  
  // MARK: - Helper
  func configure(with post: PostModel?) {
    vm = PostCellViewModel(postModel: post)
    setHeaderWithData()
    setContentAreaWithData()
    setFooterWithData()
    setCellDivieder(post == nil)
  }
  
  func hideCellDivider() {
    line.isHidden = true
  }
  
  func showCellDivider() {
    line.isHidden = false
  }

  // MARK: - Private helper
  private func setCellDivieder(_ isVisible: Bool) {
    guard isVisible else {
      hideCellDivider()
      return
    }
    showCellDivider()
  }
  
  private func configureUI() {
    typealias Spacing = Constants.Line.Spacing
    setupUI()
    line.setConstraint(
      fromSuperView: contentView,
      spacing: .init(leading: Spacing.leading, trailing: Spacing.trailing))
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
    typealias Const = Constants.OptionView
    typealias Inset = Const.Inset
    return UIButton().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setImage(
        Const.selectedImage,
        for: .normal)
      $0.setImage(
        Const.unselectedImage,
        for: .highlighted)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
      $0.contentEdgeInsets = UIEdgeInsets(top: Inset.top, left: 0, bottom: Inset.bottom, right: 0)
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
      footerView,
      optionButton
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      headViewConstraints,
      contentAreaViewConstraints,
      footerViewConstraints,
      optionButtonConstraints
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
    typealias Const = Constants.ContentView
    return [
      contentAreaView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      contentAreaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentAreaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)]
  }

  var footerViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.FooterView
    typealias Spacing = Const.Spacing
    return [
      footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      footerView.topAnchor.constraint(
        equalTo: contentAreaView.bottomAnchor,
        constant: Spacing.top),
      footerView.heightAnchor.constraint(
        equalToConstant: Const.height),
      footerView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -Spacing.bottom)]
  }
  
  var optionButtonConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.OptionView
    typealias Spacing = Const.Spacing
    return [
      optionButton.widthAnchor.constraint(equalToConstant: Const.size.width),
      optionButton.heightAnchor.constraint(equalToConstant: Const.size.height),
      optionButton.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      optionButton.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Spacing.trailing)]
  }
}

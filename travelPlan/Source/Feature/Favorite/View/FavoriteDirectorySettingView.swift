//
//  FavoriteDirectorySettingView.swift
//  travelPlan
//
//  Created by 양승현 on 10/7/23.
//

import UIKit
import Combine

protocol FavoriteDirectorySettingViewDelegate: AnyObject, BottomSheetViewDelegate {
  func favoriteDirectorySettingView(
    _ settingView: FavoriteDirectorySettingView,
    didTapOkButton: UIButton)
}

final class FavoriteDirectorySettingView: BottomSheetView {
  enum Constant {
    static let minimumTextLength = 1
    static let maximumTextLength = 15
    static let radius: CGFloat = 25

    enum TitleLabel {
      static let font = UIFont(pretendard: .medium, size: 16)!
      static let textColor: UIColor = .yg.gray7
      enum Spacing {
        static let top: CGFloat = 16
        static let leading: CGFloat = 27
        static let trailing = leading
      }
    }
    
    enum SearchBar {
      enum Spacing {
        static let top: CGFloat = 35
        static let leading: CGFloat = 30
        static let trailing = leading
      }
    }
    
    enum OkButton {
      static let height: CGFloat = 39
      enum Spacing {
        static let leading: CGFloat = 20
        static let top: CGFloat = 29.5
        static let trailing = leading
        static let bottom = 10.5
      }
    }
  }
  
  // MARK: - Properties
  private let titleLabel: UILabel = .init(frame: .zero).set {
    typealias Const = Constant.TitleLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.textAlignment = .center
    $0.numberOfLines = 1
    $0.textColor = Const.textColor
  }
  
  private let searchBar = SearchWithCancelView(frame: .zero)
  
  private var editingState: SearchWithCancelView.EditingState {
    searchBar.editingState
  }
  
  private let okButton = PrimaryColorToneRoundButton(currentState: .normal).set {
    $0.isUserInteractionEnabled = false
  }
  
  weak var delegate: FavoriteDirectorySettingViewDelegate?
  
  override var baseDelegate: BottomSheetViewDelegate? {
    get {
      return delegate
    } set {
      delegate = newValue as? FavoriteDirectorySettingViewDelegate
    }
  }
  
  private var subscription: AnyCancellable?
  
  override var intrinsicContentSize: CGSize {
    typealias TitleLabel = Constant.TitleLabel
    typealias SearchBar = Constant.SearchBar
    typealias OkButton = Constant.OkButton
    let superViewIntrinsicHeight = BottomSheetView.Constants.TopView.height
    let titleHeightAndTopSpacing = TitleLabel.font.lineHeight + TitleLabel.Spacing.top
    let searchBarHeightAndTopSpacing = SearchWithCancelView.Constant.height + SearchBar.Spacing.top
    let okButtonHeightAndTopBottomSpacing = OkButton.height + OkButton.Spacing.top + OkButton.Spacing.bottom
    return .init(
      width: 150,
      height: (
        superViewIntrinsicHeight
        + titleHeightAndTopSpacing
        + searchBarHeightAndTopSpacing
        + okButtonHeightAndTopBottomSpacing))
  }
  
  // MARK: - Lifecycle
  init(title: String) {
    super.init(radius: Constant.radius)
    titleLabel.text = title
    translatesAutoresizingMaskIntoConstraints = false
    configureContentView()
    backgroundColor = .white
    bind()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    titleLabel.text = "Setting"
    translatesAutoresizingMaskIntoConstraints = false
    configureContentView()
    backgroundColor = .white
    bind()
  }
}

// MARK: - Helpers
extension FavoriteDirectorySettingView {
  func setSearchBarInputAccessory(_ view: UIView) {
    searchBar.setTextFieldInputAccessory(view)
  }
  
  func hideKeyboard() {
    searchBar.hideKeyboard()
  }
  
  func showKeyboard() {
    searchBar.showKeyboard()
  }
}

// MARK: - Private Helpers
private extension FavoriteDirectorySettingView {
  func bind() {
    searchBar.textClear = {
      self.searchBar.editingState = .origin
      self.setOkButtonNotWorkingUI()
    }
    
    okButton.tapHandler = {
      self.delegate?.favoriteDirectorySettingView(self, didTapOkButton: self.okButton)
    }
    
    subscription = searchBar
      .changed
      .sink { [weak self] in
        let minLength = Constant.minimumTextLength
        let maxLength = Constant.maximumTextLength
        if (minLength..<maxLength).contains($0.count) && self?.editingState != .good {
          self?.searchBar.editingState = .good
          self?.setOkButtonWorkingUI()
        } else if $0.count >= maxLength && self?.editingState != .excess {
          self?.searchBar.editingState = .excess
          self?.searchBar.showTextExcessAlertLabel()
          self?.setOkButtonNotWorkingUI()
        } else if $0.count == 0 && self?.editingState != .origin {
          self?.searchBar.editingState = .origin
          self?.setOkButtonNotWorkingUI()
        }
      }
  }
  
  func setOkButtonNotWorkingUI() {
    okButton.currentState = .normal
    okButton.isUserInteractionEnabled = false
  }
  
  func setOkButtonWorkingUI() {
    okButton.currentState = .selected
    okButton.isUserInteractionEnabled = true
  }
  
  func configureContentView() {
    setContentView(.init(frame: .zero).set { contentView in
      contentView.translatesAutoresizingMaskIntoConstraints = false
      _=[
        titleLabel,
        searchBar,
        okButton
      ].map {
        contentView.addSubview($0)
      }
      
      _=[
        setTitleLabelConstraints(with: contentView),
        setSearchBarCosntraints(with: contentView),
        setOkButtonConstraints(with: contentView)
      ].map {
        NSLayoutConstraint.activate($0)
      }
    })
  }
  
  // MARK: - Layout
  func setTitleLabelConstraints(with contentView: UIView) -> [NSLayoutConstraint] {
    typealias Const = Constant.TitleLabel
    typealias Spacing = Const.Spacing
    return [
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.top)
    ]
  }
  
  func setSearchBarCosntraints(with contentView: UIView) -> [NSLayoutConstraint] {
    typealias Const = Constant.SearchBar
    typealias Spacing = Const.Spacing
    return [
      searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.top),
      searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
  
  func setOkButtonConstraints(with contentView: UIView) -> [NSLayoutConstraint] {
    typealias Const = Constant.OkButton
    typealias Spacing = Const.Spacing
    return [
      okButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      okButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing),
      okButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Spacing.top),
      okButton.heightAnchor.constraint(equalToConstant: Const.height),
      okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.bottom)]
  }
}

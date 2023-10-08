//
//  FavoriteTableViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
  // MARK: - Identifier
  static let id: String = String(describing: PostCell.self)
  
  struct Model {
    let title: String
    let innerItemCount: Int
    let imageURL: String?
  }
  
  enum Constant {
    static let deleteControlWidth = FavoriteViewController.Constant.deleteControlWidth
    enum DeleteButton {
      enum Spacing {
        static let leading: CGFloat = 14
      }
      static let size: CGSize = .init(width: 20, height: 20)
    }
    
    enum QuarterImageView {
      enum Spacing {
        static let leading: CGFloat = 16
      }
      static let size = CGSize(width: 40, height: 40)
    }
    
    enum TitleLabel {
      enum Spacing {
        static let leading: CGFloat = 15
        static let trailing: CGFloat = 44
      }
      static let textColor: UIColor = .yg.gray6
      static let fontName: UIFont.Pretendard = .medium
      static let textSize: CGFloat = 15.0
    }
    
    enum TitleTextField {
      enum Spacing {
        static let leading: CGFloat = 20
        static let trailing: CGFloat = {
          if #available(iOS 11.0, *) {
            let deviceWidth = UIScreen.main.bounds.width
            if deviceWidth >= 414 {
              return 60 + deleteControlWidth
            }
          }
          return 50 + deleteControlWidth
        }()
      }
      static let height: CGFloat = 25
      static let textColor: UIColor = .yg.gray6
      static let fontName: UIFont.Pretendard = .medium
      static let textSize: CGFloat = 14.0
      static let borderWidth: CGFloat = 0.3
      static let borderColor: UIColor = .yg.gray3
      static let radius: CGFloat = 3
    }
    
    enum MenuAccessoryView {
      static let iconName = "cellMenuAccessory"
      static let size: CGSize = .init(width: 24, height: 24)
      enum Spacing {
        static let trailing: CGFloat = {
          if #available(iOS 11.0, *) {
            let deviceWidth = UIScreen.main.bounds.width
            if deviceWidth >= 414 {
              return 21 + deleteControlWidth
            }
          }
          return 11 + deleteControlWidth
        }()
      }
    }
  }

  // MARK: - Properties
  private var deleteButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(UIImage(named: "deleteMinusIcon"), for: .normal)
  }
  
  private lazy var quarterImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.gray1
    $0.layer.cornerRadius = Constant.QuarterImageView.size.width/2.0
    $0.clipsToBounds = true
  }
  
  private let titleLabel = UILabel().set {
    typealias Const = Constant.TitleLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.textColor = Const.textColor
    $0.font = .init(pretendard: Const.fontName, size: Const.textSize)
  }
  
  private lazy var titleTextField = UITextField().set {
    typealias Const = Constant.TitleTextField
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont(pretendard: Const.fontName, size: Const.textSize)
    $0.textColor = Const.textColor
    $0.layer.borderWidth = Const.borderWidth
    $0.layer.borderColor = Const.borderColor.cgColor
    $0.layer.cornerRadius = 3
    $0.keyboardType = .default
    $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 0))
    $0.rightView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 0))
    $0.leftViewMode = .always
    $0.rightViewMode = .always
  }
  
  private let menuAccessoryView = UIImageView(frame: .zero).set {
    typealias Const = Constant.MenuAccessoryView
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: Const.iconName)
    $0.contentMode = .scaleAspectFit
    $0.alpha = 0
  }
  
  // MARK: - Lifecycle
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    if editing {
      setEditingMode()
    } else {
      releaseEditingMode()
    }
  }
}

// MARK: - Helpers
extension FavoriteTableViewCell {
  func configure(with data: Model?) {
    let combinedTitle = titleAndInnerItemCount(data?.title, itemCount: data?.innerItemCount)
    self.titleLabel.text = combinedTitle
    guard let imageURL = data?.imageURL else {
      quarterImageView.image = nil
      return
    }
    self.quarterImageView.image = UIImage(named: imageURL)
    titleTextField.text = data?.title
  }
}

// MARK: - Private helpers
private extension FavoriteTableViewCell {
  private func titleAndInnerItemCount(_ title: String?, itemCount: Int?) -> String {
    return "\(title ?? "미정") (\((itemCount ?? 0).zeroPaddingString))"
  }
  
  private func setEditingMode() {
    titleTextField.isUserInteractionEnabled = true
    quarterImageView.isHidden = true
    titleLabel.isHidden = true
    titleTextField.isHidden = false
    contentView.subviews.forEach { subview in
      UIView.animate(
        withDuration: 0.37,
        delay: 0,
        options: .curveEaseOut,
        animations: {
          subview.transform = .init(translationX: Constant.deleteControlWidth, y: 0 )
        })
    }
    UIView.animate(
      withDuration: 0.27,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.menuAccessoryView.alpha = 1
      })
  }
  
  private func releaseEditingMode() {
    titleTextField.isUserInteractionEnabled = false
    quarterImageView.isHidden = false
    titleLabel.isHidden = false
    titleTextField.isHidden = true
    menuAccessoryView.alpha = 0
    contentView.subviews.forEach { subview in
      UIView.animate(
        withDuration: 0.37,
        delay: 0,
        options: .curveEaseOut,
        animations: {
          subview.transform = .identity
        })
    }
  }
}

// MARK: - LayoutSupport
extension FavoriteTableViewCell: LayoutSupport {
  func addSubviews() {
    _=[
      quarterImageView,
      titleLabel,
      deleteButton,
      titleTextField,
      menuAccessoryView
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      quarterImageViewConstraints,
      titleLabelConstraints,
      deleteButtonConstraints,
      titleTextFieldConstraints,
      menuAccessoryViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constriants
private extension FavoriteTableViewCell {
  var quarterImageViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.QuarterImageView
    typealias Spacing = Const.Spacing
    return [
      quarterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      quarterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      quarterImageView.heightAnchor.constraint(equalToConstant: Const.size.height),
      quarterImageView.widthAnchor.constraint(equalToConstant: Const.size.width)]
  }
  
  var titleLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TitleLabel.Spacing
    return [
      titleLabel.leadingAnchor.constraint(equalTo: quarterImageView.trailingAnchor, constant: Spacing.leading),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
  
  var deleteButtonConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.DeleteButton
    typealias Spacing = Const.Spacing
    return [
      deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -Const.size.width),
      deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      deleteButton.widthAnchor.constraint(equalToConstant: Const.size.width),
      deleteButton.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
  
  var titleTextFieldConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TitleTextField
    typealias Spacing = Const.Spacing
    return [
      titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing),
      titleTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleTextField.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var menuAccessoryViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.MenuAccessoryView
    typealias Spacing = Const.Spacing
    return [
      menuAccessoryView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Const.Spacing.trailing),
      menuAccessoryView.widthAnchor.constraint(equalToConstant: Const.size.width),
      menuAccessoryView.heightAnchor.constraint(equalToConstant: Const.size.height),
      menuAccessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)]
  }
}

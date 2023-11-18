//
//  PostDetailProfileAreaFooterView.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import UIKit

final class PostDetailProfileAreaFooterView: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailProfileAreaFooterView.self)
  
  enum Constant {
    enum ProfileAreaViewSpacing {
      static let leaidng: CGFloat = 10
      static let trailing: CGFloat = 10
      static let top: CGFloat = 10
    }
    enum Divider {
      enum Spacing {
        static let top: CGFloat = 13
      }
      static let height: CGFloat = 1
    }
  }
  
  // MARK: - Properties
  private let profileAreaView = PostDetailProfileAreaView()
  
  private let profileAreaViewDivider = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.gray0
  }
  
  weak var delegate: BaseProfileAreaViewDelegate? {
    get {
      profileAreaView.baseDelegate
    } set {
      profileAreaView.baseDelegate = newValue
    }
  }
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
  
}

// MARK: - Helpers
extension PostDetailProfileAreaFooterView {
  func configure(with info: PostDetailProfileAreaInfo?) {
    profileAreaView.configure(with: info)
  }
}

// MARK: - LayoutSupport
extension PostDetailProfileAreaFooterView: LayoutSupport {
  func addSubviews() {
    _=[
      profileAreaView,
      profileAreaViewDivider
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      profileAreaViewConstraints,
      profileAreaViewDividerConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostDetailProfileAreaFooterView {
  var profileAreaViewConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.ProfileAreaViewSpacing
    return [
      profileAreaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leaidng),
      profileAreaView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.top),
      profileAreaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
  
  var profileAreaViewDividerConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.Divider
    typealias Spacing = Const.Spacing
    let dividerBottomConstriant = profileAreaViewDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    dividerBottomConstriant.priority = .defaultLow
    return [
      profileAreaViewDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      profileAreaViewDivider.topAnchor.constraint(equalTo: profileAreaView.bottomAnchor, constant: Spacing.top),
      profileAreaViewDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      dividerBottomConstriant,
      profileAreaViewDivider.heightAnchor.constraint(equalToConstant: Const.height)]
  }
}

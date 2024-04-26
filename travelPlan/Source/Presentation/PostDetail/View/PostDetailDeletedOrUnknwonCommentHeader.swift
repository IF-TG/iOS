//
//  PostDetailDeletedOrUnknwonCommentHeader.swift
//  travelPlan
//
//  Created by 양승현 on 4/10/24.
//

import UIKit

final class PostDetailDeletedOrUnknwonCommentHeader: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailDeletedOrUnknwonCommentHeader.self)
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    makeDeletedOrUnknownCommentView()
  }
  
  required init?(coder: NSCoder) { nil }
}

// MARK: - Private Helpers
private extension PostDetailDeletedOrUnknwonCommentHeader {
  func makeDeletedOrUnknownCommentView() {
    let label = BaseLabel(fontType: .medium_500(fontSize: 14)).set {
      $0.textColor = .yg.gray7
      $0.numberOfLines = 1
      $0.text = "알 수 없는 사용자"
    }
    let comment = BaseLabel(fontType: .regular_400(fontSize: 14)).set {
      $0.textColor = .yg.gray7
      $0.numberOfLines = 1
      $0.text = "댓글이 삭제되었거나 존재하지 않는 댓글입니다."
    }
    
    let contentStackView = UIStackView(arrangedSubviews: [label, comment]).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.axis = .vertical
      $0.spacing = 6
      $0.alignment = .leading
      $0.distribution = .equalSpacing
    }
    let baseView = BaseProfileAreaView(
      frame: .zero,
      contentView: contentStackView,
      contentViewSpacing: .init(top: 3, left: 10, bottom: 3, right: 30),
      profileLayoutInfo: .medium(.top)).set {
        $0.translatesAutoresizingMaskIntoConstraints = false
      }
    baseView.configure(with: UIImage(named: "default_profile_icon")?.pngData())
    contentView.addSubview(baseView)
    let baseViewBottomAnchor = baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    baseViewBottomAnchor.priority = .defaultLow
    NSLayoutConstraint.activate([
      baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
      baseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
      baseViewBottomAnchor])

  }
}

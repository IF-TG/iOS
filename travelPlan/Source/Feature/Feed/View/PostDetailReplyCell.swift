//
//  PostDetailReplyCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

import UIKit

struct PostReplyInfo {
  var isFirstReply: Bool
  var commentInfo: BasePostDetailCommentInfo
}

final class PostDetailReplyCell: UITableViewCell {
  static let id = String(describing: PostDetailReplyCell.self)
  
  // MARK: - Properties
  private let replyView = BasePostDetailCommentableView(usageType: .reply)
  
  private let replyIcon = UIImageView(frame: .zero).set {
    $0.contentMode = .scaleAspectFill
  }
  
  private var isFirstReply = false {
    didSet {
      let color: UIColor = isFirstReply ? .yg.gray4 : .white
      replyIcon.image = UIImage(named: "cornerDownRight")?.setColor(color)
    }
  }
  
  weak var delegate: BaseCommentViewDelegate? {
    get {
      replyView.delegate
    } set {
      replyView.delegate = newValue
    }
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
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
extension PostDetailReplyCell {
  func configure(with info: PostReplyInfo?) {
    replyView.configure(with: info?.commentInfo)
    isFirstReply = info?.isFirstReply ?? false
  }
}

// MARK: - Private Helpers
extension PostDetailReplyCell {
  func configureUI() {
    selectionStyle = .none
    setupUI()
  }
}

// MARK: - LayoutSupport
extension PostDetailReplyCell: LayoutSupport {
  func addSubviews() {
    [replyIcon,
     replyView
    ].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    let replyViewBottomCosntriant = replyView.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor, 
      constant: -9)
    replyViewBottomCosntriant.priority = .defaultLow
    
    NSLayoutConstraint.activate([
      replyIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      replyIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
      replyIcon.widthAnchor.constraint(equalToConstant: 20),
      replyIcon.heightAnchor.constraint(equalToConstant: 20),
      
      replyView.leadingAnchor.constraint(equalTo: replyIcon.trailingAnchor, constant: 10),
      replyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
      replyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      replyViewBottomCosntriant])
  }
}

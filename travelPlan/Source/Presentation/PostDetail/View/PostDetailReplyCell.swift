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

protocol PostDetailReplyCellDelegate: AnyObject {
  func didTapProfile(_ cell: UITableViewCell)
  func didTapHeart(_ cell: UITableViewCell, isOnHeart: Bool)
  func didCanceledHeart(_ cell: UITableViewCell)
  func didTapReply(_ cell: UITableViewCell)
}

final class PostDetailReplyCell: UITableViewCell {
  static let id = String(describing: PostDetailReplyCell.self)
  
  // MARK: - Properties
  private let replyView = BasePostDetailCommentableView(usageType: .reply)
  
  private let replyIcon = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
  }
  
  private var isFirstReply = false {
    didSet {
      let color: UIColor = isFirstReply ? .yg.gray4 : .white
      replyIcon.image = UIImage(named: "cornerDownRight")?.setColor(color)
    }
  }
  
  weak var delegate: PostDetailReplyCellDelegate?
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    replyView.delegate = self
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
    contentView.backgroundColor = .yg.gray00Background
    isUserInteractionEnabled = true
    setupUI()
  }
}

// MARK: - BaseCommentViewDelegate
extension PostDetailReplyCell: BaseCommentViewDelegate {  
  func didTapHeart(_ isOnHeart: Bool) {
    delegate?.didTapHeart(self, isOnHeart: isOnHeart)
  }
  
  func didCanceledHeart() {
    delegate?.didCanceledHeart(self)
  }
  
  func didTapReply() {
    delegate?.didTapReply(self)
  }
  
  func didTapProfile() {
    delegate?.didTapProfile(self)
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

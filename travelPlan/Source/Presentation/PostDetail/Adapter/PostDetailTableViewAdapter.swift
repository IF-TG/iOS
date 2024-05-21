//
//  PostDetailTableViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailTableViewAdapter: NSObject {
  typealias PostDetailTableViewDelegates = (
    PostDetailTableViewAdapterDelegate &
    PostDetailReplyCellDelegate &
    PostDetailCommentDelegate &
    PostHeartAndShareAreaHeaderViewDelegate)
  
  // MARK: - Properties
  private weak var dataSource: PostDetailTableViewDataSource?
  
  private weak var chatDataSource: PostDetailChatDataSource?
  
  weak var delegate: PostDetailTableViewDelegates?
  
  private let defaultSection = PostDetailSection.defaultNumberOfSections
  
  private var postTitleCellMaxY: CGFloat?
  
  private var postDurationLabelMaxY: CGFloat?
  
  private var tableViewInitialOffsetY: CGFloat?
  
  private var isDisplyingTitleInNavi: Bool = false
  
  private var isDisplyingDurationInNavi: Bool = false
  
  var numberOfSections: Int {
    (dataSource?.numberOfSections ?? 0) + (chatDataSource?.numberOfSections ?? 0)
  }
  
  // MARK: - Lifecycle
  init(
    dataSource: PostDetailTableViewDataSource?,
    chatDataSource: PostDetailChatDataSource?,
    delegate: PostDetailTableViewDelegates?,
    tableView: UITableView
  ) {
    super.init()
    self.dataSource = dataSource
    self.chatDataSource = chatDataSource
    self.delegate = delegate
    tableView.dataSource = self
    tableView.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension PostDetailTableViewAdapter: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let detailSection = PostDetailSection(rawValue: section)
    switch detailSection {
    case .postDescription, .postContent, .postHeartAndShareArea:
      return dataSource?.numberOfRows(in: section) ?? 0
    case .comments(let int):
      return chatDataSource?.numberOfRows(in: detailSection) ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sectionType = PostDetailSection(rawValue: indexPath.section)
    guard let dataSource else { return .init(frame: .zero) }
    switch sectionType {
    case .postDescription:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: PostDetailTitleCell.id,
        for: indexPath
      ) as? PostDetailTitleCell else {
        return .init(frame: .zero)
      }
      cell.configure(with: dataSource.title)
      return cell
    case .postContent:
      let postContentItem = dataSource.postContentItem(at: indexPath.row)
      switch postContentItem {
      case .text(let text):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: PostDetailContentTextCell.id,
          for: indexPath
        ) as? PostDetailContentTextCell else {
          return .init(frame: .zero)
        }
        cell.configure(with: text)
        return cell
      case .image(let imagePath):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: PostDetailContentImageCell.id,
          for: indexPath
        ) as? PostDetailContentImageCell  else {
          return .init(frame: .zero)
        }
        cell.configure(with: imagePath)
        return cell
      }
    default:
      guard
        let cell = tableView.dequeueReusableCell(
          withIdentifier: PostDetailReplyCell.id,
          for: indexPath
        ) as? PostDetailReplyCell,
        let chatDataSource
      else {
        return .init(frame: .zero)
      }
      cell.configure(with: chatDataSource.replyItem(at: indexPath))
      cell.delegate = self
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension PostDetailTableViewAdapter: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if cell is PostDetailTitleCell {
      postTitleCellMaxY = cell.frame.maxY
      isDisplyingTitleInNavi = true
    }
    // TODO: - 서버에서 만약 댓글달았을때 에대한 bool값 있으면 배ㅁ경색 파랑 -> 원래색으로 돌아오는 피그마 ui추가.
    // MARK: - 내가 댓글이나 대댓글 달았을때 적용하자. RESTFul에선 실시간으로 댓글달린거 갱신이 불가능!!
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionType = PostDetailSection(rawValue: section)
    guard let dataSource else { return nil }
    switch sectionType {
    case .postDescription:
      guard let header = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailCategoryHeaderView.id
      ) as? PostDetailCategoryHeaderView else {
        return nil
      }
      header.configure(with: dataSource.cateogry)
      return header
    case .postContent:
      return nil
    case .postHeartAndShareArea:
      guard let postHeartAreaHeader = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostHeartAndShareAreaHeaderView.id
      ) as? PostHeartAndShareAreaHeaderView else {
        return nil
      }
      postHeartAreaHeader.delegate = self
      return postHeartAreaHeader
    default:
      guard let chatDataSource else { return nil }
      let cellInfo = chatDataSource.commentItem(in: PostDetailSection(rawValue: section))
      if cellInfo.isDeleted {
        guard let commentHeader = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: PostDetailDeletedOrUnknwonCommentHeader.id
        ) as? PostDetailDeletedOrUnknwonCommentHeader else {
          return nil
        }
        return commentHeader
      }
      
      guard let commentHeader = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailCommentHeader.id
      ) as? PostDetailCommentHeader else {
        return nil
      }
      commentHeader.configure(with: cellInfo.baseInfo)
      commentHeader.delegate = self
      return commentHeader
    }
    
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let sectionType = PostDetailSection(rawValue: section)
    guard let dataSource else { return nil }
    switch sectionType {
    case .postDescription:
      guard let footer = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailProfileAreaFooterView.id
      ) as? PostDetailProfileAreaFooterView else {
        return nil
      }
      if let specificHeight = footer.getHeightBelowDurationLabelMaxY() {
        postDurationLabelMaxY = footer.frame.maxY - specificHeight
      }
      footer.configure(with: dataSource.profileAreaItem)
      return footer
    case .postContent:
      guard let footer = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailContentFooterView.id
      ) as? PostDetailContentFooterView else {
        return nil
      }
      return footer
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let sectionType = PostDetailSection(rawValue: section)
    switch sectionType {
    case .postDescription:
      return UITableView.automaticDimension
    case .postContent:
      return 11
    case .postHeartAndShareArea:
      return .leastNonzeroMagnitude
    default:
      return .leastNonzeroMagnitude
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let sectionType: PostDetailSection = PostDetailSection(rawValue: section)
    switch sectionType {
    case .postDescription,
        .postHeartAndShareArea:
      return UITableView.automaticDimension
    case .postContent:
      return 0
    default:
      return (numberOfSections - defaultSection <= 0)
              ? .leastNonzeroMagnitude : UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let sectionType = PostDetailSection(rawValue: section)
    if sectionType == .postDescription {
      let header = view as? PostDetailCategoryHeaderView
      if header?.delegate != nil { return }
      header?.delegate = self
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    let sectionType = PostDetailSection(rawValue: section)
    if sectionType == .postDescription {
      let footer = view as? PostDetailProfileAreaFooterView
      if footer?.delegate != nil { return }
      footer?.delegate = self
    }
  }
}

// MARK: - ScrollViewDelegate
extension PostDetailTableViewAdapter {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    if tableViewInitialOffsetY == nil { tableViewInitialOffsetY = scrollView.contentOffset.y }
    guard let postTitleCellMaxY, let tableViewInitialOffsetY, let postDurationLabelMaxY else { return }
    let isDurationBehindNavigationBarDisappeared = tableViewInitialOffsetY + postDurationLabelMaxY > offsetY
    if isDurationBehindNavigationBarDisappeared {
      if !isDisplyingDurationInNavi {
        isDisplyingDurationInNavi.toggle()
        delegate?.willDisplayDurationInTableView()
      }
    } else {
      if isDisplyingDurationInNavi {
        isDisplyingDurationInNavi.toggle()
        delegate?.disappearDurationInTableView()
      }
    }
    
    let isTitleBehindANavigationBarDisappeared = tableViewInitialOffsetY + postTitleCellMaxY > offsetY
    if isTitleBehindANavigationBarDisappeared {
      if !isDisplyingTitleInNavi {
        isDisplyingTitleInNavi.toggle()
        delegate?.willDisplayTitleInTableView()
      }
    } else {
      if isDisplyingTitleInNavi {
        isDisplyingTitleInNavi.toggle()
        delegate?.disappearTitleInTableView()
      }
    }
  }
}

// MARK: - PostDetailCategoryHeaderViewDelegate
extension PostDetailTableViewAdapter: PostDetailCategoryHeaderViewDelegate {
  func didTapCategoryHeaderView(_ sender: UITapGestureRecognizer) {
    delegate?.showCategoryDetailPage()
  }
}

// MARK: - BaseProfileAreaViewDelegate
extension PostDetailTableViewAdapter: BaseProfileAreaViewDelegate {
  func baseLeftRoundProfileAreaView(_ view: BaseProfileAreaView, didSelectProfileImage image: UIImage?) {
    guard let dataSource = dataSource else { return }
    delegate?.showUploadedUserProfilePage(with: dataSource.authorUserId)
  }
}

// MARK: - PostDetailReplyCellDelegate
extension PostDetailTableViewAdapter: PostDetailReplyCellDelegate {
  func didTapOption(_ cell: UITableViewCell) {
    delegate?.didTapOption(cell)
  }
  
  func didTapProfile(_ cell: UITableViewCell) {
    delegate?.didTapProfile(cell)
  }
  
  func didTapHeart(_ cell: UITableViewCell, isOnHeart: Bool) {
    delegate?.didTapHeart(cell, isOnHeart: isOnHeart)
  }
  
  func didCanceledHeart(_ cell: UITableViewCell) {
    delegate?.didCanceledHeart(cell)
  }
}

// MARK: - PostDetailCommentDelegate
extension PostDetailTableViewAdapter: PostDetailCommentDelegate {
  func didTapOption(_ header: UITableViewHeaderFooterView) {
    delegate?.didTapOption(header)
  }
  
  func didTapHeart(_ header: UITableViewHeaderFooterView, _ isOnHeart: Bool) {
    delegate?.didTapHeart(header, isOnHeart)
  }
  
  func didTapCanceledHeart(_ header: UITableViewHeaderFooterView) {
    delegate?.didTapCanceledHeart(header)
  }
  
  func didTapReply(_ header: UITableViewHeaderFooterView) {
    delegate?.didTapReply(header)
  }
  
  func didTapProfile(_ header: UITableViewHeaderFooterView) {
    delegate?.didTapProfile(header)
  }
}

// MARK: - PostHeartAndShareAreaHeaderViewDelegate
extension PostDetailTableViewAdapter: PostHeartAndShareAreaHeaderViewDelegate {
  func didTapOption() {
    delegate?.didTapOption()
  }
  
  func didTapHeart(isFavorite: Bool) {
    delegate?.didTapHeart(isFavorite: isFavorite)
  }
  
  func didTapShare() {
    delegate?.didTapShare()
  }
}

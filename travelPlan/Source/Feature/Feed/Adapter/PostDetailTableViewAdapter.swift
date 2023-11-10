//
//  PostDetailTableViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailTableViewAdapter: NSObject {
  // MARK: - Properties
  private weak var dataSource: PostDetailTableViewDataSource?
  weak var delegate: PostDetailTableViewAdapterDelegate?
  
  private let defaultSection = 2
  
  // MARK: - Lifecycle
  init(
    dataSource: PostDetailTableViewDataSource?,
    delegate: PostDetailTableViewAdapterDelegate?,
    tableView: UITableView
  ) {
    super.init()
    self.dataSource = dataSource
    self.delegate = delegate
    tableView.dataSource = self
    tableView.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension PostDetailTableViewAdapter: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource?.numberOfSections ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource?.numberOfItems(in: section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dataSource else { return .init(frame: .zero) }
    let sectionType: PostDetailSectionType = .init(rawValue: indexPath.section) ?? .postDescription
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
      /// 댓글
      return .init(frame: .zero)
    }
  }
}

// MARK: - UITableViewDelegate
extension PostDetailTableViewAdapter: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didEndDisplaying cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    let sectionType: PostDetailSectionType = .init(rawValue: indexPath.section) ?? .postDescription
    if sectionType == .postDescription && indexPath.row == 0 {
      guard let title = dataSource?.title else { return }
      delegate?.disappearTitle(title)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if cell is PostDetailTitleCell {
      delegate?.willDisplayTitle()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let dataSource else { return nil }
    switch section {
    case 0:
      guard let header = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailCategoryHeaderView.id
      ) as? PostDetailCategoryHeaderView else {
        return nil
      }
      header.configure(with: dataSource.cateogry)
      return header
    case 1:
      return nil
    default:
      guard let commentHeader = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailCommentHeader.id
      ) as? PostDetailCommentHeader else {
        return nil
      }
      commentHeader.configure(with: dataSource.commentItem(in: section))
      return commentHeader
    }
    
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard
      let dataSource,
      let sectionType: PostDetailSectionType = .init(rawValue: section)
    else { return nil }
    switch sectionType {
    case .postDescription:
      guard let footer = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: PostDetailProfileAreaFooterView.id
      ) as? PostDetailProfileAreaFooterView else {
        return nil
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
    guard let sectionType: PostDetailSectionType = .init(rawValue: section) else { return 0 }
    switch sectionType {
    case .postDescription:
      return UITableView.automaticDimension
    case .postContent:
      return 11
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard 
      let sectionType: PostDetailSectionType = .init(rawValue: section),
      let dataSource
    else { return 0 }
    switch sectionType {
    case .postDescription:
      return UITableView.automaticDimension
    case .postContent:
      return 0
    default:
      return (dataSource.numberOfSections - defaultSection <= 0) ? 0 : UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let sectionType: PostDetailSectionType = .init(rawValue: section) else { return }
    if sectionType == .postDescription {
      let header = view as? PostDetailCategoryHeaderView
      if header?.delegate != nil { return }
      header?.delegate = self
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    guard let sectionType: PostDetailSectionType = .init(rawValue: section) else { return }
    if sectionType == .postDescription {
      let footer = view as? PostDetailProfileAreaFooterView
      if footer?.delegate != nil { return }
      footer?.delegate = self
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
    delegate?.showUploadedUserProfilePage(with: dataSource.profileAreaItem.userId)
  }
}

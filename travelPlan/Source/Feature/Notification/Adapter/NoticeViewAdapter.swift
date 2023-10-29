//
//  NoticeViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit

final class NoticeViewAdapter: NSObject {
  // MARK: - Propreties
  private let dataSource: NoticeViewAdapterDataSource?
  weak var delegate: NoticeViewAdapterDelegate?
  
  // MARK: - Lifecycle
  init(
    dataSource: NoticeViewAdapterDataSource?,
    tableView: UITableView?
  ) {
    self.dataSource = dataSource
    super.init()
    tableView?.dataSource = self
    tableView?.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension NoticeViewAdapter: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource?.numberOfItems ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let item = dataSource?.getItem(indexPath),
      let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.id, for: indexPath) as? NoticeCell 
    else {
      return .init(frame: .zero)
    }
    cell.configure(with: item)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension NoticeViewAdapter: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as? NoticeCell
    tableView.performBatchUpdates({
      cell?.isExpended.toggle()
      UIView.animate(
        withDuration: 0.38,
        delay: 0,
        options: [.curveEaseInOut],
        animations: {
          cell?.contentView.layoutIfNeeded()
        })
    }, completion: { _ in
      self.delegate?.noticeViewAdapter(self, didSelectRowAt: indexPath, isExpended: cell?.isExpended ?? false)
    })
  }
}

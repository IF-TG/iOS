//
//  NotificationViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import UIKit

protocol NotificationViewAdapterDelegate: AnyObject {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  func didTapDeleteButton(_ cell: UITableViewCell)
}

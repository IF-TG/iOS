//
//  HeaderFooterViewResuable.swift
//  travelPlan
//
//  Created by 양승현 on 6/2/24.
//

import UIKit

protocol HeaderFooterViewResuable {}

extension HeaderFooterViewResuable where Self: UITableView {
  func dequeueReusableHeaderFooterView<R>(
    type: R.Type
  ) -> R? where R: UITableViewHeaderFooterView {
    return self.dequeueReusableHeaderFooterView(
      withIdentifier: R.identifier
    ) as? R
  }
}

extension UITableView: HeaderFooterViewResuable {}

//
//  HeaderFooterViewResuable.swift
//  travelPlan
//
//  Created by 양승현 on 6/2/24.
//

import UIKit

protocol HeaderFooterViewResuable {}

extension HeaderFooterViewResuable where Self: UITableView, Self: HeaderFooterViewIdentifiable {
  func dequeueResuableHeaderFooterView<R>(
    type: R.Type
  ) -> R? where R: HeaderFooterViewIdentifiable, R: UITableViewHeaderFooterView {
    return self.dequeueReusableHeaderFooterView(
      withIdentifier: R.identifier
    ) as? R
  }
}

extension UITableView: HeaderFooterViewResuable {}

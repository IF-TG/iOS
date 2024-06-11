//
//  ScrollableViewRegister.swift
//  travelPlan
//
//  Created by 양승현 on 6/2/24.
//

import UIKit

protocol ScrollableViewRegister { }
extension ScrollableViewRegister where Self: UITableView {
  /// tableView reusable cell register
  func register<R>(type: R.Type) where R: UITableViewCell {
    self.register(type.self, forCellReuseIdentifier: R.identifier)
  }
  
  /// tableView resuable header footer view register
  func register<R>(type: R.Type) where R: UITableViewHeaderFooterView, R: HeaderFooterViewIdentifiable {
    self.register(type.self, forHeaderFooterViewReuseIdentifier: R.identifier)
  }
}

extension ScrollableViewRegister where Self: UICollectionView {
  func register<R>(type: R.Type) where R: UICollectionViewCell {
    self.register(R.self, forCellWithReuseIdentifier: R.identifier)
  }
  
  // TODO: - Supplimentary view도 register 추가하기.
  // func register<R>
}

extension UITableView: ScrollableViewRegister {}
extension UICollectionView: ScrollableViewRegister {}

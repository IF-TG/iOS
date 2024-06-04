//
//  CellReusable.swift
//  travelPlan
//
//  Created by 양승현 on 6/2/24.
//

import UIKit

/// 재사용 가능한 큐에서 cell을 꺼내올 때 원하는 제너릭 R.Type의 R로 캐스팅해서 반환합니다.
/// 실패할 경우 nil을 반환합니다.
protocol CellReusable {}

extension CellReusable where Self: UICollectionView {
  func dequeueReusableCell<R>(
    for indexPath: IndexPath,
    type: R.Type
  ) -> R? where R: UICollectionViewCell & CellIdentifiable {
    return self.dequeueReusableCell(
      withReuseIdentifier: R.identifier,
      for: indexPath
    ) as? R
  }
}

extension CellReusable where Self: UITableView {
  func dequeueReusableCell<R>(
    for indexPath: IndexPath,
    type: R.Type
  ) -> R? where R: UITableViewCell & CellIdentifiable {
    return self.dequeueReusableCell(
      withIdentifier: R.identifier,
      for: indexPath
    ) as? R
  }
}

extension UICollectionView: CellReusable {}
extension UITableView: CellReusable {}

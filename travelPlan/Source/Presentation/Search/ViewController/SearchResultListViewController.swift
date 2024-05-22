//
//  SearchResultListViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 5/20/24.
//

import UIKit
import Combine

final class SearchResultListViewController: UIViewController {
  // MARK: - Properties
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).set {
    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
//    $0.dataSource = self
  }
//    .set {
//    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
//    $0.delegate = self
//    $0.dataSource = self
//  })
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

// MARK: - UICollectionViewDataSource
//extension SearchResultListViewController: UICollectionViewDataSource {
//  func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath
//  ) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(
//      withReuseIdentifier: TravelDestinationCell.id,
//      for: indexPath
//    ) as? TravelDestinationCell else { return .init() }
//    
//    cell.configure(
//      with: TravelDestinationCellInfo(id: <#T##Int#>,
//                                      place: <#T##String#>,
//                                      secondText: <#T##String#>,
//                                      thirdText: <#T##String#>, isSelectedButton: <#T##Bool#>)
//    )
//  }
//}

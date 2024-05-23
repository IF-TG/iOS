////
////  SearchResultListViewController.swift
////  travelPlan
////
////  Created by SeokHyun on 5/20/24.
////
//
//import UIKit
//import Combine
//
//final class SearchResultListViewController: UIViewController {
//  // MARK: - Properties
//  private lazy var collectionView = UICollectionView(
//    frame: .zero,
//    collectionViewLayout: UICollectionViewFlowLayout()
//  ).set {
//    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
//    $0.dataSource = self
//  }
//  private let input = SearchResultListViewModelInput()
//  
//  // MARK: - LifeCycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//  }
//}
//
//// MARK: - UICollectionViewDataSource
//extension SearchResultListViewController: UICollectionViewDataSource {
//  func collectionView(
//    _ collectionView: UICollectionView,
//    numberOfItemsInSection section: Int
//  ) -> Int {
//    
//  }
//  
//  func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath
//  ) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(
//      withReuseIdentifier: TravelDestinationCell.id,
//      for: indexPath
//    ) as? TravelDestinationCell else { return .init() }
//    
//    cell.configure(with: TravelDestinationInfo(place: "캠핑 타이틀",
//                                  category: "캠핑",
//                                  location: "강원",
//                                  isButtonSelected: false,
//                                  imageData: Data(),
//                                  id: 12345))
//    cell.bind(to: input.didTapStarButton, indexPath: indexPath)
//  }
//}

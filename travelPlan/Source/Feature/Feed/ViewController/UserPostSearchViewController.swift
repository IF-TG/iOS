//
//  UserPostSearchViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit

final class UserPostSearchViewController: UIViewController {
  // MARK: - Properties
  private var dataSource: String?
  
  private lazy var leftAlignedCollectionViewFlowLayout:
  LeftAlignedCollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().set {
    $0.scrollDirection = .vertical
    $0.minimumLineSpacing = 16
    $0.minimumInteritemSpacing = 8
    $0.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
  }
  
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: .init()
  ).set {
    $0.backgroundColor = .systemBackground
    $0.delegate = self
    $0.dataSource = self
    $0.collectionViewLayout = leftAlignedCollectionViewFlowLayout
    $0.register(
      SearchTagCell.self,
      forCellWithReuseIdentifier: SearchTagCell.id
    )
    $0.register(
      TitleSupplementaryView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: TitleSupplementaryView.id
    )
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupUI()
    leftAlignedCollectionViewFlowLayout.headerReferenceSize = CGSize(
      width: self.collectionView.frame.width,
      height: 60
    )
  }
}

// MARK: - Helpers
extension UserPostSearchViewController {

}

// MARK: - LayoutSupport
extension UserPostSearchViewController: LayoutSupport {
  func addSubviews() {
    self.view.addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserPostSearchViewController: UICollectionViewDelegateFlowLayout {
  // cell의 size가 string값에 따라 달라지도록 작업
    // label에 string 대입 후, label의 size를 이용
  
  // FIXME: - UILabel 사이즈 개선
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let dummyLabel = UILabel()
    dummyLabel.font = .systemFont(ofSize: 14)
    
    let widthPadding: CGFloat = 13
    let heightPadding: CGFloat = 4

    if indexPath.section == SearchSection.recommendation.rawValue {
      dummyLabel.text = SearchModel.recommendationSearchKeyword[indexPath.item]
      dummyLabel.sizeToFit()
      
      let labelSize = dummyLabel.frame.size

      return CGSize(
        width: labelSize.width + (widthPadding * 2),
        height: labelSize.height + (heightPadding * 2)
      )
    } else if indexPath.section == SearchSection.recent.rawValue {

      dummyLabel.text = SearchModel.recentSearchKeyword[indexPath.item]
      dummyLabel.sizeToFit()
      
      let labelSize = dummyLabel.frame.size
      
      let cancelButton = UIButton(type: .close)
      let componentPadding: CGFloat = 4

      return CGSize(
        width: labelSize.width + cancelButton.frame.width + componentPadding,
        height: labelSize.height + (heightPadding * 2)
      )
    } else { return CGSize() }
  }
}

// MARK: - UICollectionViewDataSource
extension UserPostSearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SearchSection.allCases.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    if section == SearchSection.recommendation.rawValue {
      return SearchModel.recommendationSearchKeyword.count
    } else if section == SearchSection.recent.rawValue {
      return SearchModel.recentSearchKeyword.count
    } else { return 0 }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    guard let searchTagCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchTagCell.id,
      for: indexPath
    ) as? SearchTagCell else { return UICollectionViewCell() }
    
    // 하나의 Cell class를 재사용해서 변형시키므로, section별로 Cell 구분화
    if indexPath.section == SearchSection.recommendation.rawValue {
      searchTagCell.type = .recommendation
      dataSource = SearchModel.recommendationSearchKeyword[indexPath.item]
    } else if indexPath.section == SearchSection.recent.rawValue {
      searchTagCell.type = .recent
      dataSource = SearchModel.recentSearchKeyword[indexPath.item]
    }
    
    guard let dataSource = dataSource else { return searchTagCell }
    searchTagCell.configure(dataSource)
    
    return searchTagCell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let titleHeaderView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: TitleSupplementaryView.id,
        for: indexPath
      ) as? TitleSupplementaryView else { return UICollectionReusableView() }
      
      titleHeaderView.prepare(title: SearchModel.headerTitle[indexPath.item])
      
      return titleHeaderView
    default:
      return UICollectionReusableView()
    }
  }
}

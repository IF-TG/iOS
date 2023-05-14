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
  let viewModel = UserPostSearchViewModel()
  
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
      UserPostSearchHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: UserPostSearchHeaderView.id
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
  private func fetchHeaderTitle(
    _ headerView: UserPostSearchHeaderView,
    at type: SearchSection
  ) -> String {
    headerView.initSectionType(with: type)
    
    switch type {
    case .recommendation:
      return viewModel.recommendationModel.headerTitle
    case .recent:
      return viewModel.recentModel.headerTitle
    }
  }
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
  // sizeFIXME: - UILabel 사이즈 개선
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let widthPadding: CGFloat = 13
    let heightPadding: CGFloat = 4
    
    if indexPath.section == SearchSection.recommendation.rawValue {
      let text = viewModel.recommendationModel.keywords[indexPath.item]
      let textSize = (text as NSString)
        .size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
      
      return CGSize(
        width: textSize.width + (widthPadding * 2),
        height: textSize.height + (heightPadding * 2)
      )
    } else if indexPath.section == SearchSection.recent.rawValue {
      let text = viewModel.recentModel.keywords[indexPath.item]
      let textSize = (text as NSString)
        .size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
      
      // widthSizeFIXME: - 버튼의 width 계산하기
      // AutoLayout을 사용할 수 없어서 문제를 해결하지 못하여, 임시 방편으로 buttonWidth 상수를 사용했습니다.
      let buttonWidth: CGFloat = 10
      let componentPadding: CGFloat = 4
      
      let width = textSize.width + componentPadding + buttonWidth + (widthPadding * 2)
      
      return CGSize(
        width: width,
        height: textSize.height + (heightPadding * 2)
      )
    } else { return CGSize() }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let searchTagCell = collectionView.cellForItem(at: indexPath) as? SearchTagCell else { return }
    
    switch searchTagCell.sectionType {
    case .recommendation:
      print("추천 검색어: \(viewModel.recommendationModel.keywords[indexPath.item]) tapped")
    case .recent:
      print("추천 검색어: \(viewModel.recentModel.keywords[indexPath.item]) tapped")
    case .none: return
    }
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
      return viewModel.recommendationModel.keywords.count
    } else if section == SearchSection.recent.rawValue {
      return viewModel.recentModel.keywords.count
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
      searchTagCell.initSectionType(with: .recommendation)
      self.dataSource = viewModel.recommendationModel.keywords[indexPath.item]
    } else if indexPath.section == SearchSection.recent.rawValue {
      searchTagCell.initSectionType(with: .recent)
      self.dataSource = viewModel.recentModel.keywords[indexPath.item]
    }
    
    guard let dataSource = self.dataSource else { return searchTagCell }
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
      
      // 최근 검색인 경우 전체삭제 버튼 추가
      guard let titleHeaderView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: UserPostSearchHeaderView.id,
        for: indexPath
      ) as? UserPostSearchHeaderView else { return UICollectionReusableView() }
      
      var titleString = ""
      
      if indexPath.section == SearchSection.recommendation.rawValue {
        titleString = fetchHeaderTitle(titleHeaderView, at: .recommendation)
      } else if indexPath.section == SearchSection.recent.rawValue {
        titleString = fetchHeaderTitle(titleHeaderView, at: .recent)
      } else { return UICollectionReusableView() }
      
      titleHeaderView.prepare(title: titleString)
      
      return titleHeaderView
    default: return UICollectionReusableView()
    }
  }
}

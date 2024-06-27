//
//  PlanCategorySelectionViewController.swift
//  travelPlan
//
//  Created by 양승현 on 6/27/24.
//

import UIKit

fileprivate extension TravelTheme {
  var toPlanSelectionCategory: String {
    let icon: String = switch self {
    case .relaxation: "🍃"
    case .shopping: "🛍️"
    case .campingGlamping: "⛺"
    case .adventure: "🔦"
    case .local: "🪁"
    case .festivals: "🎉"
    }
    return "\(icon) \(self.rawValue)"
  }
}

fileprivate extension TravelRegion {
  var toPlanSelectionCateogry: String {
    switch self {
    case .seoul:
      "서울"
    case .busan:
      "부산"
    case .incheon:
      "인천"
    case .daegu:
      "대구"
    case .gwangju:
      "광주"
    case .daejeon:
      "대전"
    case .ulsan:
      "울산"
    case .sejong:
      "세종"
    case .gyeonggido:
      "경기"
    case .chungcheongbukdo:
      "충북"
    case .chungcheongnamdo:
      "충남"
    case .jeollabukdo:
      "전북"
    case .jeollanamdo:
      "전남"
    case .gyeongsangbukdo:
      "경북"
    case .gyeongsangnamdo:
      "경남"
    case .gangwonSpecialSelfGoverningProvince:
      "강원"
    case .jejuSpecialSelfGoverningProvince:
      "제주"
    }
  }
}

final class PlanCategorySelectionViewController: UIViewController {
  struct Element<C: CaseIterable> {
    let caetrogyType: C
    var isSelected: Bool
  }
  
  @frozen enum SectionType: Int, CaseIterable {
    case region = 0
    case partner = 1
    case theme = 2
    
    var numberOfItems: Int {
      switch self {
      case .region:
        TravelRegion.count
      case .partner:
        TravelPartner.count
      case .theme:
        TravelTheme.count
      }
    }
    
    static func toSectionType(indexPath: IndexPath) -> SectionType? {
      switch indexPath.section {
      case 0:
        return .region
      case 1:
        return .partner
      case 2:
        return .theme
      default:
        return nil
      }
    }
  }
  
  // MARK: - Properties
  private lazy var selection = makeCollectionView()
  
  private lazy var partnerCategoryView = makeCollectionView()
  
  private lazy var themeCategoryView = makeCollectionView()
  
  private lazy var regions: [Element<TravelRegion>] = makeAllcasesToElement(of: TravelRegion.self)
  
  private lazy var partners: [Element<TravelPartner>] = makeAllcasesToElement(of: TravelPartner.self)
  
  private lazy var themes: [Element<TravelTheme>] = makeAllcasesToElement(of: TravelTheme.self)
  
  // MARK: - Lifecycle
}

// MARK: - Private Helpers
private extension PlanCategorySelectionViewController {
  func makeAllcasesToElement<T>(
    of type: T.Type
  ) -> [Element<T>] where T: CaseIterable {
    return type
      .allCases
      .reduce(into: [Element<T>]()) { $0.append(.init(caetrogyType: $1, isSelected: false)) }
  }
  
  func makePlanCategoryStackView(for subviews: [UIView]) -> UIStackView {
    return UIStackView
      .Builder()
      .setAxis(.vertical)
      .setDistribution(.equalSpacing)
      .setAlignment(.fill)
      .setSpacing(7)
      .build()
  }
  
  func makeCollectionView() -> UICollectionView {
    let flowLayout = UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 16
      $0.minimumInteritemSpacing = 8
      $0.sectionInset = .init(top: 0, left: 7, bottom: 0, right: -7)
      $0.scrollDirection = .vertical
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    return collectionView.set {
      $0.register(ReviewWritingThemeCell.self, forCellWithReuseIdentifier: ReviewWritingThemeCell.identifier)
    }
  }
}

// MARK: - ReviewWritingThemeCellDelegate
extension PlanCategorySelectionViewController: ReviewWritingThemeCellDelegate {
  func reviewWritingThemeCell(
    _ cell: ReviewWritingThemeCell?,
    isSelected: Bool
  ) {
    <#code#>
  }
}

// MARK: - UICollectionViewDataSource
extension PlanCategorySelectionViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return SectionType.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let sectionType = SectionType.toSectionType(indexPath: indexPath) else { return .init() }
    
    let cell = collectionView.dequeueReusableCell(for: indexPath, type: ReviewWritingThemeCell.self)
    cell?.delegate = self
    switch sectionType {
    case .region:
      
    case .partner:
      <#code#>
    case .theme:
      <#code#>
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PlanCategorySelectionViewController: UICollectionViewDelegate {
  
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlanCategorySelectionViewController: UICollectionViewDelegateFlowLayout {
  
}

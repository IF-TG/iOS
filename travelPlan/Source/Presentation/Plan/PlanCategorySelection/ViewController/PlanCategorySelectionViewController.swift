//
//  PlanCategorySelectionViewController.swift
//  travelPlan
//
//  Created by 양승현 on 6/27/24.
//

import UIKit
import Combine

final class PlanCategorySelectionViewController: BasePlanCategorySelectionViewController {
  struct Element<C> where C: CaseIterable, C: PlanCategorySelectionConfigurable {
    let categoryType: C
    var isSelected: Bool
  }
  
  // MARK: - Properties 
  private let categorySelectionCollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: PlanCategorySelectionViewController.makeCompositionalLayout())
    return collectionView.set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.register(ReviewWritingThemeCell.self, forCellWithReuseIdentifier: ReviewWritingThemeCell.identifier)
      $0.isPagingEnabled = true
      $0.isScrollEnabled = false
    }
  }()
  
  // MARK: - Properties
  private lazy var regions: [Element<TravelRegion>] = makeAllcasesToElement(of: TravelRegion.self)
  
  private lazy var partners: [Element<TravelPartner>] = makeAllcasesToElement(of: TravelPartner.self)
  
  private lazy var themes: [Element<TravelTheme>] = makeAllcasesToElement(of: TravelTheme.self)
  
  private var hasSelectedAnyRegions: Bool {
    regions.contains { $0.isSelected }
  }
  
  private var hasSelectedAnyPartners: Bool {
    partners.contains { $0.isSelected }
  }
  
  private var hasSelectedAnyThemes: Bool {
    themes.contains { $0.isSelected }
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  private var currentPage = 0
  
  // MARK: - Lifecycle
  init() {
    super.init(contentViewForCateogry: categorySelectionCollectionView, selectionType: .start)
    categorySelectionCollectionView.dataSource = self
    categorySelectionCollectionView.delegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  required init?(coder: NSCoder) { nil }
}

// MARK: - Private Helpers
private extension PlanCategorySelectionViewController {
  func makeAllcasesToElement<T>(
    of type: T.Type
  ) -> [Element<T>] where T: CaseIterable, T: PlanCategorySelectionConfigurable {
    return type
      .allCases
      .reduce(into: [Element<T>]()) { $0.append(.init(categoryType: $1, isSelected: false)) }
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
  
  @inline(__always)
  func configureCell<DataSource>(
    _ cell: ReviewWritingThemeCell?,
    element: Element<DataSource>
  ) where DataSource: CaseIterable, DataSource: PlanCategorySelectionConfigurable {
    cell?.configure(
      themeText: element.categoryType.toPlanSelectionCategory,
      isSelected: element.isSelected,
      isEnableMultiSelection: true)
  }
  
  func bind() {
    nextButtonTapPublisher.sink { [weak self] _ in
      guard let self else { return }
      if currentPage == 2 {
        // MARK: 사용자가 모든 페이지의 카테고리들을 선택했습니다. 이 scope시점에 서버에 보낼 데이터를 저장 후 다음 page로 이동해야 합니다.
        let selectedRegions = regions.filter { $0.isSelected }.map { $0.categoryType }
        _=partners.filter { $0.isSelected }.map { $0.categoryType }
        _=themes.filter { $0.isSelected }.map { $0.categoryType }
        return
      } else {
        currentPage += 1
        if currentPage == 1 && hasSelectedAnyPartners {
          hasSelected = true
        } else if currentPage == 2 && hasSelectedAnyThemes {
          hasSelected = true
        }
        categorySelectionCollectionView.scrollToItem(
          at: IndexPath(item: 0, section: currentPage),
          at: .right,
          animated: true)
      }
    }.store(in: &subscriptions)
    
    prevButtonTapPublisher.sink { [weak self] _ in   
      guard let self else { return }
      if currentPage == 0 { return }
      currentPage -= 1
      categorySelectionCollectionView.scrollToItem(
        at: IndexPath(item: 0, section: currentPage),
        at: .left,
        animated: true)
    }.store(in: &subscriptions)
  }
}

// MARK: - Compositional Layout Build
private extension PlanCategorySelectionViewController {
  // MARK: Constants
  typealias NSSection = NSCollectionLayoutSection
  
  // MARK: - Helpers
  static func makeCompositionalLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionIdx, _ in
      guard let sectionType = SectionType(rawValue: sectionIdx) else { return .none }
      if sectionType == .region {
        return self.makeSection(with: 1.0/3.0, groupHeightDimension: 400)
      }
      return self.makeSection(with: 0.5, groupHeightDimension: 400)
    }
  }
  
  static func makeSection(
    with itemFractionalWidth: CGFloat,
    groupHeightDimension: CGFloat
  ) -> NSSection {
    let cellHeight: CGFloat = 48
    let lineSpacing: CGFloat = 16
    let interItemSpacing: CGFloat = 8
    let inset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)

    return NSSection
      .Builder()
      .setItemSize(.init(width: .fractionalWidth(itemFractionalWidth), height: .fractionalHeight(1)))
      .setGroupSize(.init(width: .fractionalWidth(1.0), height: .absolute(groupHeightDimension)))
      .setGroupStyle(.vertial) {
        let horizontalGroupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(cellHeight))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: horizontalGroupSize,
          subitems: [$0.item])
        horizontalGroup.interItemSpacing = .fixed(interItemSpacing)
        return [horizontalGroup]
      }
      .configureGroup {
        $0.interItemSpacing = .fixed(interItemSpacing)
        $0.contentInsets = inset
      }
      .configureItem { $0.contentInsets = inset }
      .build()
      .set {
        $0.contentInsets = inset
        $0.interGroupSpacing = lineSpacing
        $0.orthogonalScrollingBehavior = .groupPagingCentered
      }
  }
}

// MARK: - ReviewWritingThemeCellDelegate
extension PlanCategorySelectionViewController: ReviewWritingThemeCellDelegate {
  func reviewWritingThemeCell(
    _ cell: ReviewWritingThemeCell?,
    isSelected: Bool
  ) {
    guard
      let cell,
      let indexPath = categorySelectionCollectionView.indexPath(for: cell),
      let sectionType = SectionType.toSectionType(indexPath: indexPath)
    else { return }
    
    let item = indexPath.item
    
    switch sectionType {
    case .region:
      regions[item].isSelected = isSelected
      hasSelected = hasSelectedAnyRegions
    case .partner:
      partners[item].isSelected = isSelected
      hasSelected = hasSelectedAnyPartners
    case .theme:
      themes[item].isSelected = isSelected
      hasSelected = hasSelectedAnyThemes
    }
  }
}

// MARK: - UICollectionViewDataSource
extension PlanCategorySelectionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SectionType.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    let sectionType = SectionType(rawValue: section)
    switch sectionType {
    case .region:
      return regions.count
    case .partner:
      return partners.count
    case .theme:
      return themes.count
    default:
      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let sectionType = SectionType.toSectionType(indexPath: indexPath) else { return .init() }
    let item = indexPath.item
    let cell = collectionView.dequeueReusableCell(for: indexPath, type: ReviewWritingThemeCell.self)
    cell?.delegate = self
    switch sectionType {
    case .region: 
      configureCell(cell, element: regions[item])
    case .partner:
      configureCell(cell, element: partners[item])
    case .theme:
      configureCell(cell, element: themes[item])
    }
    return cell ?? .init(frame: .zero)
  }
}

// MARK: - UICollectionViewDelegate
extension PlanCategorySelectionViewController: UICollectionViewDelegate { }

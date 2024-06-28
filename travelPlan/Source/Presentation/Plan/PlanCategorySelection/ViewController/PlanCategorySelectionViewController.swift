//
//  PlanCategorySelectionViewController.swift
//  travelPlan
//
//  Created by 양승현 on 6/27/24.
//

import UIKit
import Combine

protocol PlanCategorySelectionConfigurable {
  var toPlanSelectionCategory: String { get }
}

// MARK: SOLID OCP 느낌으로다가.. 기존 layer Entity에는 변화 x
extension TravelTheme: PlanCategorySelectionConfigurable {
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

extension TravelRegion: PlanCategorySelectionConfigurable {
  var toPlanSelectionCategory: String {
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

extension TravelPartner: PlanCategorySelectionConfigurable {
  var toPlanSelectionCategory: String {
    self.rawValue
  }
}

final class PlanCategorySelectionViewController: BasePlanCategorySelectionViewController {
  struct Element<C> where C: CaseIterable, C: PlanCategorySelectionConfigurable {
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
  
  private let categorySelectionCollectionView = {
    let flowLayout = UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 16
      $0.minimumInteritemSpacing = 8
      $0.sectionInset = .init(top: 0, left: 7, bottom: 0, right: 7)
      $0.scrollDirection = .horizontal
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
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
  
  @inline(__always)
  func configureCell<DataSource>(
    _ cell: ReviewWritingThemeCell?,
    element: Element<DataSource>
  ) where DataSource: CaseIterable, DataSource: PlanCategorySelectionConfigurable {
    cell?.configure(
      themeText: element.caetrogyType.toPlanSelectionCategory,
      isSelected: element.isSelected,
      isEnableMultiSelection: true)
  }
  
  func bind() {
    nextButtonTapPublisher.sink { [weak self] _ in
      guard let self else { return }
      if currentPage == 2 {
        // MARK: 사용자가 모든 카테고리 전부 선정. 다음 page로 이동해야합니다.
      } else {
        
        categorySelectionCollectionView.scrollToItem(
          at: IndexPath(item: 0, section: currentPage+1),
          at: .right,
          animated: true)
      }
    }.store(in: &subscriptions)
    
    prevButtonTapPublisher.sink { [weak self] _ in   
      guard let self else { return }
      if currentPage == 0 { return }
      categorySelectionCollectionView.scrollToItem(
        at: IndexPath(item: 0, section: currentPage-1),
        at: .left,
        animated: true)
    }.store(in: &subscriptions)
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
    case .partner:
      partners[item].isSelected = isSelected
    case .theme:
      themes[item].isSelected = isSelected
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

// MARK: - UICollectionViewDelegateFlowLayout
extension PlanCategorySelectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard 
      let sectionType = SectionType.toSectionType(indexPath: indexPath),
      let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
    else { return .zero }
    let cvWidth = collectionView.bounds.width
    let cellHeight = 48.0
    let sectionInsetWidth = flowLayout.sectionInset.left + flowLayout.sectionInset.right
    
    /// 3 Row가 있는 경우
    if sectionType == .region {
      let width = (cvWidth - 2 * flowLayout.minimumInteritemSpacing - sectionInsetWidth)/3
      return CGSize(width: width, height: cellHeight)
    }
    
    /// 2 Row 가 있는 경우
    let width = (cvWidth - flowLayout.minimumInteritemSpacing - sectionInsetWidth)/2
    return CGSize(width: width, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  

}


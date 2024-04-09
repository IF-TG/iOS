//
//  PostReviewWritingCategoryBottomSheet.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit

final class PostReviewWritingCategoryBottomSheet: BaseBottomSheetViewController {
  @frozen enum MainTheme: Int, CaseIterable {
    case season = 0
    case region = 1
    case theme = 2
    case partner = 3
    
    static var count: Int {
      MainTheme.allCases.count
    }
    
    var title: String {
      switch self {
      case .season:
        return TravelMainThemeType.season(nil).rawValue
      case .region:
        return TravelMainThemeType.region(nil).rawValue
      case .theme:
        return TravelMainThemeType.travelTheme(nil).rawValue
      case .partner:
        return TravelMainThemeType.partner(nil).rawValue
      }
    }
    
    var subThemes: [String] {
      switch self {
      case .season:
        Season.toKoreanList
      case .region:
        TravelRegion.toKoreanList
      case .theme:
        TravelTheme.toKoreanList
      case .partner:
        TravelPartner.toKoreanList
      }
    }
  }
  
  @frozen enum SectionType: Int, CaseIterable {
    case description = 0
    case mainTheme = 1
    case subTheme = 2
    
    static var numberOfSections: Int {
      SectionType.allCases.count
    }
    
    init?(rawValue: Int) {
      switch rawValue {
      case 0:
        self = .description
      case 1:
        self = .mainTheme
      case 2:
        self = .subTheme
      default:
        return nil
      }
    }
  }
  
  // MARK: - Properties
  private let tableView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 8
      $0.minimumInteritemSpacing = 8
      $0.sectionInset = .init(top: 0, left: 7, bottom: 0, right: 7)
      $0.register(
        ReviewWritingThemeDescriptionHeader.self,
        forDecorationViewOfKind: ReviewWritingThemeDescriptionHeader.id)
      $0.register(
        ReviewWritingThemeSectionHeader.self,
        forDecorationViewOfKind: ReviewWritingThemeSectionHeader.id)
      $0.register(ReviewWritingThemeCell.self, forDecorationViewOfKind: ReviewWritingThemeCell.id)
    })
  
  private var themes: [TravelTheme] = []
  private var regions: [TravelRegion] = []
  private var seasons: [Season] = []
  private var partners: [TravelPartner] = []
  
  private var currentSection: MainTheme = .season {
    didSet {
      // 섹션들 리로드! 근데 performbatch에서 애니메이션 부여 ㄱㄱ?
      tableView.reloadSections(IndexSet(integer: SectionType.subTheme.rawValue))
    }
  }
  
  private var numberOfItmes = TravelMainThemeType.season(nil).titles.count
  
  private var selectedMainThemeCell: ReviewWritingThemeCell?
  
  private let selectCompletionView = ReviewCategorySelectCompletionView(frame: .zero)
  
  // MARK: - Lifecycle
  init() {
    selectCompletionView.heightAnchor.constraint(equalToConstant: 105).isActive = true
    let stackView = UIStackView(arrangedSubviews: [tableView, selectCompletionView]).set {
      $0.axis = .vertical
    }
    super.init(contentView: stackView, mode: .full, radius: 15)
    tableView.dataSource = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Helpers
  private func setNextView() { }
  
  private func handleWhenSubThemeSelect(index: Int, isSelected: Bool) {
    switch currentSection {
    case .season:
      handleSeasonSubThemeSelect(index: index, isSelected: isSelected)
    case .region:
      handleRegionSubThemeSelect(index: index, isSelected: isSelected)
    case .theme:
      handleThemeSubThemeSelect(index: index, isSelected: isSelected)
    case .partner:
      handlePartnerSubThemeSelect(index: index, isSelected: isSelected)
    }
  }
  
  private func handleSeasonSubThemeSelect(index: Int, isSelected: Bool) {
    guard index < Season.count else { return }
    let season = Season.allCases[index]
    if isSelected {
      seasons.append(season)
    } else {
      seasons = seasons.filter { $0 != season }
    }
  }
  
  private func handleRegionSubThemeSelect(index: Int, isSelected: Bool) {
    guard index < TravelRegion.count else { return }
    let region = TravelRegion.allCases[index]
    if isSelected {
      regions.append(region)
    } else {
      regions = regions.filter { $0 != region }
    }
  }
  
  private func handleThemeSubThemeSelect(index: Int, isSelected: Bool) {
    guard index < TravelTheme.count else { return }
    let theme = TravelTheme.allCases[index]
    if isSelected {
      themes.append(theme)
    } else {
      themes = themes.filter { $0 != theme }
    }
  }
  
  private func handlePartnerSubThemeSelect(index: Int, isSelected: Bool) {
    guard index < TravelPartner.count else { return }
    let partner = TravelPartner.allCases[index]
    if isSelected {
      partners.append(partner)
    } else {
      partners = partners.filter { $0 != partner }
    }
  }
  
  private func hasSubThemeSelected(_ indexPath: IndexPath) -> Bool {
    switch currentSection {
    case .theme:
      if themes.contains(TravelTheme.allCases[indexPath.row]) {
        return true
      }
    case .season:
      if seasons.contains(Season.allCases[indexPath.row]) {
        return true
      }
    case .region:
      if regions.contains(TravelRegion.allCases[indexPath.row]) {
        return true
      }
    case .partner:
      if partners.contains(TravelPartner.allCases[indexPath.row]) {
        return true
      }
    }
    return false
  }
}

// MARK: - UITableViewDataSource
extension PostReviewWritingCategoryBottomSheet: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SectionType.numberOfSections
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = SectionType(rawValue: section) else { return 0 }
    return switch section {
    case .description:
      0
    case .mainTheme:
      MainTheme.count
    case .subTheme:
      numberOfItmes
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let section = SectionType(rawValue: indexPath.section) else {
      return .init()
    }
    if section == .description { return .init() }
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ReviewWritingThemeCell.id,
      for: indexPath
    ) as? ReviewWritingThemeCell else { return .init() }
    var themeText = "", isSelected = false, isEnableMultiSelection = false
    cell.delegate = self
    
    if case .mainTheme = section {
      themeText = MainTheme.allCases[indexPath.row].title
      if indexPath.row == 0 && selectedMainThemeCell == nil {
        selectedMainThemeCell = cell
        cell.deactiveSelection()
      }
    }
    if case .subTheme = section {
      isSelected = hasSubThemeSelected(indexPath)
      isEnableMultiSelection = true
      themeText = currentSection.subThemes[indexPath.row]
    }
    cell.configure(
      themeText: themeText,
      isSelected: isSelected,
      isEnableMultiSelection: isEnableMultiSelection)
    return cell
  }
}

extension PostReviewWritingCategoryBottomSheet: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = SectionType(rawValue: indexPath.section) else {
      return .zero
    }
    let collectionViewWidth = collectionView.bounds.width
    var itemWidth: CGFloat = collectionViewWidth / 2 - 8
    let itemHeight = 48
    if case .description = section { return .zero }
    if currentSection == .region {
      itemWidth = collectionViewWidth / 3 - 16
    } else {
      itemWidth = collectionViewWidth / 2 - 8
    }
    return CGSize(width: Int(itemWidth), height: Int(itemHeight))
  }
}

// MARK: - ReviewWritingThemeCellDelegate
extension PostReviewWritingCategoryBottomSheet: ReviewWritingThemeCellDelegate {
  func reviewWritingThemeCell(_ cell: ReviewWritingThemeCell?, isSelected: Bool) {
    guard let cell else { return }
    let indexPath = tableView.indexPath(for: cell)
    guard let section = SectionType(rawValue: indexPath?.section ?? -1) else { return }
    if section == .mainTheme {
      selectedMainThemeCell?.deactiveSelection()
      selectedMainThemeCell = cell
      guard let mainTheme = MainTheme(rawValue: indexPath?.row ?? -1) else { return }
      self.currentSection = mainTheme
    } else if section == .subTheme {
      guard let index = indexPath?.row else { return }
      handleWhenSubThemeSelect(index: index, isSelected: isSelected)
    }
  }
}

//
//  PostReviewWritingCategoryBottomSheet.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit
import Combine

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
  private let collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 8
      $0.minimumInteritemSpacing = 8
      $0.sectionInset = .init(top: 0, left: 7, bottom: 0, right: 7)
    }).set {
      $0.register(ReviewWritingThemeCell.self, forCellWithReuseIdentifier: ReviewWritingThemeCell.id)
      $0.register(
        ReviewWritingThemeDescriptionHeader.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: ReviewWritingThemeDescriptionHeader.id)
      $0.register(
        ReviewWritingThemeSectionHeader.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: ReviewWritingThemeSectionHeader.id)
    }
  
  private var themes: [TravelTheme] = []
  
  private var regions: [TravelRegion] = []
  
  private var seasons: [Season] = []
  
  private var partners: [TravelPartner] = []
  
  private var hasSelectedAtLeastOneTheme: Bool {
    if themes.count + regions.count + seasons.count + partners.count > 0 {
      return true
    }
    return false
  }
  
  private let themeEventNotifier = PassthroughSubject<Void, Never>()
  
  private var subscription: AnyCancellable?
  
  private var currentSection: MainTheme = .season {
    didSet {
      // 섹션들 리로드! 근데 performbatch에서 애니메이션 부여 ㄱㄱ?
      numberOfItmes = currentSection.subThemes.count
      collectionView.reloadSections(IndexSet(integer: SectionType.subTheme.rawValue))
    }
  }
  
  private var numberOfItmes = TravelMainThemeType.season(nil).titles.count
  
  private var selectedMainThemeCell: ReviewWritingThemeCell?
  
  private let selectCompletionView = ReviewCategorySelectCompletionView(frame: .zero)
  
  // MARK: - Lifecycle
  init() {
    selectCompletionView.heightAnchor.constraint(equalToConstant: 105).isActive = true
    let stackView = UIStackView(arrangedSubviews: [collectionView, selectCompletionView]).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.axis = .vertical
      $0.backgroundColor = .white
    }
    super.init(contentView: stackView, mode: .full, radius: 15)
    collectionView.dataSource = self
    collectionView.delegate = self
    bind()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.reloadData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Helpers
  private func bind() {
    
    // TODO: - 오키버튼 바인딩
    selectCompletionView.okButtonTap = { [weak self] in
      print("무야호잇")
    }
    selectCompletionView.clearButtonTap = { [weak self] in
      // TODO: - 초기화 버튼 바인딩
      // 선택한거 다 초기화
      self?.themes.removeAll()
      self?.regions.removeAll()
      self?.seasons.removeAll()
      self?.partners.removeAll()
      // 섹션 리로드 + 확인버튼 꺼지게
      self?.collectionView.reloadSections(IndexSet(integer: SectionType.subTheme.rawValue))
      self?.selectCompletionView.deactiveOKButtonUI()
      
    }
    
    subscription = themeEventNotifier.sink { [weak self] _ in
      if self?.hasSelectedAtLeastOneTheme == true {
        // TODO: - 오키 버튼 활성화
        self?.selectCompletionView.activeOKButtonUI()
      } else {
        self?.selectCompletionView.deactiveOKButtonUI()
      } // 오키 버튼 비활성화
    }
  }
  
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
        isSelected = true
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

// MARK: - UICollectionViewDelegateFlowLayout
extension PostReviewWritingCategoryBottomSheet: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = SectionType(rawValue: indexPath.section) else {
      return .zero
    }
    if case .description = section {
      return .zero
    }
    let collectionViewWidth = Int(collectionView.bounds.width)
    let sectionInset = 14, itemSpacing = 8
    var itemWidth: Int = (collectionViewWidth - sectionInset) / 2 - itemSpacing
    let itemHeight = 48
    if case .mainTheme = section {
      return CGSize(width: itemWidth, height: itemHeight)
    }
    if currentSection == .region {
      itemWidth = (collectionViewWidth - sectionInset) / 3 - itemSpacing*2
    }
    return CGSize(width: itemWidth, height: Int(itemHeight))
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let section = SectionType(rawValue: indexPath.section) else {
      return .init()
    }
    if case .description = section {
      guard let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: ReviewWritingThemeDescriptionHeader.id,
        for: indexPath
      ) as? ReviewWritingThemeDescriptionHeader else { return .init() }
      return headerView
    }
    var headerText = ""
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ReviewWritingThemeSectionHeader.id,
      for: indexPath
    ) as? ReviewWritingThemeSectionHeader else { return .init() }
    if case .mainTheme = section {
      headerText = "대분류"
    }
    if case .subTheme = section {
      headerText = "소분류"
    }
    headerView.configure(with: headerText)
    return headerView
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    guard let section = SectionType(rawValue: section) else {
      return .zero
    }
    var height: CGFloat = 0
    switch section {
    case .description:
      height = 60
    case .mainTheme:
      height = 65
    case .subTheme:
      height = 65
    }
    return CGSize(width: collectionView.bounds.width, height: height)
  }
}

// MARK: - ReviewWritingThemeCellDelegate
extension PostReviewWritingCategoryBottomSheet: ReviewWritingThemeCellDelegate {
  func reviewWritingThemeCell(_ cell: ReviewWritingThemeCell?, isSelected: Bool) {
    guard let cell else { return }
    let indexPath = collectionView.indexPath(for: cell)
    guard let section = SectionType(rawValue: indexPath?.section ?? -1) else { return }
    if section == .mainTheme {
      selectedMainThemeCell?.activeSelection()
      selectedMainThemeCell = cell
      guard let mainTheme = MainTheme(rawValue: indexPath?.row ?? -1) else { return }
      self.currentSection = mainTheme
    } else if section == .subTheme {
      guard let index = indexPath?.row else { return }
      handleWhenSubThemeSelect(index: index, isSelected: isSelected)
      themeEventNotifier.send()
    }
  }
}

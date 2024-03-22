//
//  BasePostCategoryBottomSheet.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/18.
//

import UIKit

protocol TravelThemeBottomSheetDelegate: AnyObject {
  func notifySelectedFilterOption(_ type: PostFilterOptions?)
}

protocol PostOrderCategoryBottomSheetDelegate: BasePostCategoryBottomSheetDelegate
where Category == TravelOrderType {}

protocol BasePostCategoryBottomSheetDelegate: AnyObject {
  associatedtype Category: RawRepresentable
  func notifySelectedCategory(_ category: Category)
}

final class PostOrderCategoryBottomSheet: BasePostCategoryBottomSheet {
  init() {
    super.init(bottomSheetMode: .couldBeFull, titles: TravelOrderType.toKoreanList)
  }
  
  required init?(coder: NSCoder) { nil }
  
  weak var delegate: (any PostOrderCategoryBottomSheetDelegate)?
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    guard 
      let selectedTitle,
      let selectedOrderType = TravelOrderType(rawValue: selectedTitle)
    else { return }
    delegate?.notifySelectedCategory(selectedOrderType)
  }
}

class BasePostCategoryBottomSheet: BaseBottomSheetViewController {
  // MARK: - Properties
  private let contentView: UIView
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.rowHeight = 55
    $0.separatorStyle = .singleLine
    $0.separatorInset = .zero
    $0.register(
      TravelThemeBottomSheetCell.self,
      forCellReuseIdentifier: TravelThemeBottomSheetCell.id)
    $0.dataSource = self
    $0.delegate = self
  }
    
  private let titles: [String]
  
  private(set) var selectedTitle: String?
  
  // MARK: - Lifecycle
  init(
    bottomSheetMode: BaseBottomSheetViewController.ContentMode,
    titles: [String]
  ) {
    let contentView = UIView(frame: .zero).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .white
    }
    self.contentView = contentView
    self.titles = titles
    super.init(contentView: contentView, mode: bottomSheetMode, radius: 8)
  }
  
  required init?(coder: NSCoder) { nil }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTableViewPosition()
  }
}

// MARK: - Private Helpers
extension BasePostCategoryBottomSheet {
  private func setTableViewPosition() {
    // TODO: - 이거 왜 이렇게 복잡하지? max인 경우를 알아야하네.. BaseBottomSheetVC 간편하게 사용할 수 있도록 시간 날 때 리빌딩
    let maximumHeight: CGFloat = CGFloat(titles.count) * 55
    contentView.addSubview(tableView)
    var heightConstraint: NSLayoutConstraint
    if titles == TravelRegion.toKoreanList {
      heightConstraint = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: maximumHeight)
    } else {
      heightConstraint = tableView.heightAnchor.constraint(equalToConstant: maximumHeight)
    }
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
      heightConstraint])
    
  }
}

// MARK: - UITableViewDataSource
extension BasePostCategoryBottomSheet: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: TravelThemeBottomSheetCell.id, for: indexPath
    ) as? TravelThemeBottomSheetCell else {
      return .init(style: .default, reuseIdentifier: TravelThemeBottomSheetCell.id)
    }
    cell.configure(with: titles[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate
extension BasePostCategoryBottomSheet: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedTitle = titles[indexPath.row]
    dismiss(animated: false)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
}

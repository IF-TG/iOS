//
//  TravelThemeBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/18.
//

import UIKit

protocol TravelThemeBottomSheetDelegate: AnyObject {
  func travelThemeBottomSheetViewController(
    _ viewController: TravelThemeBottomSheetViewController,
    didSelectTitle title: String?)
}

final class TravelThemeBottomSheetViewController: BaseBottomSheetViewController {
  enum Constants {
    enum TableView {
      static let cellHeight: CGFloat = 55
    }
  }
  
  // MARK: - Properties
  private let contentView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.rowHeight = Constants.TableView.cellHeight
    $0.separatorStyle = .singleLine
    $0.separatorInset = .zero
    $0.register(
      TravelThemeBottomSheetCell.self,
      forCellReuseIdentifier: TravelThemeBottomSheetCell.id)
    $0.dataSource = self
    $0.delegate = self
  }
  
  private(set) var sortingType: PostSearchFilterType
  
  private lazy var titles: [String] = sortingType.subCateogryTitles
  
  weak var delegate: TravelThemeBottomSheetDelegate?
  
  private var selectedTitle: String?
  
  // MARK: - Lifecycle
  init(
    bottomSheetMode: BaseBottomSheetViewController.ContentMode,
    sortingType: PostSearchFilterType
  ) {
    self.sortingType = sortingType
    super.init(mode: bottomSheetMode, radius: 8)
  }
  
  required init?(coder: NSCoder) {
    sortingType = .travelOrder
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    guard sortingType.subCateogryTitles != TravelRegion.toKoreanList else {
      setTableViewPosition()
      setContentView(contentView)
      super.viewDidLoad()
      return
    }
    
    super.viewDidLoad()
    setContentView(contentView)
    setTableViewPosition()
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    delegate?.travelThemeBottomSheetViewController(
      self,
      didSelectTitle: selectedTitle)
  }
}

// MARK: - Private Helpers
extension TravelThemeBottomSheetViewController {
  private func setTableViewPosition() {
    let maximumHeight: CGFloat = CGFloat(titles.count) * Constants.TableView.cellHeight
    contentView.addSubview(tableView)
    var heightConstraint: NSLayoutConstraint
    if sortingType.subCateogryTitles == TravelRegion.toKoreanList {
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
extension TravelThemeBottomSheetViewController: UITableViewDataSource {
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
extension TravelThemeBottomSheetViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // TODO: - 서버랑 정해야함. 어떻게 서버에 요청해야할 것인지? ex) "https://...지역/세종" 이런느낌으로 보낼건지 param 정해야함.
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

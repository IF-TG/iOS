//
//  FavoriteViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FavoriteViewController: UIViewController {
  // MARK: - Properties
  private let line = OneUnitHeightLine(color: .yg.gray0)
  private lazy var tableView = FavoriteListTableView()
  private var adapter: FavoriteListTableViewAdapter!
  weak var coordinator: FavoriteCoordinator?
  private var vm = FavoriteListViewModel()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    tableView.layoutFrom(superView: self.view)
    adapter = FavoriteListTableViewAdapter(
      tableView: self.tableView,
      adapterDataSource: vm,
      adapterDelegate: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    line.isHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    line.isHidden = true
  }
  
  private override init(
    nibName nibNameOrNil: String?,
    bundle nibBundleOrNil: Bundle?
  ) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private helpers
private extension FavoriteViewController {
  func configureUI() {
    view.backgroundColor = Constant.bgColor
    setNavigationBarTitle()
    setNavigationRightBarItem()
    setNavigationBarEdgeGrayLine()
  }
  
  func setNavigationBarTitle() {
    let titleLabel = UILabel().set {
      $0.text = "찜 목록"
      $0.textColor = Constant.NavigationBar.Title.color
      $0.font = Constant.NavigationBar.Title.font
      $0.textAlignment = .center
      
    }
    navigationItem.titleView = titleLabel
  }
  
  func setNavigationRightBarItem() {
    let settingButton = UIButton().set {
      let image = UIImage(
        named: Constant.NavigationBar.Setting.iconName)
      $0.setImage(image, for: .normal)
      $0.setImage(
        image!.setColor(Constant.NavigationBar.Setting.touchedColor),
        for: .highlighted)
      $0.addTarget(
        self,
        action: #selector(didTapSettingButton),
        for: .touchUpInside)
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      customView: settingButton)
  }
  
  func setNavigationBarEdgeGrayLine() {
    guard let naviBar = navigationController?.navigationBar else {
      return
    }
    line.setConstraint(fromSuperView: naviBar, spacing: .init(bottom: -Constant.NavigationBar.spacing.bottom))
  }
}

// MARK: - Action
extension FavoriteViewController {
  @objc func didTapSettingButton() {
    print("DEBUG: Tap setting button")
    
  }
}

extension FavoriteViewController: FavoriteListTableViewAdapterDelegate {
  func tappedCell(with data: FavoriteListTableViewCellModel) {
    print("go to specific favorite detail list")
  }
}

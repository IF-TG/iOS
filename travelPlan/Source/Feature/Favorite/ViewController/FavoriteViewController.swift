//
//  FavoriteViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FavoriteViewController: UIViewController {
  enum Constant {
    static let bgColor: UIColor = .white
    static let itemHeight: CGFloat = 65
    
    enum NavigationBar {
      enum Title {
        static let color: UIColor = .yg.gray7
        static let font: UIFont = UIFont(
          pretendard: .semiBold, size: 18)!
      }
      
      enum Setting {
        static let iconName: String = "favoriteNavigationBarSetting"
        static let touchedColor: UIColor = .yg.gray7.withAlphaComponent(0.5)
      }
    }
  }

  // MARK: - Properties
  private let line = OneUnitHeightLine(color: .yg.gray0)
  
  private let favoriteTableView = UITableView(frame: .zero, style: .plain).set {
    if #available(iOS 15.0, *) {
      $0.sectionHeaderTopPadding = 0
    }
    $0.separatorStyle = .singleLine
    $0.separatorColor = .yg.gray0
    $0.separatorInset = .zero
    $0.rowHeight = Constant.itemHeight
    
    $0.sectionHeaderHeight = Constant.itemHeight
    $0.register(
      FavoriteTableViewCell.self,
      forCellReuseIdentifier: FavoriteTableViewCell.id)
    $0.register(
      FavoriteHeaderView.self,
      forHeaderFooterViewReuseIdentifier: FavoriteHeaderView.id)
  }
  
  private var adapter: FavoriteTableViewAdapter!
  
  weak var coordinator: FavoriteCoordinatorDelegate?
  
  private var vm = FavoriteViewModel()
  
  // MARK: - Lifecycle
  override func loadView() {
    view = favoriteTableView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    
    adapter = FavoriteTableViewAdapter(
      tableView: self.favoriteTableView,
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
    
  deinit {
    coordinator?.finish()
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
    line.setConstraint(fromSuperView: naviBar)
  }
}

// MARK: - Action
extension FavoriteViewController {
  @objc func didTapSettingButton() {
    print("DEBUG: Tap setting button")
    
  }
}

extension FavoriteViewController: FavoriteTableViewAdapterDelegate {
  func tappedCell(with data: FavoriteTableViewCell.Model) {
    print("go to specific favorite detail list")
  }
}

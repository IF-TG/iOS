//
//  FavoriteViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FavoriteViewController: UIViewController {
  enum Constant {
    static let itemHeight: CGFloat = 65
    static let deleteControlWidth: CGFloat = 34
    enum NavigationBar {
      enum Title {
        static let color: UIColor = .yg.gray7
        static let font: UIFont = UIFont(pretendard: .semiBold, size: 18)!
      }
      
      enum Setting {
        static let iconName: String = "favoriteNavigationBarSetting"
        static let touchedColor: UIColor = .yg.gray7.withAlphaComponent(0.5)
      }
    }
  }

  // MARK: - Properties
  private let favoriteTableView = UITableView(frame: .zero, style: .plain).set {
    if #available(iOS 15.0, *) {
      $0.sectionHeaderTopPadding = 0
    }
    $0.separatorStyle = .singleLine
    $0.separatorColor = .yg.gray0
    $0.separatorInset = .zero
    $0.rowHeight = Constant.itemHeight
    $0.sectionHeaderHeight = Constant.itemHeight
    $0.backgroundColor = .white
    $0.register(
      FavoriteTableViewCell.self,
      forCellReuseIdentifier: FavoriteTableViewCell.id)
    $0.register(
      FavoriteHeaderView.self,
      forHeaderFooterViewReuseIdentifier: FavoriteHeaderView.id)
  }
  
  private let navigationBarDivider = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.gray0
  }
  
  private var adapter: FavoriteTableViewAdapter!
  
  weak var coordinator: FavoriteCoordinatorDelegate?
  
  private var vm = FavoriteViewModel()
  
  private var originHeaderCenterX: CGFloat!
  
  private var isEditingTableView: Bool {
    favoriteTableView.isEditing
  }
  
  private var headerView: UITableViewHeaderFooterView? {
    favoriteTableView.headerView(forSection: 0)
  }
  
  // MARK: - Lifecycle
  override func loadView() {
    view = favoriteTableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    favoriteTableView.bounces = false
    adapter = FavoriteTableViewAdapter(
      tableView: self.favoriteTableView,
      dataSource: vm,
      delegate: self)
  }
    
  deinit {
    coordinator?.finish()
  }
}

// MARK: - Private helpers
private extension FavoriteViewController {
  func configureUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.backgroundColor = .white
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
    typealias Const = Constant.NavigationBar.Setting
    let settingButton = UIButton().set {
      let image = UIImage(named: Const.iconName)
      $0.setImage(image, for: .normal)
      $0.setImage(image!.setColor(Const.touchedColor), for: .highlighted)
      $0.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
  }
  
  func setNavigationBarEdgeGrayLine() {
    guard let naviBar = navigationController?.navigationBar else { return }
    naviBar.addSubview(navigationBarDivider)
      NSLayoutConstraint.activate([
        navigationBarDivider.leadingAnchor.constraint(equalTo: naviBar.leadingAnchor),
        navigationBarDivider.trailingAnchor.constraint(equalTo: naviBar.trailingAnchor),
        navigationBarDivider.heightAnchor.constraint(equalToConstant: 1),
        navigationBarDivider.bottomAnchor.constraint(equalTo: naviBar.bottomAnchor)])
  }
  
  func setEditingMode() {
    guard let headerView else { return }
    originHeaderCenterX = headerView.center.x
    UIView.animate(
      withDuration: 0.37,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        self.favoriteTableView.transform = .init(translationX: 0, y: -Constant.itemHeight)
        self.headerView?.center.x += Constant.deleteControlWidth
        self.headerView?.alpha = 0
      })
  }
  
  func setNotEditingMode() {
    UIView.animate(
      withDuration: 0.27,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.favoriteTableView.transform = .identity
        self.headerView?.center.x = self.originHeaderCenterX
        self.headerView?.alpha = 1
      })

  }
}

// MARK: - Actions
extension FavoriteViewController {
  @objc func didTapSettingButton() {
    favoriteTableView.setEditing(!isEditingTableView, animated: true)
    guard isEditingTableView else {
      setNotEditingMode()
      return
    }
    setEditingMode()
  }
}

// MARK: - FavoriteTableViewAdapterDelegate
extension FavoriteViewController: FavoriteTableViewAdapterDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {

  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
    // TODO: - 데이터 찾고 그와 관련된 상세 찜 화면으로 이동.
  }
}

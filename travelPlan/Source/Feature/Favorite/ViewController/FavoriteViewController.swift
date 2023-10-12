//
//  FavoriteViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit
import Combine

struct FavoriteViewInput {
  let appear: PassthroughSubject<Void, Never> = .init()
  let detailPage: PassthroughSubject<IndexPath, Never> = .init()
  let updateDirectoryName: PassthroughSubject<(title: String, Int: Int), Never> = .init()
  let didTapNewDirectory: PassthroughSubject<Void, Never> = .init()
  let directoryNameSettingPage: PassthroughSubject<IndexPath, Never> = .init()
  let addNewDirectory: PassthroughSubject<String?, Never> = .init()
  let deleteDirectory: PassthroughSubject<IndexPath, Never> = .init()
}

enum FavoriteViewState {
  case none
  // TODO: - 인덱스페스나 디렉터리를 식별하는 식별자를 반환해서 이동해야합니다.
  case showDetailPage(IndexPath, String)
  case updatedDirecrotyName(IndexPath)
  case notUpdateDirectoryName
  case showNewDirectoryCreationPage
  case showDirectoryNameSettingPage(Int)
  case newDirectory(IndexPath)
  case deleteDirectory(IndexPath)
}

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
        static let selectedIconName: String = "folderPlus"
        static let touchedColor: UIColor = .yg.gray7.withAlphaComponent(0.5)
      }
      
      enum BackButtonItem {
        static let imageName = "back"
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
    $0.bounces = false
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
  
  private let navigationTitleLabel = UILabel().set {
    $0.text = "찜 목록"
    $0.numberOfLines = 1
    $0.textColor = Constant.NavigationBar.Title.color
    $0.font = Constant.NavigationBar.Title.font
    $0.textAlignment = .center
  }
  
  private lazy var backButton = UIButton().set {
    let iconName = Constant.NavigationBar.BackButtonItem.imageName
    let image = UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal)
    $0.setImage(image, for: .normal)
    $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
  }
  
  private lazy var settingButton: UIButton = UIButton().set {
    typealias Const = Constant.NavigationBar.Setting
    let image = UIImage(named: Const.iconName)
    $0.setImage(image, for: .normal)
    $0.setImage(image!.setColor(Const.touchedColor), for: .highlighted)
    $0.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
  }
  
  private lazy var folderPlusButton = UIButton().set {
    typealias Const = Constant.NavigationBar.Setting
    let image = UIImage(named: Const.selectedIconName)
    $0.setImage(image, for: .normal)
    $0.setImage(image!.setColor(Const.touchedColor), for: .highlighted)
    $0.addTarget(self, action: #selector(didTapFolderPlusButton), for: .touchUpInside)
  }
  
  private var adapter: FavoriteTableViewAdapter!
  
  weak var coordinator: FavoriteCoordinatorDelegate?
  
  private let viewModel: any FavoriteViewModelable & FavoriteTableViewAdapterDataSource
  
  private var originHeaderCenterX: CGFloat!
  
  private var subscription: AnyCancellable?
  
  private var isEditingTableView: Bool {
    favoriteTableView.isEditing
  }
  
  private var headerView: UITableViewHeaderFooterView? {
    favoriteTableView.headerView(forSection: 0)
  }
  
  private let input = FavoriteViewInput()
  
  // MARK: - Lifecycle
  init(viewModel: any FavoriteViewModelable & FavoriteTableViewAdapterDataSource) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    adapter = FavoriteTableViewAdapter(
      tableView: self.favoriteTableView,
      dataSource: viewModel,
      delegate: self)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func loadView() {
    view = favoriteTableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    input.appear.send()
  }
    
  deinit {
    coordinator?.finish()
  }
}

// MARK: - Helpers
extension FavoriteViewController {
  func makeNewDirectory(with title: String?) {
    input.addNewDirectory.send(title)
  }
  
  func updateDirectoryName(title: String, index: Int) {
    input.updateDirectoryName.send((title, index))
  }
}

// MARK: - Private helpers
private extension FavoriteViewController {
  func configureUI() {
    view.backgroundColor = .white
    navigationItem.titleView = navigationTitleLabel
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    backButton.isHidden = true
    setNavigationBarEdgeGrayLine()
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
    navigationTitleLabel.text = "폴더 변경"
    navigationTitleLabel.sizeToFit()
    backButton.isHidden = false
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
  
  func setListMode(_ completion: (() -> Void)? = nil) {
    navigationItem.rightBarButtonItem?.customView = settingButton
    navigationTitleLabel.text = "찜 목록"
    backButton.isHidden = true
    settingButton.isSelected.toggle()
    favoriteTableView.setEditing(!isEditingTableView, animated: true)
    UIView.animate(
      withDuration: 0.27,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.favoriteTableView.transform = .identity
        self.headerView?.center.x = self.originHeaderCenterX
        self.headerView?.alpha = 1
      }, completion: { _ in
        completion?()
      })
  }
  
  func setFavoriteTableView(with indexPath: IndexPath) {
    favoriteTableView.reloadData()
    favoriteTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
  }
}

// MARK: - ViewBindCase
extension FavoriteViewController: ViewBindCase {
  typealias Input = FavoriteViewInput
  typealias ErrorType = Error
  typealias State = FavoriteViewState
  
  func bind() {
    let output = viewModel.transform(input)
    subscription = output.sink { [weak self] in
      self?.render($0)
    }
  }
  
  func render(_ state: FavoriteViewState) {
    switch state {
    case .none:
      break
    case .newDirectory(let indexPath):
      setListMode { [weak self] in
        self?.setFavoriteTableView(with: indexPath)
      }
    case .showNewDirectoryCreationPage:
      coordinator?.showNewDirectoryCreationPage()
    case .notUpdateDirectoryName:
      didTapBackButton()
    case .showDetailPage(let indexPath, let title):
      coordinator?.showDetailPage(with: indexPath.row, title: title)
    case .updatedDirecrotyName(let indexPath):
      setListMode { [weak self] in
        self?.setFavoriteTableView(with: indexPath)
      }
    case .showDirectoryNameSettingPage(let index):
      coordinator?.showDirectoryNameSettingPage(with: index)
    case .deleteDirectory(let indexPath):
      setListMode {
        self.favoriteTableView.deleteRows(at: [indexPath], with: .fade)
      }
    }
  }
  
  func handleError(_ error: ErrorType) { }
}

// MARK: - Actions
extension FavoriteViewController {
  @objc private func didTapSettingButton() {
    if !settingButton.isSelected {
      settingButton.isSelected.toggle()
      navigationItem.rightBarButtonItem?.customView = folderPlusButton
      favoriteTableView.setEditing(!isEditingTableView, animated: true)
      setEditingMode()
    }
  }
  
  @objc private func didTapBackButton() {
    setListMode()
  }
  
  @objc private func didTapFolderPlusButton() {
    input.didTapNewDirectory.send()
  }
}

// MARK: - FavoriteTableViewAdapterDelegate
extension FavoriteViewController: FavoriteTableViewAdapterDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    input.detailPage.send(indexPath)
  }
  
  func tableViewCell(_ cell: UITableViewCell, didTapEditModeTitle title: String?) {
    guard let indexPath = favoriteTableView.indexPath(for: cell) else { return }
    // 원하면 placeholder에 현제 텍스트 추가할 수 있음.
    input.directoryNameSettingPage.send(indexPath)
  }
  
  func tableViewCell(_ cell: UITableViewCell, didtapDeleteButton: UIButton) {
    guard let indexPath = favoriteTableView.indexPath(for: cell) else { return }
    input.deleteDirectory.send(indexPath)
  }
}

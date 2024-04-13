//
//  SettingViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit
import Combine

@frozen enum SettingType: String, CaseIterable {
  // index 0
  case accountSetting = "계정 관리"
  case myInformation = "내 정보"
  
  // index = 2
  case activitySetting = "활동 관리"
  case myPosts = "내가 작성한 후기 글"
  case myActivity = "내 활동"
  case blockList = "차단 목록"
  
  // index = 6
  case service = "서비스"
  case operationGuide = "이용안내"
  case customerService = "고객센터"
  
  // index = 0
  case versionInformation = "버전정보"
  
  var fontType: UIFont.Pretendard {
    switch self {
    case .accountSetting, .activitySetting, .service:
      return .semiBold_600(fontSize: 18)
    case .versionInformation:
      return .regular_400(fontSize: 16)
    default:
      return .medium_500(fontSize: 16)
    }
  }
  
  var index: Int {
    switch self {
    case .accountSetting: return 0
    case .myInformation: return 1
    case .activitySetting: return 2
    case .myPosts: return 3
    case .myActivity: return 4
    case .blockList: return 5
    case .service: return 6
    case .operationGuide: return 7
    case .customerService: return 8
    case .versionInformation: return 9
    }
  }
  
  var section: Int {
    switch self {
    case .accountSetting,
        .myInformation:
      return 0
    case .activitySetting,
        .myPosts,
        .myActivity,
        .blockList:
      return 1
    case .service,
        .operationGuide,
        .customerService:
      return 2
    case .versionInformation:
      return 3
    }
  }
  
  var fontColor: UIColor {
    switch self {
    case .accountSetting, .activitySetting, .service, .versionInformation:
      return .yg.gray6
    default:
      return .yg.gray5
    }
  }
  
  var lineHeight: CGFloat {
    30
  }
}

final class SettingViewController: UIViewController {
  enum Constant {
    enum TopSheetView {
      static let height: CGFloat = 253
    }
    static let SettingLabelInset: UIEdgeInsets = .init(top: 8, left: 20, bottom: 8, right: 20)
    static let versionLabelTrailing: CGFloat = 30
    static let settingStackViewRadius: CGFloat = 10
    static let stackViewSpacing: CGFloat = 8
    enum ScrollView {
      enum Spacing {
        static let leading: CGFloat = 20
        static let trailing = leading
        static let top: CGFloat = 168 - 44
        static let bottom: CGFloat = 5
      }
    }
  }
  
  // MARK: - Dependencies
  private let viewModel: any SettingViewModelable & SettingViewModelPageDelegate
  
  // MARK: - Properties
  private let input = SettingViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let topSheetView = SettingTopSheetView()
  
  private let scrollView = UIScrollView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.scrollIndicatorInsets = .init(top: 0, left: -3, bottom: 0, right: -3)
  }
  
  private lazy var settingStackViews: [UIStackView] = (0..<4).map { _ in
    return UIStackView(frame: .zero).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .white
      $0.layer.cornerRadius = Constant.settingStackViewRadius
      $0.clipsToBounds = true
      $0.axis = .vertical
      $0.alignment = .fill
      $0.distribution = .fill
      $0.alpha = 0
    }
  }
  
  private var isAnimated = false
   
  // MARK: - Lifecycle
  init(viewModel: any SettingViewModelable & SettingViewModelPageDelegate) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
    input.viewDidLoad.send()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isAnimated {
      isAnimated.toggle()
      showAnimate()
    }
  }
  
  deinit {
    viewModel.finish()
  }
}

// MARK: - ViewBindCase
extension SettingViewController: ViewBindCase {
  typealias Input = SettingViewModelInput
  typealias ErrorType = Error
  typealias State = SettingViewModelState
  func bind() {
    let output = viewModel.transform(input)
    output.receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
  }
  
  func render(_ state: SettingViewModelState) {
    switch state {
    case .viewDidLoad((let nickname, _)):
      // TODO: - 유저 프로필 data -> image 반환 후 넣기.
      topSheetView.configure(name: nickname, imagePath: "tempProfile3")
    }
  }
  
  func handleError(_ error: any ErrorType) { }
}

// MARK: - Private Helpers
private extension SettingViewController {
  func configureUI() {
    view.backgroundColor = .yg.gray00Background
    let settingLabels = makeSettingLabels()
    setStackView(
      index: SettingType.accountSetting.section,
      from: (SettingType.accountSetting.index...SettingType.myInformation.index).map { settingLabels[$0] })
    setStackView(
      index: SettingType.activitySetting.section,
      from: (SettingType.activitySetting.index...SettingType.blockList.index).map { settingLabels[$0] })
    setStackView(
      index: SettingType.service.section,
      from: (SettingType.service.index...SettingType.customerService.index).map { settingLabels[$0] })
    setStackView(
      index: SettingType.versionInformation.section,
      from: (SettingType.versionInformation.index...SettingType.versionInformation.index).map { settingLabels[$0] })
    [SettingType.accountSetting.index,
     SettingType.activitySetting.index,
     SettingType.service.index,
     SettingType.versionInformation.index
    ].forEach { settingLabels[$0].isUserInteractionEnabled = false }
    setupUI()
  }
  
  func showAnimate() {
    topSheetView.alpha = 0.7
    topSheetView.transform = .init(translationX: 0, y: -20)
    topSheetView.prepareForAnimation()
    UIView.animate(
      withDuration: 0.28,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        self.topSheetView.alpha = 1
        self.topSheetView.transform = .identity
      }, completion: { _ in
        self.topSheetView.showAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.animateSettingViews(self.settingStackViews)
        }
      })
  }
  
  func setStackView(index: Int, from subviews: [UIView]) {
    _=subviews.map {
      settingStackViews[index].addArrangedSubview($0)
    }
  }
  
  func makeSettingLabels() -> [UILabel] {
    let dataSource = SettingType.allCases
    let inset = Constant.SettingLabelInset
    return dataSource.map { settingType in
      return BasePaddingLabel(
        padding: inset,
        fontType: settingType.fontType,
        lineHeight: settingType.lineHeight
      ).set {
        $0.text = settingType.rawValue
        $0.textColor = settingType.fontColor
        $0.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSettingLabel))
        $0.addGestureRecognizer(tap)
        if settingType == .versionInformation {
          let versionLabel = makeVersionLabel(from: settingType)
          appendVersionLabel(from: $0, subview: versionLabel)
        }
      }
    }
  }
  
  func makeVersionLabel(from settingType: SettingType) -> UILabel {
    return BaseLabel(fontType: settingType.fontType, lineHeight: settingType.lineHeight).set {
      $0.text = "1.0.0"
      $0.textColor = settingType.fontColor
      $0.isUserInteractionEnabled  = false
    }
  }
  
  func appendVersionLabel(from superView: UIView, subview: UIView) {
    superView.addSubview(subview)
    NSLayoutConstraint.activate([
      subview.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
      subview.trailingAnchor.constraint(
        equalTo: superView.trailingAnchor,
        constant: -Constant.versionLabelTrailing)])
  }
  
  func animateSettingViews(_ settingViews: [UIView]) {
    settingViews.enumerated().forEach { (idx, view) in
      view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height/10)
      UIView.animate(
        withDuration: 0.25,
        delay: Double(idx) * (0.33 + Double(idx)/15.0),
        options: .curveEaseOut,
        animations: {
        view.alpha = 1
        view.transform = .identity
      })
    }
  }
}

// MARK: - Actions
private extension SettingViewController {
  @objc func didTapSettingLabel(_ sender: UIGestureRecognizer) {
    guard
      let targetLabel = (sender.view as? UILabel),
      let title = targetLabel.text,
      let settingType = SettingType(rawValue: title)
    else {
      return
    }
    UIView.animate(withDuration: 0.17, animations: {
      targetLabel.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }, completion: { [weak self] _ in
      switch settingType {
      case .myInformation:
        self?.viewModel.showMyInformationPage()
      case .operationGuide:
        self?.viewModel.showOperationGuidePage()
      case .customerService:
        self?.viewModel.showCustomerServicePage()
      default:
        print("\(settingType.rawValue ) 화면으로 이동해야합니다. 타입: \(settingType.self)")
      }
      UIView.animate(withDuration: 0.13, animations: {
        targetLabel.layer.backgroundColor = UIColor.white.cgColor
      })
    })
  }
}

// MARK: - LayoutSupport
extension SettingViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(topSheetView)
    view.addSubview(scrollView)
    _=settingStackViews.map {
      scrollView.addSubview($0)
    }
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(topSheetViewConstraints)
    NSLayoutConstraint.activate(scrollViewConstraints)
    
    let topSpacing = Constant.stackViewSpacing
    let sc = scrollView.contentLayoutGuide
    NSLayoutConstraint.activate([
      settingStackViews[0].topAnchor.constraint(equalTo: sc.topAnchor),
      settingStackViews[1].topAnchor.constraint(
        equalTo: settingStackViews[0].bottomAnchor,
        constant: topSpacing),
      settingStackViews[2].topAnchor.constraint(
        equalTo: settingStackViews[1].bottomAnchor,
        constant: topSpacing),
      settingStackViews[3].topAnchor.constraint(
        equalTo: settingStackViews[2].bottomAnchor, 
        constant: topSpacing),
      settingStackViews[3].bottomAnchor.constraint(equalTo: sc.bottomAnchor)])
    
    NSLayoutConstraint.activate(
      settingStackViews.map {[
        $0.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        $0.leadingAnchor.constraint(equalTo: sc.leadingAnchor),
        $0.trailingAnchor.constraint(equalTo: sc.trailingAnchor)
      ]}.flatMap { $0 })
  }
}

// MARK: - LayoutSupport Constraints
private extension SettingViewController {
  var topSheetViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TopSheetView
    return [
      topSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topSheetView.topAnchor.constraint(equalTo: view.topAnchor),
      topSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topSheetView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var scrollViewConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.ScrollView.Spacing
    return [
      scrollView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: Spacing.leading),
      scrollView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: Spacing.top),
      scrollView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -Spacing.trailing),
      scrollView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -Spacing.bottom)]
  }
}

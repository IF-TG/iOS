//
//  SettingViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class SettingViewController: UIViewController {
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
  
  // MARK: - Properties
  weak var coordinator: ProfileCoordinatorDelegate?
  
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
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func loadView() {
    super.loadView()
    // TODO: - 파일매니저나 캐싱으로 저장한 사용자 정보 가져와야 합니다.
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    topSheetView.configure(name: "신짱구", imagePath: "tempProfile3")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isAnimated {
      isAnimated.toggle()
      showAnimate()
    }
  }
  
  deinit {
    coordinator?.finish()
  }
}

// MARK: - Private Helpers
private extension SettingViewController {
  func configureUI() {
    view.backgroundColor = .yg.gray00Background
    let settingLabels = makeSettingLabels()
    setStackView(index: 0, from: (0...1).map { settingLabels[$0] })
    setStackView(index: 1, from: (2...5).map { settingLabels[$0] })
    setStackView(index: 2, from: (6...8).map { settingLabels[$0] })
    setStackView(index: 3, from: (9...9).map { settingLabels[$0] })
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
    }, completion: { _ in
      print("\(settingType.rawValue ) 화면으로 이동해야합니다. 타입: \(settingType.self)")
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

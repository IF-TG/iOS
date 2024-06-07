//
//  PostOptionResultAlertController.swift
//  travelPlan
//
//  Created by 양승현 on 4/7/24.
//

import UIKit

final class PostOptionResultAlertController: UIViewController {
  // MARK: - Nested
  @frozen enum OptionType {
    case postAuthorBlock
    case postReport
    
    var imagePath: String {
      switch self {
      case .postReport:
        "report_success_icon"
      case .postAuthorBlock:
        "block_success_icon"
      }
    }
    
    var description: String {
      switch self {
      case .postAuthorBlock:
        "차단되었습니다."
      case .postReport:
        "신고를 접수하였습니다."
      }
    }
  }
  
  // MARK: - Properties
  private let imageView = UIImageView().set {
    $0.widthAnchor.constraint(equalToConstant: 55).isActive = true
    $0.heightAnchor.constraint(equalToConstant: 55).isActive = true
    $0.contentMode = .scaleAspectFit
  }
  
  private let label = UILabel().set {
    $0.textColor = .yg.gray6
    $0.font = UIFont(pretendard: .medium_500(fontSize: 14))
  }
  
  // MARK: - Lifecycle
  init(type: OptionType) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overFullScreen
    modalTransitionStyle = .crossDissolve
    imageView.image = UIImage(named: type.imagePath)
    label.text = type.description
    
    let background = CALayer()
    background.frame = view.bounds
    background.backgroundColor = UIColor.white.withAlphaComponent(0.6).cgColor
    view.layer.insertSublayer(background, at: 0)
  }
  
  required init?(coder: NSCoder) { nil }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _=UIStackView(arrangedSubviews: [imageView, label]).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.axis = .vertical
      $0.spacing = 6
      $0.alignment = .center
      view.addSubview($0)
      NSLayoutConstraint.activate([
        $0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {[weak self] in
      self?.dismiss(animated: true)
    }
  }
}

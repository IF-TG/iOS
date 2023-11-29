//
//  CustomerServiceViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit
import Combine
import MessageUI

final class CustomerServiceViewController: BaseSettingViewController {
  // MARK: - Properties
  private lazy var mailServiceView = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 24, height: 24), iconPath: "mail-icon"),
    countInfo: .init(fontType: .medium_500(fontSize: 16), lineHeight: nil)
  ).set {
    $0.setCountLabel(text: "메일 문의")
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = 16
    $0.distribution = .fillProportionally
    $0.alignment = .center
    $0.backgroundColor = .none
    
  }
  
  private let contentView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 10
    $0.backgroundColor = .white
  }
  
  private var contentViewSubscription: AnyCancellable?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    handleContentView()
  }
}

// MARK: - Private Helpers
private extension CustomerServiceViewController {
  
  func handleContentView() {
    contentViewSubscription = contentView
      .tapGesture
      .filter { MFMailComposeViewController.canSendMail() }
      .sink { [weak self] _ in
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject("여가팀에게 문의 및 개선사항을 남겨주세요.")
        mail.setToRecipients(["shyeoga2023@gmail.com"])
        mail.setMessageBody(
          self?.defaultMeessage ?? "문의사항이나 개선사항을 작성해주세요.",
          isHTML: true)
        self?.present(mail, animated: true)
      }

  }
  
  private var defaultMeessage: String {
    """
    <p style="font-family: Arial, sans-serif; color: #333; background-color: #f0f0f0; padding: 20px; margin: 0; white-space: pre-wrap;">
    안녕하세요. "<span style="font-weight: bold; color: #1BA0EB;">여행을 가다"</span> 여가팀입니다.
    <br>
    - 문의사항이나 버그, 새선사항 등은 아래에 작성해주세요.
    
    
    ⭐ 문의 관련 스크린샷을 첨부하시면 더욱 빠른 확인이 가능합니다.
    <br><br>
    -------------------
    <span style="font-weight: bold; color: #3366cc;">Device Model : \(UIDevice.modelName)</span><br>
    <span style="font-weight: bold; color: #3366cc;">Device OS :  \(UIDevice.current.systemVersion)</span><br>
    <span style="font-weight: bold; color: #3366cc;">App Version : \(Bundle.main.currentAppVersion)</span><br>
    -------------------
    </p>
    """
  }
}

extension CustomerServiceViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
    self.dismiss(animated: true, completion: nil)
  }

}

// MARK: - LayoutSupport
extension CustomerServiceViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(contentView)
    contentView.addSubview(mailServiceView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      contentView.heightAnchor.constraint(equalToConstant: 52),
    
      mailServiceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      mailServiceView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
  }
}

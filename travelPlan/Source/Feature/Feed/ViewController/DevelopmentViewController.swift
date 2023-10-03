//
//  DevelopmentViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/3/23.
//

import UIKit

final class DevelopmentViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yg.littleWhite
    _=UILabel(frame: .zero).set {
      let color = UIColor.systemPink.withAlphaComponent(0.3)
      let rect = CGRect(x: 0, y: 0, width: 300, height: 130)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.text = "개발중인 화면이에요: ]"
      $0.font = .systemFont(ofSize: 25, weight: .semibold)
      $0.textAlignment = .center
      $0.layer.cornerRadius = 30
      $0.layer.backgroundColor = color.cgColor
      view.addSubview($0)
      NSLayoutConstraint.activate([
        $0.widthAnchor.constraint(equalToConstant: rect.width),
        $0.heightAnchor.constraint(equalToConstant: rect.height),
        $0.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
      $0.layer.shadowColor = color.cgColor
      $0.layer.shadowRadius = 15
      $0.layer.shadowOpacity = 1
      $0.layer.shadowOffset = .init(width: 0, height: 4)
      $0.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 15).cgPath
    }
  }
}

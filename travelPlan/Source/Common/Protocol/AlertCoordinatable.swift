//
//  AlertCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/9/24.
//

import UIKit
import SHCoordinator

protocol AlertCoordinatable {}

extension AlertCoordinatable where Self: FlowCoordinator {
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(title: "OK", style: .default) { _ in completion?() }
    }
    presenter?.present(alert, animated: true)
  }
}

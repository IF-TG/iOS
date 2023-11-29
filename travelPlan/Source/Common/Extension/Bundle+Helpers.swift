//
//  Bundle+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import Foundation.NSBundle

extension Bundle {
  var currentAppVersion: String {
    guard
      let dictionary = Bundle.main.infoDictionary,
      let version = dictionary["CFBundleShortVersionString"] as? String
    else { return "" }
    return version
  }
}

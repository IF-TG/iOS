//
//  XMLParsingServiceProtocol.swift
//  travelPlan
//
//  Created by 양승현 on 4/24/24.
//

import Foundation
import Combine

public protocol XMLParsingServiceProtocol {
  typealias XMLAttributes = [String: String]
  
  var xmlParserNotifier: PassthroughSubject<XMLAttributes, Error> { get }
  
  func startParsing()
}

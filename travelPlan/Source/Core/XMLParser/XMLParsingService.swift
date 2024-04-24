//
//  XMLParsingService.swift
//  travelPlan
//
//  Created by 양승현 on 4/24/24.
//

import Foundation
import Combine

public final class XMLParsingService: NSObject, XMLParsingServiceProtocol {
  // MARK: - Properties
  private var dictionary: XMLAttributes = [:]
  
  private var currentKeyForParsing: String?
  
  private var foundCharacters: String = ""
  
  private let parser: XMLParser
  
  public var xmlParserNotifier: PassthroughSubject<XMLAttributes, Error> = .init()
  
  // MARK: - Lifecycle
  init(parser: XMLParser) {
    self.parser = parser
    super.init()
    parser.delegate = self
  }
  
  /// parse하기전에 xmlParserNotifier를 바인딩해야 합니다.
  public func parse() {
    parser.parse()
  }
}

// MARK: - XMLParserDelegate
extension XMLParsingService: XMLParserDelegate {
  public func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:]
  ) {
    currentKeyForParsing = elementName
    foundCharacters = ""
  }
  
  public func parser(
    _ parser: XMLParser,
    foundCharacters string: String
  ) {
    foundCharacters += string
  }
  
  public func parser(
    _ parser: XMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?
  ) {
    guard let key = currentKeyForParsing else { return }
    dictionary[key] = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
    currentKeyForParsing = nil
  }
  
  public func parser(_ parser: XMLParser, parseErrorOccurred parseError: any Error) {
    xmlParserNotifier.send(completion: .failure(parseError))
  }
  
  public func parserDidEndDocument(_ parser: XMLParser) {
    xmlParserNotifier.send(dictionary)
  }
}

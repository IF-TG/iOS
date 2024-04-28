//
//  ImageMemroyCachable.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import Foundation

public protocol ImageMemoryCachable: AnyObject {
  func imageData(for url: String) -> Data?
  func insert(_ imageData: Data, forKey url: String)
  func removeImageData(for url: String)
  func removeAllImages()

  subscript(_ url: String) -> Data? { get set }
}

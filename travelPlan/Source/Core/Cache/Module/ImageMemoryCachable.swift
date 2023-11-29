//
//  ImageMemroyCachable.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import UIKit

public protocol ImageMemoryCachable: Actor {
  func image(for url: String) -> UIImage?
  func insert(_ image: UIImage, forKey url: String)
  func removeImage(for url: String)
  func removeAllImages()

  subscript(_ url: String) -> UIImage? { get set }
}

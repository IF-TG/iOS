//
//  ImageCachable.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import UIKit

protocol ImageCachable: Actor {
  @MainActor
  func image(for url: String) -> UIImage?
  @MainActor
  func insert(_ image: UIImage, forKey url: String)
  @MainActor
  func removeImage(for url: String)
  @MainActor
  func removeAllImages()
  
  @MainActor
  subscript(_ url: String) -> UIImage? { get set }
}

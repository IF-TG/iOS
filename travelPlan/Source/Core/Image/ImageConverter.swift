//
//  ImageConverter.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import UIKit

class ImageConverter {
  func base64ToImage(_ base64String: String) -> UIImage? {
    guard let imageData = base64ToData(base64String) else { return nil }
    return UIImage(data: imageData)
  }
  
  func base64ToData(_ base64String: String) -> Data? {
    return Data(base64Encoded: base64String)
  }
  
  func imageToBase64(_ image: UIImage) -> String? {
    return image.jpegData(compressionQuality: 1)?.base64EncodedString()
  }
}

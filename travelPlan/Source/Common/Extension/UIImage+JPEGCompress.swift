//
//  UIImage+JPEGCompress.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/15.
//

import UIKit

extension UIImage {
  /// 이미지 compressionQuality로 해상도 조절
  /// # Example #
  /// ```
  /// Example:
  /// let image = UIImage()
  /// let compressedImg = image.compressJPEGImage(with: 0.7)
  /// ```
  func compressJPEGImage(with compressionQuality: CGFloat = 0.5) -> UIImage? {
    guard let imageData = self.jpegData(compressionQuality: compressionQuality),
          let compressedImage = UIImage(data: imageData) else {
      return nil
    }
    return compressedImage
  }
}

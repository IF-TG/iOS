//
//  UIColor+.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/04/30.
//

import UIKit.UIColor

extension UIColor {
  
  /// 16진수의 정수형으로 UIColor를 생성합니다.
  ///   - Parameters:
  ///   - hex: 16진수
  ///   - alpha: 불투명도, 0부터 1사이의 값
  convenience init(hex: UInt, alpha: CGFloat = 1.0) {
    let components = (
      red: CGFloat((hex >> 16) & 0xff) / 255,
      green: CGFloat((hex >> 08) & 0xff) / 255,
      blue: CGFloat((hex >> 00) & 0xff) / 255
    )
    self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
  }
  
  /// 16진수 형태의 문자열로 UIColor를 생성합니다.
  ///   - Parameters:
  ///   - hex: 16진수 형태의 문자열
  ///   - alpha: 불투명도, 0부터 1 사이의 값
  convenience init(hex: String, alpha: CGFloat = 1.0) {
    var hexString = hex
    if hexString.hasPrefix("#") {
      hexString.removeFirst()
    }
    if hexString.hasPrefix("0x") {
      hexString.removeFirst(2)
    }
    
    let hexColor = UInt(hexString, radix: 16)!
    
    self.init(hex: hexColor, alpha: alpha)
  }
}

extension UIImage {
  /// 이미지의 색을 변경해야 할 경우 이미지 그래픽 컨텍스트를 사용해서 변경
  /// - Parameter color: UIColor
  /// - Returns: 변경된 이미지 색의 이미지
  func setColor(_ color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
    color.setFill()
    
    let context = UIGraphicsGetCurrentContext()
    context?.translateBy(x: 0, y: self.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    context?.setBlendMode(CGBlendMode.normal)
    let rect = CGRect(
      origin: .zero,
      size: CGSize(width: self.size.width,
                   height: self.size.height))
    context?.clip(to: rect, mask: self.cgImage!)
    context?.fill(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}

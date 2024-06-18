//
//  TempSource.swift
//  travelPlan
//
//  Created by SeokHyun on 5/25/24.
//

import UIKit

/// 임시 데이터를 생성하는 객체입니다.
struct TempSource {
  private init() { }
  
  static var imageData: Data {
    let image = UIImage(named: "tempThumbnail10")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    return imageData
  }
  
  static var imageData2: Data {
    let image = UIImage(named: "tempThumbnail11")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    return imageData
  }
}

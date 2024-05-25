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
    let image = UIImage(named: "tempThumbnail1")!
    let imageData = image.jpegData(compressionQuality: 1.0)!
    
    return imageData
  }
}

//
//  PostContentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation

enum PostContentEntity {
  case text(String)
  // TODO: - 서버에서 이미지를 저장할 때 이미지 타입도 같이 저장하기 때문에, iOS에서 서버로 이미지 확장자명을 보내야합니다.
//  case image(Data, ImageType)
  case image(Data)
}

//enum ImageType: String {
//  case jpg
//  case jpeg
//  case png
//}

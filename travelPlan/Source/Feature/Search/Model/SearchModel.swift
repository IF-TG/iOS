//
//  SearchModel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/31.
//

import Foundation
import UIKit.UIImage
// section의 연관값은 header, footer를 포함하는 객체
struct SearchSectionItemModel {
  enum SearchSection {
    case bestFestival([FestivalItem])
    case famousSpot([FamousSpotItem])
    
    var headerTitle: String {
      switch self {
      case .bestFestival: return "베스트 축제"
      case .famousSpot: return "야영, 레포츠 어떠세요?"
      }
    }
  }
}

struct FestivalItem {
  var imageName: String?
  var title: String
  var date: String // Date
  var isSelectedButton: Bool
}

struct FamousSpotItem {
  var imageName: String?
  var title: String
  var catrgory: String
  var area: String
  var isSelectedButton: Bool
}
struct SectionItem {
  var festival: FestivalItem
  var famous: FamousSpotItem
}

extension SearchSectionItemModel {
  static var models: [SearchSection] = [
    .bestFestival([
      .init(imageName: "tempThumbnail7", title: "축제1", date: "23.03.30~23.04.14", isSelectedButton: false),
      .init(imageName: "tempThumbnail7", title: "축제2", date: "23.03.30~23.04.14", isSelectedButton: false),
      .init(imageName: "tempThumbnail7", title: "축제3", date: "23.03.30~23.04.14", isSelectedButton: false),
      .init(imageName: "tempThumbnail7", title: "축제4", date: "23.03.30~23.04.14", isSelectedButton: false),
      .init(imageName: "tempThumbnail7", title: "축제5", date: "23.03.30~23.04.14", isSelectedButton: false)
    ]),
    .famousSpot([
      .init(imageName: "tempProfile4", title: "관광1", catrgory: "카테1", area: "지역1", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광2", catrgory: "카테2", area: "지역2", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광3", catrgory: "카테3", area: "지역3", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false)
    ]),
    .famousSpot([
      .init(imageName: "tempProfile4", title: "관광1", catrgory: "카테1", area: "지역1", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광2", catrgory: "카테2", area: "지역2", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광3", catrgory: "카테3", area: "지역3", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false),
      .init(imageName: "tempProfile4", title: "관광4", catrgory: "카테4", area: "지역4", isSelectedButton: false)
    ])
  ]
}

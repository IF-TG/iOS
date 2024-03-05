//
//  TravelRegion.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum TravelRegion: String, CaseIterable {
  case seoul = "서울"
  case busan = "부산"
  case incheon = "인천"
  case daegu = "대구"
  case gwangju = "광주"
  case daejeon = "대전"
  case ulsan = "울산"
  case sejong = "세종"
  case gyeonggido = "경기도"
  case chungcheongbukdo = "충청북도"
  case chungcheongnamdo = "충청남도"
  case jeollabukdo = "전라북도"
  case jeollanamdo = "전라남도"
  case gyeongsangbukdo = "경상북도"
  case gyeongsangnamdo = "경상남도"
  case gangwonSpecialSelfGoverningProvince = "강원특별자치도"
  case jejuSpecialSelfGoverningProvince = "제주특별자치도"
}

// MARK: - Mappings toDTO
extension TravelRegion {
  func toDTO() -> String {
    return switch self {
    case .seoul:
      "SEOUL"
    case .busan:
      "BUSAN"
    case .incheon:
      "INCHEON"
    case .daegu:
      "DAEGU"
    case .gwangju:
      "GWANGJU"
    case .daejeon:
      "DAEJEON"
    case .ulsan:
      "ULSAN"
    case .sejong:
      "SEJONG"
    case .gyeonggido:
      "GYEONGGI"
    case .chungcheongbukdo:
      "CHUNGBUK"
    case .chungcheongnamdo:
      "CHUNGNAM"
    case .jeollabukdo:
      "JEONBUK"
    case .jeollanamdo:
      "JEONNAM"
    case .gyeongsangbukdo:
      "GYEONGBUK"
    case .gyeongsangnamdo:
      "GYEONGNAM"
    case .gangwonSpecialSelfGoverningProvince:
      "GANGWON"
    case .jejuSpecialSelfGoverningProvince:
      "JEJU"
    }
  }
}

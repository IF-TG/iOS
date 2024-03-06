//
//  TravelRegionMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct TravelRegionMapper {
  static func fromDTO(_ dto: String) -> TravelRegion? {
    return switch dto {
    case "SEOUL":
        .seoul
    case "BUSAN":
        .busan
    case "INCHEON":
        .incheon
    case "DAEGU":
        .daegu
    case "GWANGJU":
        .gwangju
    case "DAEJEON":
        .daejeon
    case "ULSAN":
        .ulsan
    case "SEJONG":
        .sejong
    case "GYEONGGI":
        .gyeonggido
    case "CHUNGBUK":
        .chungcheongbukdo
    case "CHUNGNAM":
        .chungcheongnamdo
    case "JEONBUK":
        .jeollabukdo
    case "JEONNAM":
        .jeollanamdo
    case "GYEONGBUK":
        .gyeongsangbukdo
    case "GYEONGNAM":
        .gyeongsangnamdo
    case "GANGWON":
        .gangwonSpecialSelfGoverningProvince
    case "JEJU":
        .jejuSpecialSelfGoverningProvince
    default:
      nil
    }
  }
  
  static func toDTO(_ requestValue: TravelRegion) -> String {
    return switch requestValue {
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

//
//  DestinationDetailContentMapper.swift
//  travelPlan
//
//  Created by SeokHyun on 8/5/24.
//

import Foundation

struct DestinationDetailContentMapper {
  // MARK: - Properties
  private let emptyInfoString = "해당 데이터를 제공하지 않습니다."
  
  // MARK: - Helpers
  func makeDestinationDetail(detail: DestinationEntity.Detail) -> DestinationDetailSection {
    let contents: DestinationDetailSection
    
    switch detail {
    case let .attraction(detail):
      contents = makeAttractionDetail(detail: detail)
    case let .cultureFacility(detail):
      contents = makeCultureFacilityDetail(detail: detail)
    case let .festival(detail):
      contents = makeFestivalDetail(detail: detail)
    case let .leports(detail):
      contents = makeLeportsDetail(detail: detail)
    case let .restaurant(detail):
      contents = makeRestaurantDetail(detail: detail)
    case let .shopping(detail):
      contents = makeShoppingDetail(detail: detail)
    }
    return contents
  }
}

// MARK: - Private Helpers
extension DestinationDetailContentMapper {
  private func makeShoppingDetail(
    detail: DestinationEntity.ShoppingDetail
  ) -> DestinationDetailSection {
    .content([
      DestinationDetailSection.Content(title: "유모차 대여 여부", description: detail.checkBabyStroller ?? emptyInfoString),
      DestinationDetailSection.Content(title: "애완동물 동반 가능 여부", description: detail.checkPet ?? emptyInfoString),
      DestinationDetailSection.Content(title: "영업일", description: detail.fairDate ?? emptyInfoString),
      DestinationDetailSection.Content(title: "개점일", description: detail.openDate ?? emptyInfoString),
      DestinationDetailSection.Content(title: "영업시간", description: detail.openTime ?? emptyInfoString),
      DestinationDetailSection.Content(title: "휴무일", description: detail.restDate ?? emptyInfoString),
      DestinationDetailSection.Content(title: "판매 품목", description: detail.saleItem),
      DestinationDetailSection.Content(title: "규모", description: detail.scale)
    ])
  }
  
  private func makeRestaurantDetail(
    detail: DestinationEntity.RestaurantDetail
  ) -> DestinationDetailSection {
    .content([
      DestinationDetailSection.Content(title: "대표 메뉴", description: detail.featureMenu ?? emptyInfoString),
      DestinationDetailSection.Content(title: "개점일", description: detail.openDate),
      DestinationDetailSection.Content(title: "영업 시간", description: detail.openTime ?? emptyInfoString),
      DestinationDetailSection.Content(title: "포장 여부", description: detail.packing ?? emptyInfoString),
      DestinationDetailSection.Content(title: "주차 가능 여부", description: detail.parking ?? emptyInfoString),
      DestinationDetailSection.Content(title: "휴무일", description: detail.restDate ?? emptyInfoString),
      DestinationDetailSection.Content(title: "규모", description: detail.scale),
      DestinationDetailSection.Content(title: "좌석 수", description: detail.seat),
      DestinationDetailSection.Content(title: "메뉴", description: detail.treatMenu ?? emptyInfoString)
    ])
  }
  
  private func makeAttractionDetail(
    detail: DestinationEntity.AttractionDetail
  ) -> DestinationDetailSection {
    return .content([
      DestinationDetailSection.Content(
        title: "수용 가능 인원",
        description: detail.capacity
      ),
      DestinationDetailSection.Content(
        title: "유모차 대여 정보",
        description: detail.checkBabyStroller ?? emptyInfoString
      ),
      DestinationDetailSection.Content(
        title: "애완동물 동반 가능 여부",
        description: detail.checkPet ?? emptyInfoString
      ),
      DestinationDetailSection.Content(
        title: "체험 안내",
        description: detail.experienceGuide ?? emptyInfoString
      ),
      DestinationDetailSection.Content(
        title: "공개일",
        description: detail.openDate ?? emptyInfoString
      ),
      DestinationDetailSection.Content(
        title: "휴무일",
        description: detail.restDate ?? emptyInfoString
      ),
      DestinationDetailSection.Content(
        title: "이용 가능 시간",
        description: detail.usageTime ?? emptyInfoString
      )
    ])
  }
  
  private func makeFestivalDetail(detail: DestinationEntity.FestivalDetail) -> DestinationDetailSection {
    return .content([
      DestinationDetailSection.Content(title: "연령 제한", description: detail.ageLimit ?? emptyInfoString),
      DestinationDetailSection.Content(title: "축제 기간", description: makeFestivalDateString(
        startDate: detail.startDate,
        endDate: detail.endDate
      )),
      DestinationDetailSection.Content(title: "행사 지역", description: detail.eventPlace ?? emptyInfoString),
      DestinationDetailSection.Content(title: "행사 프로그램", description: detail.program ?? emptyInfoString),
      DestinationDetailSection.Content(title: "행사 기간", description: detail.showTime ?? emptyInfoString),
      DestinationDetailSection.Content(title: "소요 시간", description: detail.spendTime),
      DestinationDetailSection.Content(title: "개최자", description: detail.sponsor),
      DestinationDetailSection.Content(title: "요금", description: detail.usageFee ?? emptyInfoString)
    ])
  }
  
  private func makeCultureFacilityDetail(
    detail: DestinationEntity.CultureFacilityDetail
  ) -> DestinationDetailSection {
    return .content([
      DestinationDetailSection.Content(title: "수용인원", description: detail.capacity),
      DestinationDetailSection.Content(title: "유모차 대여 정보", description: detail.checkBabyStroller ?? emptyInfoString),
      DestinationDetailSection.Content(title: "애완동물 동반 여부", description: detail.checkPet ?? emptyInfoString),
      DestinationDetailSection.Content(title: "할인 정보", description: detail.discountInfo ?? emptyInfoString),
      DestinationDetailSection.Content(title: "주차 정보", description: detail.parking ?? emptyInfoString),
      DestinationDetailSection.Content(title: "주차 요금", description: detail.parkingFee ?? emptyInfoString),
      DestinationDetailSection.Content(title: "규모", description: detail.scale),
      DestinationDetailSection.Content(title: "관람 소요 시간", description: detail.spendTime),
      DestinationDetailSection.Content(title: "이용 요금", description: detail.usageFee ?? emptyInfoString),
      DestinationDetailSection.Content(title: "이용 요금 가능 시간", description: detail.usageTime ?? emptyInfoString)
    ])
  }
  
  private func makeLeportsDetail(
    detail: DestinationEntity.LeportsDetail
  ) -> DestinationDetailSection {
    return .content([
      DestinationDetailSection.Content(title: "규모 ", description: detail.capacity),
      DestinationDetailSection.Content(title: "유모차 대여 여부", description: detail.checkBabyStroller ?? emptyInfoString),
      DestinationDetailSection.Content(title: "애완동물 동반 여부", description: detail.checkPet ?? emptyInfoString),
      DestinationDetailSection.Content(title: "개방 시기", description: detail.openPeriod ?? emptyInfoString),
      DestinationDetailSection.Content(title: "주차 시설 여부", description: detail.parking ?? emptyInfoString),
      DestinationDetailSection.Content(title: "주차 요금", description: detail.parkingFee ?? emptyInfoString),
      DestinationDetailSection.Content(title: "나이 제한", description: detail.recommendedAge ?? emptyInfoString),
      DestinationDetailSection.Content(title: "이용 요금", description: detail.usageFee ?? emptyInfoString),
      DestinationDetailSection.Content(title: "사용 가능 시간", description: detail.usageTime ?? emptyInfoString)
    ])
  }
  
  private func makeFestivalDateString(startDate: Date?, endDate: Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    guard
      let startDate = startDate, let endDate = endDate
    else { return emptyInfoString }
    
    let startDateString = dateFormatter.string(from: startDate)
    let endDateString = dateFormatter.string(from: endDate)
    
    return startDateString + " ~ " + endDateString
  }
}

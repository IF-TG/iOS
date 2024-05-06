//
//  FestivalEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 4/29/24.
//

import Foundation

// 축제(행사)
struct FestivalEntity {
  let ageLimit: String?
  let startDate: Date
  let endDate: Date
  let address: String?
  let showTime: String?
  let fee: String?
  let title: String
  let image: Data
  let telNumber: String?
  let overview: String?
}

/*
 [공통정보조회]
 - 전화번호 v
 - 콘텐츠명(제목) v
 - 대표이미지 v
 - 주소 v
 - 개요(overview) v
 
 [소개정보조회]
 - 행사시작일 v
 - 행사종료일 v
 - 이용요금 v
 - 관람가능연령 v
 - 관람소요시간
 */

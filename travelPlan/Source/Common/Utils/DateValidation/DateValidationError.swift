//
//  DateValidationError.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

enum DateValidationError: Error {
  case invalidDateFormat
  case invalidStartTourDate
  case invalidEndTourDate
  case wrongDay
}

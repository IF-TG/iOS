//
//  ReviewWritingSaveRequestDTOTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 9/23/24.
//

@testable import travelPlan
import XCTest

final class ReviewWritingSaveRequestDTOTests: XCTestCase {
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
}

// MARK: - Tests
extension ReviewWritingSaveRequestDTOTests {
  func test_makeRequestDTO호출시_request의_구분자를_포함한content문자열이_순서에_맞게_만들어지는지() {
    // Arrange
    var result = true
    
    if let url = Bundle.main.url(forResource: "restaurant_1", withExtension: "png"),
       let data = try? Data(contentsOf: url) {
      
      let contents: [PostContentEntity] = [
        .image(data),
        .text("텍스트1텍스트1"),
        .image(data),
        .image(data),
        .image(data),
        .text("텍스트2텍스트2")
      ]
      
      let tempEntity = ReviewWritingEntity(
        postId: 123,
        category: .init(themes: [.adventure], regions: [.busan], seasons: [.fall], partners: [.alone]),
        tripDate: .init(startDate: Date(), endDate: Date()),
        title: "temp타이틀",
        contents: contents
      )
      
      // Act
      let responseContent = ReviewWritingSaveRequestDTO.makeRequestDTO(entity: tempEntity).content
      let contentArr = indexDelimitedByUUID(responseContent)
      
      var outerBreak = false
      
      for (i, content) in contents.enumerated() {
        let separatedString = contentArr[i].0
        let order = contentArr[i].1
        
        switch content {
        case .image(_):
          if !(isUUID(separatedString) && (i + 1 == order)) {
            result = false
            outerBreak = true
          }
        case .text(let textString):
          if !(textString == separatedString && (i + 1 == order)) {
            result = false
            outerBreak = true
          }
        }
        if outerBreak {
          break
        }
      }
    }
    
    // Assert
    XCTAssertTrue(result, "텍스트와 이미지의 순서가 제대로 적용되지 않음")
  }
}

private extension ReviewWritingSaveRequestDTOTests {
  func isUUID(_ string: String) -> Bool {
      return UUID(uuidString: string) != nil
  }
  
  func indexDelimitedByUUID(_ contentText: String) -> [(String, Int)] {
    // UUID 정규 표현식 패턴
    let uuidPattern = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
    guard let regex = try? NSRegularExpression(pattern: uuidPattern, options: []) else { return [] }
    
    var result = [(String, Int)]()
    var currentIndex = 1
    var lastPosition = contentText.startIndex
    
    // 정규식으로 매칭된 UUID 위치를 탐색합니다.
    let matches = regex.matches(
      in: contentText, options: [],
      range: NSRange(contentText.startIndex..., in: contentText)
    )
    
    for match in matches {
      let range = Range(match.range, in: contentText)!
      
      // UUID 앞의 텍스트 부분
      let prefixText = String(contentText[lastPosition..<range.lowerBound])
        .trimmingCharacters(in: .whitespacesAndNewlines)
      if !prefixText.isEmpty {
        // 텍스트에 인덱스 할당
        result.append((prefixText, currentIndex))
        currentIndex += 1
      }
      
      // UUID에 인덱스 할당
      let uuidString = String(contentText[range])
      result.append((uuidString, currentIndex))
      currentIndex += 1
      
      // UUID 뒤의 나머지 텍스트로 갱신
      lastPosition = range.upperBound
    }
    
    // 마지막 남은 텍스트 처리
    let finalText = String(contentText[lastPosition...]).trimmingCharacters(in: .whitespacesAndNewlines)
    if !finalText.isEmpty {
      result.append((finalText, currentIndex))
    }
    
    return result
  }
}

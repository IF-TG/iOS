//
//  DefaultTourFestivalInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/30/24.
//

import Foundation
import Combine
import Alamofire

final class DefaultTourFestivalInfoRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  private var isOccuredImageURLError = false
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - FestivalInfoInquiryRepository
extension DefaultTourFestivalInfoRepository: TourFestivalInfoRepository {
  func fetchFestivalList() -> AnyPublisher<[FestivalThumbnailEntity], any Error> {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let formattedDate = Int(dateFormatter.string(from: Date()))!
    
    let requestDTO = TourAPIFestivalRequestDTO(eventStartDate: formattedDate)
    let endpoint = TourAPIFestivalEndpoints.fetchFestivalList(with: requestDTO)
    
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapConnectionError()
        .tryMap {
          let resultCode = $0.response.header.resultCode
          if resultCode == "0000" {
            let group = DispatchGroup()
            var entities = [FestivalThumbnailEntity]()
            
            $0.response.body.items.item.forEach { responseDTO in
              DispatchQueue.global(qos: .userInteractive).async(group: group) {
                AF.request(responseDTO.imageURL)
                  .responseData(queue: .global(qos: .background)) { response in
                    // 서버에서 정렬시킨 response items인데, imageURL->Data 비동기 변환으로 인해 정렬 순서 바뀌지 않았는지 테스트해보자. 순서 바뀌는 이슈 있으면, 순서 바뀌지 않도록 고정해줘야 함.
                    if let imageData = response.data {
                      let entity = responseDTO.toFestivalThumbnailEntity(imageData: imageData)
                      entities.append(entity)
                    } else {
                      self?.isOccuredImageURLError = true
                    }
                  }
              }
            }
            group.wait()
            
            guard !(self?.isOccuredImageURLError ?? false) else {
              throw TourAPIError.cannotConvertImageURLToData
            }
            
            return entities
          } else {
            throw TourAPIError(
              code: String(resultCode.suffix(2))
            ) ?? .unexpectedErrorFromSuccessfulResponseData("Error code:\(resultCode)")
          }
        }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { entities in
          promise(.success(entities))
        }
      
      self?.subscriptions.insert(subscription)
    }
    .eraseToAnyPublisher()
  }
}

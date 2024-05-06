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
  private var subscriptions = Set<AnyCancellable>()
  
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
    let group = DispatchGroup()
    let imageConverter = ImageConverter()
    var entities = [FestivalThumbnailEntity]()
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .tryMap {
        let resultCode = $0.response.header.resultCode
        
        guard resultCode == "0000"
        else { throw TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2)))) }
        return $0.response.body.items.item
      }
      .map { [weak self, backgroundQueue] items in
        let group = DispatchGroup()
        var tupleArray = [(Int, FestivalThumbnailEntity)]()
        let imageConverter = ImageConverter()
        
        for (index, responseDTO) in items.enumerated() {
          group.enter()
          let subscription = imageConverter.request(imageURL: responseDTO.imageURL, queue: backgroundQueue)
            .sink { completion in
              if case .failure(_) = completion {
                group.leave()
              }
            } receiveValue: { imageData in
              let entity = responseDTO.toFestivalThumbnailEntity(imageData: imageData)
              tupleArray.append((index, entity))
              group.leave()
            }
          self?.subscriptions.insert(subscription)
          group.wait()
        }
        
        return tupleArray.sorted { $0.0 < $1.0 }.map { $0.1 }
      }.eraseToAnyPublisher()
  }
}

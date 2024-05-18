//
//  ImageSessionable.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation
import Alamofire
import Combine

protocol ImageSessionable {
  var session: Session { get }
  
  func request(imageURL: String, queue: DispatchQueue) -> AnyPublisher<Data, AFError>
}

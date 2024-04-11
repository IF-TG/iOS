//
//  ActivityIndicator.swift
//  travelPlan
//
//  Created by 양승현 on 4/11/24.
//

import Foundation
import Combine

// MARK: - ActivityIndicator
///
/// - Param relay : 진행중인 task 개수
/// - Param lock : 멀티 스레드에서 접근시 Race Condition 문제 방지하기 위해
///
/// Notes:
/// 1. 로컬 디비 접근할 때, 서버 통신에서 네으퉈크 상황이 좋지 않을 때를 대비해
///   인디케이터를 편하게 호출할 수 있도록 notify해주는  객체입니다.
///
/// 2. 이 객체는 주로 upstream's output, downstream's output를 감지하기 위해 디자인되었습니다.
///   한번 호출하고 종료되는 publhiser가 아닌, completion전까지 비동기적으로 계속 값을 방출할 때
///   값을 방출하는 초기시점과 값을 받기 전 시점에 주로 활용되도록 설계했습니다.
///
/// Examples:
/// ```
/// let subject1 = PassthroughSubject<Int, Never>()
///
/// var subjectSubscription: AnyCancellable?
/// var loadingSubscription: AnyCancellable
///
/// let activityIndicator = .init()
///
/// // 일반적인 로직
/// subjectSubscription = subejct1.flatMap { [weak self] value in
///   guard let activiryIndicator else {
///   return Just()... // 하위 스트림에게 에러관련 퍼블리셔 방출.
///   }
///   activityIndicator.trackActivity() // 필수!
///
///   return Just(value + 10)
///     .releaseActivity(activityIndicator)
///     .eraseToAnyPublihser()
/// }.sink { // 이때 sink or 하위 스트림에게 연속적으로 값을 제어하기 위해 방출.
///  ...
/// }
///
/// // 인디케이터 관리하기 위해 바인딩.
/// loadingSubscription = activiryIndicator.loading.sink { state in
/// switch state {
/// case begin:
///  // 인디케이터 호출 로직
/// case end:
///  // 인디케이터 호출 중지 로직
/// }
///
/// subject1.send(10)
/// // 1. trackActivity()로 relay 증가.
/// // 1-1. (relay가 0에서 1이 된다면 loading.send(.start))
/// // 2. Just(value+10) 방출 시점 relay 감소.
/// // 2-1. relay가 1에서 0이 된다면 loading.send(.end)
/// ```
@available(iOS 13.0, *)
public final class ActivityIndicator {
  // MARK: - Properties
  @Published private var relay = 0
  private let lock = NSLock()
  
  var loading: AnyPublisher<State, Never> {
    $relay.map { $0 > 0 ? .begin : .end }
      .removeDuplicates()
      .eraseToAnyPublisher()
  }
  
  // MARK: - Lifecycle
  public init() {}
  
  // MARK: - Helpers
  public func trackActivity() {
    increment()
  }
  
  public func releaseTackActivityOfPublihser<Source: Publisher>(
    source: Source
  ) -> AnyPublisher<Source.Output, Source.Failure> {
    return DownstreamActivityToken(source: source) { self.decrement()}.publisher
  }
  
  // MARK: - Private Helpers
  private func increment() {
    lock.lock()
    relay += 1
    lock.unlock()
  }
  
  private func decrement() {
    lock.lock()
    if relay > 0 {
      relay -= 1
    }
    lock.unlock()
  }
}

// MARK: - Nested
extension ActivityIndicator {
  /// Loading property's output value
  @frozen enum State {
    case begin
    case end
  }
  
  /// Upstream에서 값을 방출할 때 사용합니다.
  private struct UpstreamActivityToken<Source: Publisher> {
    private let source: Source
    private let beginAction: () -> Void
    
    init(source: Source, beginAction: @escaping () -> Void) {
      self.source = source
      self.beginAction = beginAction
    }
    
    /// track: ]
    var publihser: AnyPublisher<Source.Output, Source.Failure> {
      return source.handleEvents(receiveRequest: { _ in
        beginAction()
      }).eraseToAnyPublisher()
    }
  }
  
  private struct DownstreamActivityToken<Source: Publisher> {
    private let source: Source
    private let finishAction: () -> Void
    
    init(source: Source, finishAction: @escaping () -> Void) {
      self.source = source
      self.finishAction = finishAction
    }
    
    var publisher: AnyPublisher<Source.Output, Source.Failure> {
      return source.handleEvents(
        receiveOutput: { _ in
          finishAction()
        },
        receiveCompletion: { _ in
          finishAction()
        },
        receiveCancel: {
          finishAction()
        }).eraseToAnyPublisher()
    }
  }
}

// MARK: - Publihser+
extension Publisher {
  public func releaseActivity(_ activityIndicator: ActivityIndicator) -> AnyPublisher<Output, Failure> {
    activityIndicator.releaseTackActivityOfPublihser(source: self)
  }
}

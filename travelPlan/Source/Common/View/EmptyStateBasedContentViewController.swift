//
//  EmptyStateBasedContentViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/5/23.
//

import UIKit
import Combine

protocol EmptyStateBasedContentViewCheckable: AnyObject {
  var itemState: PassthroughSubject<Bool, Never> { get }
  var isShowingFirstAnimation: Bool { get }
}

class EmptyStateBasedContentViewController: UIViewController {
  // MARK: - Properties
  private let contentView: UIView & EmptyStateBasedContentViewCheckable
  
  private let emptyStateView: UIView = .init(frame: .zero)
  
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(contentView: UIView & EmptyStateBasedContentViewCheckable) {
    self.contentView = contentView
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !contentView.isShowingFirstAnimation {
      
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !contentView.isShowingFirstAnimation {
      
    }
  }
}

// MARK: - Private Helpers
private extension EmptyStateBasedContentViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupUI()
  }
  
  func bind() {
    subscription = contentView
      .itemState
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.emptyStateView.isHidden = $0 ? false : true
      }
  }
}

// MARK: - LayoutSupport
extension EmptyStateBasedContentViewController: LayoutSupport {
  func addSubviews() {
    _=[
      emptyStateView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      emptyStateViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension EmptyStateBasedContentViewController {
  var emptyStateViewConstraints: [NSLayoutConstraint] {
    return [
      emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
  }
}

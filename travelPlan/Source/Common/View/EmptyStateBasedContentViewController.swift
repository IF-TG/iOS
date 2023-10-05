//
//  EmptyStateBasedContentViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/5/23.
//

import UIKit
import Combine

protocol EmptyStateBasedContentViewCheckable: AnyObject {
  var hasItem: PassthroughSubject<Bool, Never> { get }
  var isShowingFirstAnimation: Bool { get }
}

class EmptyStateBasedContentViewController: UIViewController {
  // MARK: - Properties
  private let contentView: UIView & EmptyStateBasedContentViewCheckable
  
  private let emptyStateView: EmptyStateView
  
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(
    contentView: UIView & EmptyStateBasedContentViewCheckable,
    emptyState: EmptyStateView.UseageType
  ) {
    self.contentView = contentView
    self.emptyStateView = EmptyStateView(state: emptyState)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if contentView.isShowingFirstAnimation {
      emptyStateView.prepareAnimation()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if contentView.isShowingFirstAnimation {
      emptyStateView.showAnimation()
    }
  }
}

// MARK: - Private Helpers
private extension EmptyStateBasedContentViewController {
  func configureUI() {
    view.backgroundColor = .white
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    setupUI()
  }
  
  func bind() {
    subscription = contentView
      .hasItem
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        print("무야호")
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

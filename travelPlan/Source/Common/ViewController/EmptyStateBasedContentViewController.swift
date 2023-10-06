//
//  EmptyStateBasedContentViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/5/23.
//

import UIKit
import Combine

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
    if contentView.isShowingFirstAnimation, !contentView.hasItem.value {
      emptyStateView.prepareAnimation()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if contentView.isShowingFirstAnimation, !contentView.hasItem.value {
      emptyStateView.showAnimation()
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
      .hasItem
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.emptyStateView.isHidden = $0 ? true : false
      }
  }
}

// MARK: - LayoutSupport
extension EmptyStateBasedContentViewController: LayoutSupport {
  func addSubviews() {
    _=[
      emptyStateView,
      contentView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      emptyStateViewConstraints,
      contentViewConstraints
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
  
  var contentViewConstraints: [NSLayoutConstraint] {
    return [
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.topAnchor.constraint(equalTo: view.topAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
  }
}
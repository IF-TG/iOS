//
//  PhotoViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit
import SnapKit
import Photos

final class PhotoViewController: UIViewController {
  
  // MARK: - Properties
  private let albumService: AlbumService = YeogaAlbumService()
  private var albums = [PHFetchResult<PHAsset>]()
  
  private lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    cv.delegate = self
    cv.dataSource = self
    return cv
  }()
  
  private lazy var cancelButton: BaseNavigationLeftButton = .init().set {
    $0.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
  }
  
  private lazy var finishButton: BaseNavigationRightButton = .init().set {
    $0.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
  }
  
  private lazy var titleView: NavigationTitleWithClickView = .init(
    title: "최근 항목",
    layoutType: .rightImage
  ).set {
    self.addGestureRecognizer(from: $0, action: #selector(didTapTitleView))
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    loadAlbums(completion: { [weak self] in
      self?.loadImages()
    })
  }
}

// MARK: - UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    return .init()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
  
}

// MARK: - Private Helpers
extension PhotoViewController {
  private func loadAlbums(completion: @escaping () -> Void) {
    albumService.getAlbums(mediaType: .image) { [weak self] albumInfos in
      self?.albums = albumInfos.map(\.album)
      completion()
    }
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = .init(customView: cancelButton)
    navigationItem.rightBarButtonItem = .init(customView: finishButton)
    navigationItem.titleView = titleView
  }
  
  private func addGestureRecognizer(from view: UIView, action: Selector?) {
    let tapGesture = UITapGestureRecognizer(target: self, action: action)
    view.addGestureRecognizer(tapGesture)
  }
}

// MARK: - Actions
private extension PhotoViewController {
  @objc func didTapCancelButton(_ sender: UIButton) {
    print("취소 버튼 클릭")
  }
  
  @objc func didTapFinishButton(_ sender: UIButton) {
    print("완료 버튼 클릭")
  }
  
  @objc func didTapTitleView() {
    print("최근항목 선택됨")
  }
}

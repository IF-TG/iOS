//
//  MyInformationAlbumSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import Combine
import Photos
import UIKit

final class MyInformationAlbumSheetViewController: BaseBottomSheetViewController {
  // MARK: - Nested
  enum Menu: String, CaseIterable {
    case camera = "사진 찍기"
    case album = "앨범에서 선택"
  }
  
  // MARK: - Properties
  @Published var hasSelectedProfile: UIImage?
  
  // MARK: - Lifecycle
  init() {
    let dividers: [UIView] = (0...1).map { _ in
      return UIView(frame: .zero).set {
        $0.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        $0.backgroundColor = .yg.gray1
      }
    }
    let labels = Menu.allCases.map { menu in
      return BasePaddingLabel(
        padding: .init(top: 15, left: 35, bottom: 15, right: 35),
        fontType: .semiBold_600(fontSize: 16),
        lineHeight: 25
      ).set {
        $0.isUserInteractionEnabled = true
        $0.text = menu.rawValue
        $0.textColor = .yg.gray5
      }
    }
    let stackView = UIStackView(arrangedSubviews: [labels[0], dividers[0], labels[1], dividers[1]]).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.isUserInteractionEnabled = true
      $0.axis = .vertical
      $0.spacing = 0
      $0.distribution = .fill
      $0.backgroundColor = .white
    }
    super.init(contentView: stackView, mode: .couldBeFull, radius: 13)
    labels.forEach {
      $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBottomSheetComponent)))
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.isUserInteractionEnabled = true
    touchSleep = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Action
extension MyInformationAlbumSheetViewController {
  @objc func didTapBottomSheetComponent(_ gesture: UITapGestureRecognizer) {
    guard let selectedLabel = gesture.view as? UILabel, let text = selectedLabel.text else {
      return
    }
    
    let menu = Menu(rawValue: text)
    
    switch menu {
    case .camera:
      requestCameraAccessAndPresentPicker()
    case .album:
      requestPhotoLibraryAccessAndPresentPicker()
    default:
      return
    }
  }
  
  private func requestCameraAccessAndPresentPicker() {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .authorized:
      presentImagePicker(sourceType: .camera)
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          DispatchQueue.main.async {
            self.presentImagePicker(sourceType: .camera)
          }
        } else {
          self.showAccessDeniedAlert(for: "카메라")
        }
      }
    case .denied, .restricted:
      showAccessDeniedAlert(for: "카메라")
    default: break
    }
  }
  
  private func requestPhotoLibraryAccessAndPresentPicker() {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
      presentImagePicker(sourceType: .photoLibrary)
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          DispatchQueue.main.async {
            self.presentImagePicker(sourceType: .photoLibrary)
          }
        } else {
          self.showAccessDeniedAlert(for: "사진 라이브러리")
        }
      }
    case .denied, .restricted:
      showAccessDeniedAlert(for: "사진 라이브러리")
    default: break
    }
  }
  
  private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
      return
    }
    
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.sourceType = sourceType
    self.view.isUserInteractionEnabled = false
    if sourceType == .camera {
      touchSleep = true
      picker.allowsEditing = false
      picker.cameraCaptureMode = .photo
      picker.modalPresentationStyle = .fullScreen
    }
    picker.delegate = self
    present(picker, animated: true)
  }
  
  private func showAccessDeniedAlert(for feature: String) {
    let alert = UIAlertController(
      title: "\(feature) 접근 불가",
      message: "앱 설정에서 \(feature) 접근을 허용해주세요.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension MyInformationAlbumSheetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    if let image = info[.editedImage] as? UIImage {
      hasSelectedProfile = image
    }
    picker.dismiss(animated: true, completion: nil)
    dismiss(animated: false)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    dismiss(animated: false)
  }
}

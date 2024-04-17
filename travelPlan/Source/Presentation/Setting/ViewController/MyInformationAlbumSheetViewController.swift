//
//  MyInformationAlbumSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import UIKit
import Combine

final class MyInformationAlbumSheetViewController: BaseBottomSheetViewController {
  // MARK: - Nested
  enum Menu: String, CaseIterable {
    case camera = "사진 찍기"
    case album = "엘범에서 선택"
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
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    let menu = Menu(rawValue: text)
    switch menu {
    case .camera:
      picker.sourceType = .camera
      picker.cameraDevice = .rear
      picker.cameraCaptureMode = .photo
    case .album:
      picker.sourceType = .photoLibrary
    default:
      return
    }
    present(picker, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension MyInformationAlbumSheetViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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

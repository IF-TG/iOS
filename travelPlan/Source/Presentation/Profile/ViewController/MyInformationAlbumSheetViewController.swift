//
//  MyInformationAlbumSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import UIKit
import Combine

final class MyInformationAlbumSheetViewController: BaseBottomSheetViewController {
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
    let titles = ["사진 찍기", "앨범에서 선택"]
    let labels = (0...1).map { index in
      return BasePaddingLabel(
        padding: .init(top: 15, left: 35, bottom: 15, right: 35),
        fontType: .semiBold_600(fontSize: 16),
        lineHeight: 25
      ).set {
        $0.isUserInteractionEnabled = true
        $0.text = titles[index]
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
    dismiss(animated: false)
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    switch text {
    case "사진 찍기":
      picker.sourceType = .camera
      picker.cameraDevice = .rear
      picker.cameraCaptureMode = .photo
    case "앨범에서 선택":
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
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

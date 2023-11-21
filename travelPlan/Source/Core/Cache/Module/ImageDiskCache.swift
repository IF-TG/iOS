//
//  ImageDiskCache.swift
//  travelPlan
//
//  Created by 양승현 on 11/21/23.
//

import UIKit.UIImage

class ImageDiskCache {
  private var storage: FileManager {
    return FileManager.default
  }
  
  private var folderURL: URL? {
    /// 디렉터리가 없을 경우 자동으로 생성
    return FileManager.default.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    )[0].appendingPathComponent(".cache")
  }
}

// MARK: - Helpers
extension ImageDiskCache {
  /// 경로 생성
  func imageURL(for key: String) -> URL? {
    return folderURL?.appendingPathComponent(key)
  }
  
  func loadImage(with key: String) -> UIImage? {
    guard
      let imageURL = imageURL(for: key),
      storage.fileExists(atPath: imageURL.path)
    else { return nil }
    return UIImage.init(contentsOfFile: imageURL.path)
  }
  
  func save(_ image: UIImage, with key: String) {
    guard let imageURL = imageURL(for: key) else {
      return
    }
    
    if !hasExistFile(atPath: imageURL.path) {
      storage.createFile(atPath: imageURL.path, contents: nil, attributes: nil)
    }
    guard let data = image.jpegData(compressionQuality: 1) else {
      print("DEBUG: Image 데이터가 존재하지 않습니다.")
      return
    }
    try? data.write(to: imageURL)
  }
  
  func removeImage(with key: String) -> Bool {
    guard let imageURL = imageURL(for: key) else {
      print("DEBUG: Image 경로가 없습니다")
      return true
    }
    guard storage.fileExists(atPath: imageURL.path) else {
      print("DEBUG: 파일이 없습니다.")
      return true
    }
    try? storage.removeItem(at: imageURL)
    return true
  }
  
  func hasExistFile(atPath path: String) -> Bool {
    return storage.fileExists(atPath: path)
  }
  
  func hasExistFile(atKey key: String) -> Bool {
    guard let path = folderURL?.appendingPathComponent(key).path else {
      return false
    }
    return hasExistFile(atPath: path)
  }
  
  func removeAllImages() {
    guard let folderURL else {
      print("DEBUG: .cache경로가 존재하지 않습니다.")
      return
    }
    
    do {
      let imageFiles = try storage.contentsOfDirectory(atPath: folderURL.path)
      for imageFile in imageFiles {
        try? storage.removeItem(at: folderURL.appendingPathExtension(imageFile))
      }
    } catch {
      print("DEBUG: ImageDiskCache 디렉터리의 폴더 중 에러 발생: \(error.localizedDescription)")
    }
  }
}

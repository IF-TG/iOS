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
    /// 디렉터리 안만들면 이 경로 생성x
    return FileManager.default.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    )[0].appendingPathComponent(".cache")
  }
  
  init() {
    createCacheDirectory()
  }
}

// MARK: - Helpers
extension ImageDiskCache {
  /// 경로 생성
  func imageFileURL(for key: String) -> URL? {
    return folderURL?.appendingPathComponent("\(key).txt")
  }
  
  func loadImage(with key: String) -> UIImage? {
    guard
      let imageURL = imageFileURL(for: key),
      storage.fileExists(atPath: imageURL.path)
    else { return nil }
    return UIImage.init(contentsOfFile: imageURL.path)
  }
  
  func save(_ image: UIImage, with key: String) {
    guard let imageURL = imageFileURL(for: key) else {
      return
    }
    
    if !hasExistFile(atPath: imageURL.path) {
      print("파일 생성")
      storage.createFile(atPath: imageURL.path, contents: nil, attributes: nil)
    }
    
    guard let data = image.jpegData(compressionQuality: 1) else {
      print("DEBUG: Image 데이터가 존재하지 않습니다.")
      return
    }
    do {
      try data.write(to: imageURL, options: .atomic)
    } catch {
      print("DEBUG: 파일 write 실패 \(error.localizedDescription)")
    }
  }
  
  func removeImage(with key: String) -> Bool {
    guard let imageURL = imageFileURL(for: key) else {
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
    guard let path = imageFileURL(for: key)?.path else {
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
        print("삭제할 파일", imageFile)
        try? storage.removeItem(at: folderURL.appendingPathExtension(imageFile))
      }
    } catch {
      print("DEBUG: ImageDiskCache 디렉터리의 폴더 중 에러 발생: \(error.localizedDescription)")
    }
  }
  
  private func createCacheDirectory() {
    do {
      let cacheDirectoryURL = try FileManager.default.url(
        for: .cachesDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      ).appendingPathComponent(".cache")
      
      if !FileManager.default.fileExists(atPath: cacheDirectoryURL.path) {
        try FileManager.default.createDirectory(
          at: cacheDirectoryURL,
          withIntermediateDirectories: true,
          attributes: nil)
      }
    } catch {
      print("DEBUG: 디렉터리 생성 실패: \(error.localizedDescription)")
    }
  }
}

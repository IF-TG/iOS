//
//  UIViewController+Preview.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import UIKit
import SwiftUI

// SwiftUI 활용해서 Preview 생성
// opt + Cmd + enter: 미리보기 창 열기
// opt + Cmd + P: 실행

// 원하는 파일에 주석 코드를 추가하고, 위의 단축키를 통해 사용하시면 됩니다.

// #if canImport(SwiftUI) && DEBUG
// import SwiftUI
// struct 사용할VC이름PreView:
// PreviewProvider {
//   static var previews: some View {
//     사용할VC().toPreview()
//   }
// }
// #endif

#if DEBUG
extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
      return viewController
    }
    
    func updateUIViewController(
      _ uiViewController: UIViewController,
      context: Context
    ) { }
  }
  
  func toPreview() -> some View {
    Preview(viewController: self)
  }
}
#endif

//
//  NoticeCell.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit

final class NoticeCell: UITableViewCell {
  static let id = String(describing: NoticeCell.self)
  
  enum Constant {
    enum TitleLabel {
      static let font = UIFont(pretendard: .regular, size: 15)
      static let fontColor = UIColor.yg.gray5
      enum Spacing {
        static let leading: CGFloat = 12
        static let top: CGFloat = 15
        static let trailing: CGFloat = 60
      }
    }
    enum ChevronIcon {
      static let size = CGSize(width: 24, height: 24)
      enum Spacing {
        static let trailing: CGFloat = 10
      }
    }
    enum DateLabel {
      static let font = UIFont(pretendard: .regular, size: 15)
      static let fontColor = UIColor.yg.gray3
      enum Spacing {
        static let leading: CGFloat = 12
        static let bottom: CGFloat = 15
      }
    }
    enum CellDivider {
      static let color = UIColor.yg.gray0
      static let height = 1
    }
    enum ExpendableLabel {
      static let font = UIFont(pretendard: .regular, size: 15)
      static let attributes: [NSAttributedString.Key: Any] = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.28
        return [.paragraphStyle: paragraph]
      }()
    }
  }
}

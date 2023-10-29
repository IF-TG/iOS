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
      static let inset = UIEdgeInsets(top: 20, left: 11, bottom: 20, right: 11)
      static let font = UIFont(pretendard: .regular, size: 15)
      static let attributes: [NSAttributedString.Key: Any] = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.28
        return [.paragraphStyle: paragraph]
      }()
    }
  }
  
  // MARK: - Properties
  private let titleLabel = UILabel(frame: .zero).set {
    typealias Const = Constant.TitleLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.textColor = Const.fontColor
    $0.numberOfLines = 2
  }
  
  private let chevronIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "chevron")
  }
  
  private let dateLabel = UILabel(frame: .zero).set {
    typealias Const = Constant.DateLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.textColor = Const.fontColor
    $0.numberOfLines = 1
  }
  
  private let cellDivider = UIView(frame: .zero).set {
    typealias Const = Constant.CellDivider
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = Const.color
  }
  
  private let expendableLabel = BasePaddingLabel(padding: Constant.ExpendableLabel.inset).set {
    typealias Const = Constant.ExpendableLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.numberOfLines = 0
  }
  
  var isExpended = false {
    didSet {
      
    }
  }
}

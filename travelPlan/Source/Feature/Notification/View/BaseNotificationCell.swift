//
//  BaseNotificationCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import UIKit

class BaseNotificationCell: UITableViewCell {
  enum Constant {
    enum Icon {
      static let size = CGSize(width: 24, height: 24)
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 20
      }
    }
    enum BaseContentView {
      enum Spacing {
        static let leading: CGFloat = 13
        static let top: CGFloat = 15
        static let bottom: CGFloat = 15
        
      }
    }
    enum CloseButton {
      static let size = CGSize(width: 20, height: 20)
      enum Spacing {
        static let leading: CGFloat = 8
        static let top: CGFloat = 15
        static let trailing: CGFloat = 9
      }
    }
    enum CellDivider {
      static let backgroundColor: UIColor = .yg.gray0
      static let height: CGFloat = 1
    }
  }
  
  // MARK: - Properties
  private let icon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
  }
  
  private let baseContentView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var closeButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let cellDivider = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = Constant.CellDivider.backgroundColor
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

//
//  PostViewConstant.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

// MARK: - PostViewCell UI Constant
extension PostCell {
  struct Constant {
    private init() {}
    static let constant = Constant()
    var intrinsicHeightWithOutContentTextHeight: CGFloat = {
      return PostHeaderView.Constant.constant.instrinsicHeight +
      PostContentAreaView.Constant.constant.intrinsicHeight +
      PostContentAreaView.Constant.Text.Spacing.top +
      PostContentAreaView.Constant.Text.Spacing.bottom +
      PostFooterView.Constant.footerViewheight
    }()
    struct Line {
      static let bgColor: UIColor = .yg.gray0
      static let height: CGFloat = 1
      struct Spacing {
        static let leading: CGFloat = 30
        static let trailing: CGFloat = 30
      }
    }
    struct FooterView {
      struct Spacing {
        static let bottom: CGFloat = 17
        static let top: CGFloat = 17
      }
    }
  }
}

// MARK: - PostHeaderView UI Constant
extension PostHeaderView {
  struct Constant {
    private init() { }
    static let constant = Constant()
    let instrinsicHeight = {
      return UserProfileImage.Spacing.top + UserProfileImage.height + UserProfileImage.Spacing.bottom
    }()
    enum UserProfileImage {
      static let width: CGFloat = 40
      static let height: CGFloat = 40
      enum Spacing {
        static let leading: CGFloat = 29.5
        static let top: CGFloat = 20
        static let bottom: CGFloat = 5
      }
    }
    enum Title {
      static let textColor: UIColor = .yg.gray7
      static let font: UIFont = UIFont(pretendard: .semiBold, size: 18)!
      enum Spacing {
        static let top: CGFloat = 20
        static let leading: CGFloat = 21.5
        static let trailing: CGFloat = 51.5
      }
    }
    enum SubInfoView {
      enum Spacing {
        static let top: CGFloat = 5
        static let leading: CGFloat = 21.5
        static let trailing: CGFloat = 73
        static let bottom: CGFloat = 7
      }
    }
    enum OptionView {
      static let size = CGSize(width: 1.67, height: 13.33)
      static let selectedImage = UIImage(named: "feedOption")
      static let unselectedImage = UIImage(named: "feedOption")?.setColor(.yg.gray4.withAlphaComponent(0.5))
      struct Spacing {
        static let top: CGFloat = 38.33
        static let trailing: CGFloat = 39.67
      }
    }
  }
}

// MARK: - PostHeaderSubInfoView UI Constant
extension PostHeaderSubInfoView {
  enum Constant {
    enum UserName {
      static let textColor: UIColor = .yg.gray5
      static let font: UIFont = UIFont(pretendard: .medium, size: 10)!
      static let width: CGFloat = 70
    }
    enum Duration {
      static let textColor: UIColor = .yg.gray5
      static let font: UIFont = UIFont(pretendard: .medium, size: 10)!
      static let width: CGFloat = 31
      struct Spacing {
        static let leading: CGFloat = 10
        static let trailing: CGFloat = 10
      }
    }
    enum DateRange {
      static let textColor: UIColor = .yg.gray5
      static let font: UIFont = UIFont(pretendard: .medium, size: 10)!
      static let width: CGFloat = 86
      enum Spacing {
        static let leading: CGFloat = 10
      }
    }
    enum Divider {
      static let bgColor: UIColor = .yg.gray5
      static let width: CGFloat = 1
      static let height: CGFloat = 13
      struct Spacing {
        static let leading: CGFloat = 10
      }
    }
  }
}

// MARK: - PostContentAreaView UI Constant
extension PostContentAreaView {
  struct Constant {
    private init() { }
    static let constant = Constant()
    let intrinsicHeight = Constant.imageHeight + ImageSpacing.top
    
    static let imageHeight: CGFloat = 118
    enum ImageSpacing {
      static let leading: CGFloat = 30
      static let trailing: CGFloat = 30
      static let top: CGFloat = 8
    }
    enum Text {
      static let textSize: CGFloat = 14
      static let lineBreakMode: NSLineBreakMode = .byWordWrapping
      static let font: UIFont = UIFont(
        pretendard: .regular, size: 14)!
      enum Spacing {
        static let top: CGFloat = 12
        static let bottom: CGFloat = 4
        static let leading: CGFloat = 30
        static let trailing: CGFloat = 30
      }
      static let postIntrinsicContentHeight = {
        return 1
      }()
    }
  }
}

// MARK: - PostThumbnailView UI Constant
extension PostThumbnailView {
  struct Constant {
    private static let intrinsicWidth = (UIScreen.main.bounds.width - PostContentAreaView
      .Constant.ImageSpacing.leading*2)
    static let spacing: CGFloat = 1
    static let cornerRadius: CGFloat = 10
    static let height: CGFloat = 117
    static let smallWidth: CGFloat = {
      (((intrinsicWidth-spacing)/2) - spacing) / 2
    }()
    static let smallHeight: CGFloat = 58
    static let mediumWidth: CGFloat = {
     ( intrinsicWidth - spacing ) / 2
    }()
  }
}

// MARK: - PostFooterView UI Constant
extension PostFooterView {
  enum Constant {
    static let footerViewheight: CGFloat = 50
    enum HeartSV {
      static let width: CGFloat = 60
      static let spacing: CGFloat = 16
      static let height: CGFloat = 20
      struct Spacing {
        static let leading: CGFloat = 51
      }
    }
    enum Heart {
      static let iconName = "feedHeart"
      static let colorHex = "#FE0135"
      static let minimumsSize = CGSize(width: 15, height: 15)
      // 이거 정해야 합니다.
      // static let selectedImage: UIImage =
      static let unselectedImage = UIImage(
        named: Constant.Heart.iconName)?
        .setColor(UIColor(hex: Constant.Heart.colorHex))
      
      enum Text {
        static let font: UIFont = UIFont(pretendard: .regular, size: 13)!
        static let fontColor: UIColor = .yg.gray4
      }
    }
    enum Comment {
      static let iconName = "feedComment"
      static let minimumsSize = CGSize(width: 15, height: 15)
      struct Text {
        static let font: UIFont = UIFont(pretendard: .regular, size: 13)!
        static let fontColor: UIColor = .yg.gray4
      }
    }
    enum Share {
      static let iconName = "feedShare"
      struct Spacing {
        static let trailing: CGFloat = 53
      }
    }
    
    enum CommentSV {
      static let width: CGFloat = 40
      static let height: CGFloat = 20
      static let spacing: CGFloat = 16
      struct Spacing {
        static let leading: CGFloat = 89.5
      }
    }
  }
}

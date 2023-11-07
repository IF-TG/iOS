//
//  PostDetailViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

struct postDetailViewInfo {
  /// 임시
  let categoryText: String
  let title: String
  let profileAreaInfo: PostDetailProfileAreaInfo
}

final class PostDetailViewController: UIViewController {
  enum Constant {
    enum ProfileAreaViewSpacing {
      static let leaidng: CGFloat = 10
      static let trailing: CGFloat = 10
      static let top: CGFloat = 10
    }
  }
  // MARK: - Properties
  private let categoryLabel = BasePaddingLabel(
    padding: .init(top: 16.5, left: 20, bottom: 8.5, right: 20),
    fontType: .medium_500(fontSize: 14),
    lineHeight: 16.71
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .yg.gray4
  }
  
  private let titleLabel = BasePaddingLabel(
    padding: .init(top: 10, left: 20, bottom: 10, right: 20),
    fontType: .semiBold_600(fontSize: 30),
    lineHeight: 35.8
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .yg.gray7
    $0.numberOfLines = 2
  }
  
  private let profileAreaView = PostDetailProfileAreaView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      self.makeMockData()
    }
  }
}

// MARK: - Private Helpers
private extension PostDetailViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupUI()
  }
  
  func configure(with info: postDetailViewInfo) {
    categoryLabel.text = info.categoryText
    // 임시
    let firstChevronHighlight = HighlightFontInfo(
      fontType: .bold_700(fontSize: 15),
      text: ">")
    let lastChevronHighlight = HighlightFontInfo(
      fontType: .bold_700(fontSize: 15),
      text: ">",
      startIndex: "여행테마 > 휴식, 동반자 ".count)
    categoryLabel.setHighlights(with: firstChevronHighlight, lastChevronHighlight)
    titleLabel.text = info.title
    profileAreaView.configure(with: info.profileAreaInfo)
  }
  
  func makeMockData() {
    let profileAreaInfo = PostDetailProfileAreaInfo(
      userName: "닉네임은 여덟자리",
      userId: "0",
      userThumbnailPath: "tempProfile1",
      travelDuration: "1박 2일",
      travelCalendarDateRange: "23.12.31 ~ 23.12.31",
      uploadedDescription: "2023. 12. 31 12:12")
    let postDetailViewInfo = postDetailViewInfo(
      categoryText: "여행테마 > 휴식, 동반자 > 가족 ...",
      title: "곧 크리스마스가 다가옵니다. 하하하. 미리매리크리스마스~",
      profileAreaInfo: profileAreaInfo)
    configure(with: postDetailViewInfo)
  }
}

// MARK: - LayoutSupport
extension PostDetailViewController: LayoutSupport {
  func addSubviews() {
    _=[
      categoryLabel,
      titleLabel,
      profileAreaView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      categoryLabelConstraints,
      titleLabelConstraints,
      profileAreaViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostDetailViewController {
  var categoryLabelConstraints: [NSLayoutConstraint] {
    return [
      categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
  }
  
  var titleLabelConstraints: [NSLayoutConstraint] {
    return [
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
  }
  
  var profileAreaViewConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.ProfileAreaViewSpacing
    return [
      profileAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.leaidng),
      profileAreaView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.top),
      profileAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.trailing)]
  }
}

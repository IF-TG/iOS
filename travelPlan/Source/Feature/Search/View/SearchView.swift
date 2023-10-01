//
//  SearchView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import UIKit
import SnapKit

final class SearchView: UIView {
  enum Constants {
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 25
    
    enum SearchButton {
      static let imageName = "search"
      enum Offset {
        static let leading: CGFloat = 10
      }
      enum Inset {
        static let trailing: CGFloat = 20
        static let topBottom: CGFloat = 11
      }
    }
    
    enum SearchTextField {
      static let placeholder = "여행지 및 축제를 검색해보세요."
      static let fontSize: CGFloat = 14
      enum Inset {
        static let leading: CGFloat = 20
      }
    }
    
    enum ShadowLayer {
      static let shadowOpacity: Float = 0.2
      static let shadowRadius: CGFloat = 5
      static let shadowOffsetHeight: CGFloat = 4
    }
  }
  
  // MARK: - Properties
  weak var delegate: SearchViewDelegate?
  
  private lazy var searchTextField: UITextField = UITextField().set {
    $0.attributedPlaceholder = .init(
      string: Constants.SearchTextField.placeholder,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.yg.gray1]
    )
    $0.font = .init(pretendard: .regular, size: Constants.SearchTextField.fontSize)
    $0.textColor = .yg.gray5
    
    $0.delegate = self
  }
  
  private lazy var searchButton: UIButton = UIButton().set {
    let image = UIImage(named: Constants.SearchButton.imageName)?
      .withRenderingMode(.alwaysTemplate)
    
    $0.setImage(image, for: .normal)
    $0.tintColor = .yg.primary
    $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
  }
  
  private let shadowLayer: CALayer = .init().set {
    $0.shadowColor = UIColor.yg.primary.cgColor
    $0.backgroundColor = UIColor.systemBackground.cgColor
    $0.shadowOpacity = Constants.ShadowLayer.shadowOpacity
    $0.shadowRadius = Constants.ShadowLayer.shadowRadius
    $0.cornerRadius = SearchView.Constants.cornerRadius
    $0.shadowOffset = CGSize(width: CGFloat.zero,
                             height: Constants.ShadowLayer.shadowOffsetHeight)
  }
  
  override var bounds: CGRect {
    didSet {
      setupShadowLayer()
    }
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public Helpers
extension SearchView {
  private func setupShadowLayer() {
    shadowLayer.frame = self.bounds
    
    shadowLayer.shadowPath = UIBezierPath(
      roundedRect: shadowLayer.bounds,
      cornerRadius: SearchView.Constants.cornerRadius
    ).cgPath
  }
}

// MARK: - Helpers
extension SearchView {
  // shadowTODO: - SearchView의 shadow를 추가해야합니다.
  private func setupStyles() {
    layer.borderColor = UIColor.yg.primary.cgColor
    layer.borderWidth = SearchView.Constants.borderWidth
    layer.cornerRadius = SearchView.Constants.cornerRadius
  }
}

// MARK: - Actions
extension SearchView {
  @objc private func didTapSearchButton() {
    delegate?.didTapSearchButton(self, text: searchTextField.text ?? "")
  }
}

// MARK: - LayoutSupport
extension SearchView: LayoutSupport {
  func addSubviews() {
    layer.addSublayer(shadowLayer)
    
    addSubview(searchTextField)
    addSubview(searchButton)
  }
  
  func setConstraints() {
    searchTextField.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Constants.SearchTextField.Inset.leading)
      $0.centerY.equalToSuperview()
    }
    
    searchButton.snp.makeConstraints {
      $0.leading.equalTo(searchTextField.snp.trailing)
        .offset(Constants.SearchButton.Offset.leading)
      $0.trailing.equalToSuperview().inset(Constants.SearchButton.Inset.trailing)
      $0.top.bottom.equalToSuperview().inset(Constants.SearchButton.Inset.topBottom)
      $0.width.equalTo(searchButton.snp.height)
    }
  }
}

// MARK: - UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

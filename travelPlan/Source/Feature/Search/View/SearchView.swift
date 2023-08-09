//
//  SearchView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/29.
//

import UIKit
import SnapKit

final class SearchView: UIView {
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

// MARK: - Helpers
extension SearchView {
  private func setupStyles() {
    layer.borderColor = UIColor.yg.primary.cgColor
    layer.borderWidth = SearchView.Constants.borderWidth
    layer.cornerRadius = SearchView.Constants.cornerRadius
  }
}

// MARK: - Actions
extension SearchView {
  @objc private func didTapSearchButton() {
    delegate?.didTapSearchButton(text: searchTextField.text ?? "")
  }
}

// MARK: - LayoutSupport
extension SearchView: LayoutSupport {
  func addSubviews() {
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

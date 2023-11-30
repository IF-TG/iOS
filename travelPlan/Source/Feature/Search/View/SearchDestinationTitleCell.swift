//
//  SearchDestinationTitleCell.swift
//  travelPlan
//
//  Created by SeokHyun on 11/28/23.
//

import UIKit
import SnapKit

final class SearchDestinationTitleCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String.init(describing: SearchDestinationTitleCell.self)
  
  private let titleLabel = UILabel().set {
    $0.font = .init(pretendard: .medium_500(fontSize: 22))
    $0.textColor = .yg.gray7
    $0.text = "타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀"
    $0.numberOfLines = 0
  }

  private let addressLabel = UILabel().set {
    $0.text = "주주소주주소주주소주주소주주소주주소주주소주주소주주소주주소주주소"
    $0.font = .init(pretendard: .regular_400(fontSize: 13))
    $0.textColor = .yg.gray6
  }
  
  private let mapImageView = UIImageView(image: .init(named: "marker-pin"))
  
  // TODO: - 주소 text에 따라서 toggleButton 유무 설정하기
  private let copyStackView = UIStackView().set {
    $0.axis = .horizontal
    $0.spacing = 2
  }
  private lazy var toggleButton = UIButton().set {
    $0.setImage(.init(named: "chevron"), for: .normal)
    $0.imageView?.tintColor = .yg.gray6
    $0.addTarget(self, action: #selector(didTapToggleButton), for: .touchUpInside)
  }
  private lazy var copyAddressButton = UIButton().set {
    $0.setTitle("복사", for: .normal)
    $0.setTitleColor(.yg.highlight, for: .normal)
    $0.titleLabel?.font = .init(pretendard: .medium_500(fontSize: 13))
    $0.addTarget(self, action: #selector(didTapCopyAddressButton), for: .touchUpInside)
  }
  
  private let heartStackView = UIStackView().set {
    $0.axis = .horizontal
    $0.alignment = .center
  }
  
  private lazy var heartButton = UIButton().set {
    let unselectedHeartImage = UIImage.transformImageSize(named: "unselectedHeart",
                                                          size: .init(width: 22, height: 22))
    let selectedHeartImage = UIImage.transformImageSize(named: "selectedHeart",
                                                        size: .init(width: 22, height: 22))
    $0.setImage(unselectedHeartImage, for: .normal)
    $0.setImage(selectedHeartImage, for: .selected)
    $0.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
  }
  private let heartCountLabel = UILabel().set {
    $0.text = "+1"
    $0.textColor = .yg.gray6
    $0.font = .init(pretendard: .regular_400(fontSize: 14))
  }

//  private let shadowLayer = CALayer()
  
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

// MARK: - LayoutSupport
extension SearchDestinationTitleCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(mapImageView)
    contentView.addSubview(addressLabel)
    contentView.addSubview(copyStackView)
    contentView.addSubview(heartStackView)
    
    [toggleButton,
     copyAddressButton]
      .forEach { copyStackView.addArrangedSubview($0) }
    
    [heartButton,
     heartCountLabel]
      .forEach { heartStackView.addArrangedSubview($0) }
  }
  
  func setConstraints() {
    setupContentCompressionResistancePriorities()
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20)
      $0.leading.equalToSuperview().inset(16)
      $0.bottom.equalTo(mapImageView.snp.top).offset(-20)
      $0.trailing.lessThanOrEqualTo(heartStackView.snp.leading).offset(-38)
    }
    
    mapImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(20)
      $0.size.equalTo(16)
    }
    
    addressLabel.snp.makeConstraints {
      $0.leading.equalTo(mapImageView.snp.trailing).offset(2)
      $0.centerY.equalTo(mapImageView)
    }
    
    copyStackView.snp.makeConstraints {
      $0.leading.equalTo(addressLabel.snp.trailing)
      $0.trailing.lessThanOrEqualToSuperview().inset(90)
      $0.centerY.equalTo(mapImageView)
    }
    
    heartStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(16)
    }
  }
}

// MARK: - Helpers
extension SearchDestinationTitleCell {
  func configure(title: String?, address: String?) {
    titleLabel.text = title
    addressLabel.text = address
  }
  
  func updateToggleButtonVisibility() {
    addressLabel.layoutIfNeeded()
    
    let decreaseLabelWidth = addressLabel.intrinsicContentSize != addressLabel.frame.size
    if decreaseLabelWidth {
      toggleButton.isHidden = false
    } else {
      toggleButton.isHidden = true
    }
  }
}

// MARK: - Private Helpers
extension SearchDestinationTitleCell {
  private func setupContentCompressionResistancePriorities() {
//    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    addressLabel.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
  }
  
  private func setupStyles() {
    contentView.layer.cornerRadius = 20
    contentView.backgroundColor = .black.withAlphaComponent(0.1)
  }
}

// MARK: - Actions
private extension SearchDestinationTitleCell {
  @objc func didTapToggleButton(_ button: UIButton) {
    print("주소 자세히 보기!")
  }
  
  @objc func didTapCopyAddressButton(_ button: UIButton) {
    print("복사 버튼 클릭")
  }
  
  @objc func didTapHeartButton(_ button: UIButton) {
    // TODO: - 서버로부터 받은 결과에 따라 update해야 합니다.
    heartButton.isSelected.toggle()
    print("버튼클릭")
  }
}

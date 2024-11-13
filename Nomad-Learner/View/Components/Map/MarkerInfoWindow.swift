//
//  MarkerInfoWindow.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/18.
//

import UIKit
import GoogleMaps
import RxSwift

class MarkerInfoWindow: UIView {
    
    //　ロケーション画像
    private lazy var locationImageView = UIImageView().then {
        $0.layer.cornerRadius = (self.viewHeight - UIConstants.Layout.semiStandardPadding) / 2
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    // 目的地labelと地域・国labelをまとめる
    private lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.addArrangedSubview(self.destinationLabel)
        $0.addArrangedSubview(self.regionLabel)
    }
    
    // 目的地label
    private let destinationLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: UIConstants.TextSize.semiMedium)
        // フォントサイズ自動調整
        $0.adjustsFontSizeToFitWidth = true
    }
    
    // 地域・国label
    private let regionLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: UIConstants.TextSize.extraSmall)
        // フォントサイズ自動調整
        $0.adjustsFontSizeToFitWidth = true
    }
    
    init(frame: CGRect, fixedLocation: FixedLocation) {
        super.init(frame: frame)
        
        setupUI()
        configure(fixedLocation: fixedLocation)
    }
   
    private func setupUI() {
        backgroundColor = ColorCodes.primaryPurple.color()
        layer.cornerRadius = self.bounds.height / 2
        
        addSubview(locationImageView)
        addSubview(stackView)
        
        locationImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(UIConstants.Layout.semiStandardPadding / 2)
            $0.size.equalTo(CGSize(width: 80, height: self.viewHeight - UIConstants.Layout.semiStandardPadding))
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(locationImageView.snp.right).offset(UIConstants.Layout.smallPadding)
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
    }
    
    // windowにロケーション情報を表示
    private func configure(fixedLocation: FixedLocation)  {
        locationImageView.setImage(with: fixedLocation.imageUrlsArr[0])
        destinationLabel.text = fixedLocation.location
        regionLabel.text = "\(fixedLocation.country) / \(fixedLocation.region)"
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

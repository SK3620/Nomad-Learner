//
//  ProfileTopView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import Foundation
import UIKit

class ProfileTopView: UIView {
    
    var userProfile: User
    
    // プロフィール画像の大きさ
    public let pictureSize: CGFloat = 80
    
    // プロフィール画像の外枠
    private lazy var pictureOutsideView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = self.pictureSize / 2
    }
    
    // プロフィール画像
    private lazy var pictureImageView = UIImageView().then {
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.backgroundColor = UIColor(white: 0.85, alpha: 1)
        $0.layer.borderColor = ColorCodes.primaryPurple.color().cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = (self.pictureSize - UIConstants.Layout.semiStandardPadding) / 2
        $0.layer.masksToBounds = true
    }
    
    private let weeklyStudyTimeTitle: ProfileLabel = ProfileLabel(text: "weekly", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color(), isRounded: true)
    
    private let weeklyStudyTime: ProfileLabel = ProfileLabel(text: "4時間30分", fontSize: UIConstants.TextSize.medium, textColor: .white)
    
    private let totalStudyTimeTitle: ProfileLabel = ProfileLabel(text: "total", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color(), isRounded: true)
    
    private let totalStudyTime: ProfileLabel = ProfileLabel(text: "35時間48分", fontSize: UIConstants.TextSize.medium, textColor: .white)
        
    private lazy var weeklyStudyTimeStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = UIConstants.Layout.smallPadding
    }
    
    private lazy var totalStudyTimeStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = UIConstants.Layout.smallPadding
    }
    
    // weeklyStudyTimeStackViewとtotalStudyTimeStackViewをまとめる
    private lazy var studyTimeSummaryStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    // 訪れた国の数のタイトル
    private let visitedCountriesTitle: ProfileLabel = ProfileLabel(text: "Visited Countries", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color())
    
    // 訪れた国の数
    private let visitedCountries: ProfileLabel = ProfileLabel(text: "23", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
    init(userProfile: User) {
        self.userProfile = userProfile
        
        super.init(frame: .zero)
        self.backgroundColor = ColorCodes.primaryPurple.color()
        
        setupUI()
        update(with: userProfile)
    }
    
    private func setupUI() {
        weeklyStudyTimeStackView.addArrangedSubview(weeklyStudyTimeTitle)
        weeklyStudyTimeStackView.addArrangedSubview(weeklyStudyTime)
        totalStudyTimeStackView.addArrangedSubview(totalStudyTimeTitle)
        totalStudyTimeStackView.addArrangedSubview(totalStudyTime)
        
        studyTimeSummaryStackView.addArrangedSubview(weeklyStudyTimeStackView)
        studyTimeSummaryStackView.addArrangedSubview(totalStudyTimeStackView)
        
        addSubview(pictureOutsideView)
        addSubview(pictureImageView)
        addSubview(studyTimeSummaryStackView)
        addSubview(visitedCountriesTitle)
        addSubview(visitedCountries)
        
        pictureOutsideView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.size.equalTo(pictureSize)
            $0.centerY.equalTo(self.snp.bottom)
        }
        
        pictureImageView.snp.makeConstraints {
            $0.center.equalTo(pictureOutsideView)
            $0.size.equalTo(pictureSize - UIConstants.Layout.semiStandardPadding)
        }
        
        studyTimeSummaryStackView.snp.makeConstraints {
            $0.left.equalTo(pictureOutsideView.snp.right).inset(-(UIConstants.Layout.smallPadding))
            $0.right.equalToSuperview().inset(UIConstants.Layout.smallPadding)
            $0.centerY.equalToSuperview()
        }
        
        visitedCountriesTitle.snp.makeConstraints {
            $0.left.equalTo(pictureOutsideView.snp.right).inset(-(UIConstants.Layout.standardPadding))
            $0.top.equalTo(self.snp.bottom).inset(-(UIConstants.Layout.smallPadding))
        }
        
        visitedCountries.snp.makeConstraints {
            $0.centerY.equalTo(visitedCountriesTitle)
            $0.left.equalTo(visitedCountriesTitle.snp.right).inset(-(UIConstants.Layout.standardPadding))
        }
    }
    
    // ユーザープロフィール情報を受け取り、UI更新
    private func update(with userProfile: User) {
        if userProfile.profileImageUrl.isEmpty {
            pictureImageView.image = UIImage(named: "Globe") // 空の場合はデフォルト画像
        } else {
            pictureImageView.setImage(with: userProfile.profileImageUrl)
        }
        weeklyStudyTime.text = userProfile.weeklyTime.toString
        totalStudyTime.text = userProfile.totalTime.toString
        visitedCountries.text = userProfile.visitedCountries.toString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Int {
    var toString: String {
        return String(self)
    }
}

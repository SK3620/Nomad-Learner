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
    
    // 今日の勉強時間タイトル
    private let todayStudyTimeTitle = ProfileLabel(text: "today", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color(), isRounded: true)
    
    // 今日の勉強時間
    private let todayStudyTime = ProfileLabel(text: "00:00", fontSize: UIConstants.TextSize.medium, textColor: .white)
    
    // 一週間の勉強時間タイトル
    private let weeklyStudyTimeTitle = ProfileLabel(text: "weekly", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color(), isRounded: true)
    
    // 一週間の勉強時間
    private let weeklyStudyTime = ProfileLabel(text: "00:00", fontSize: UIConstants.TextSize.medium, textColor: .white)
    
    // 合計勉強時間タイトル
    private let totalStudyTimeTitle = ProfileLabel(text: "total", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color(), isRounded: true)
    
    // 合計勉強時間
    private let totalStudyTime = ProfileLabel(text: "00:00", fontSize: UIConstants.TextSize.medium, textColor: .white)
    
    // 今日の勉強時間のスタックビュー
    private lazy var todayStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todayStudyTimeTitle, todayStudyTime])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    // 一週間の勉強時間のスタックビュー
    private lazy var weeklyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weeklyStudyTimeTitle, weeklyStudyTime])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    // 合計勉強時間のスタックビュー
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalStudyTimeTitle, totalStudyTime])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    // 今日、一週間、合計のスタックビューを並べる横方向のスタックビュー
    private lazy var studyTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todayStackView, weeklyStackView, totalStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //　訪問したロケーション数 背景View
    private let backgroundViewForAirplane = UIView().then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = 28 / 2
    }
    
    // 訪問したロケーション数 飛行機アイコン
    private let airplaneImageView = UIImageView().then {
        $0.tintColor = .white
        $0.image = UIImage(systemName: "airplane")
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 270 / 360)
    }
    
    // 訪問したロケーション数
    private let visitedLocationsLabel = ProfileLabel(text: "00", fontSize: UIConstants.TextSize.medium, textColor: ColorCodes.primaryPurple.color())
    
    // 全ロケーション数
    private let allLocationsLabel = ProfileLabel(text: " / 00", fontSize: UIConstants.TextSize.semiMedium, textColor: ColorCodes.primaryPurple.color())
    
    //　完了マークアイコン背景View
    private let backgroundViewForCompleted = UIView().then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = 28 / 2
    }
    
    // 完了マークアイコン
    private let completedImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        $0.image = UIImage(systemName: "checkmark", withConfiguration: configuration)
        $0.tintColor = .white
    }
    
    // クリアしたロケーション数
    private let completedLocationsLabel = ProfileLabel(text: "00", fontSize: UIConstants.TextSize.medium, textColor: ColorCodes.primaryPurple.color())
    
    init(userProfile: User) {
        self.userProfile = userProfile
        
        super.init(frame: .zero)
        self.backgroundColor = ColorCodes.primaryPurple.color()
        
        setupUI()
        update(with: userProfile)
    }
    
    private func setupUI() {
        
        addSubview(pictureOutsideView)
        addSubview(pictureImageView)
        
        addSubview(studyTimeStackView)
        
        backgroundViewForAirplane.addSubview(airplaneImageView)
        addSubview(backgroundViewForAirplane)
        addSubview(visitedLocationsLabel)
        addSubview(allLocationsLabel)
        
        backgroundViewForCompleted.addSubview(completedImageView)
        addSubview(backgroundViewForCompleted)
        addSubview(completedLocationsLabel)
        
        pictureOutsideView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.size.equalTo(pictureSize)
            $0.centerY.equalTo(self.snp.bottom)
        }
        
        pictureImageView.snp.makeConstraints {
            $0.center.equalTo(pictureOutsideView)
            $0.size.equalTo(pictureSize - UIConstants.Layout.semiStandardPadding)
        }
        
        studyTimeStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(pictureImageView.snp.right).offset(12)
            $0.right.equalToSuperview().inset(12)
        }
        
        backgroundViewForAirplane.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.bottom.equalTo(pictureImageView.snp.bottom)
            $0.left.equalTo(todayStudyTimeTitle)
        }
        
        airplaneImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        visitedLocationsLabel.snp.makeConstraints {
            $0.centerY.equalTo(backgroundViewForAirplane)
            $0.left.equalTo(backgroundViewForAirplane.snp.right).offset(8)
        }
        
        allLocationsLabel.snp.makeConstraints {
            $0.bottom.equalTo(visitedLocationsLabel)
            $0.left.equalTo(visitedLocationsLabel.snp.right)
        }
        
        backgroundViewForCompleted.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.centerY.equalTo(backgroundViewForAirplane)
            $0.left.equalTo(allLocationsLabel.snp.right).offset(24)
        }
        
        completedImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        completedLocationsLabel.snp.makeConstraints {
            $0.centerY.equalTo(backgroundViewForCompleted)
            $0.left.equalTo(backgroundViewForCompleted.snp.right).offset(8)
        }
    }
    
    // ユーザープロフィール情報を受け取り、UI更新
    private func update(with userProfile: User) {
        if userProfile.profileImageUrl.isEmpty {
            pictureImageView.image = UIImage(named: "Globe") // 空の場合はデフォルト画像
        } else {
            pictureImageView.setImage(with: userProfile.profileImageUrl)
        }
        totalStudyTime.text = "\(userProfile.progressSum?.totalStudyHours ?? 00):\(userProfile.progressSum?.totalStudyMins ?? 00)"
        visitedLocationsLabel.text = userProfile.progressSum?.visitedLocationsCount.toString
        allLocationsLabel.text =  " / \(userProfile.progressSum?.allLocationsCount ?? 00)"
        completedLocationsLabel.text = userProfile.progressSum?.completedLocationsCount.toString
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

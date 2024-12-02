//
//  LocationDetailView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/06.
//

import Foundation
import UIKit
import Then
import SnapKit

class LocationDetailView: UIView {
    // 距離アイコンとコインアイコンをまとめる背景View
    private let distanceAndCoinBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 距離のアイコン
    private let distanceImageView = UIImageView().then {
        $0.image = UIImage(named: "TravelDistanceAndCost")
        $0.layer.masksToBounds = true
    }
    
    // 距離アイコンとコインアイコンの区切り線
    private let IconImageDivider = UIView().then {
        $0.backgroundColor = .black
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2.5)
        $0.layer.masksToBounds = true
    }
    
    // コインのアイコン
    private let coinImageView = UIImageView().then {
        $0.image = UIImage(named: "Coin")
        $0.layer.masksToBounds = true
    }
    
    // 距離とコインの値
    private let distanceAndCoinValueLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 23)
        $0.textAlignment = .center
        $0.text = "0"
    }
    
    // ミッションアイコン背景View
    private let backgroundViewForMission = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // ミッションのアイコン
    private let missionImageView = UIImageView(image: UIImage(named: "Study"))
    
    // 合計勉強時間
    private let totalStudyTimeLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 23)
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "00:00"
    }
    
    // スラッシュ線
    private let slashView = UIView().then {
        $0.backgroundColor = .gray
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 15 / 360)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1.5, height: 30))
        }
    }
    
    // 必要な勉強時間
    private let requiredStudyHours = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .right
        $0.text = "0"
    }
    
    // "hours"テキスト
    private let hoursTextLabel = UILabel().then {
        $0.text = "時間"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    // 「/ hours XX」を表示するstackView
    private lazy var requiredStudyHoursStackView: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [requiredStudyHours, hoursTextLabel])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        
        let horizontalStackView = UIStackView(arrangedSubviews: [slashView, verticalStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        return horizontalStackView
    }()
    
    // 報酬アイコン背景View
    private let backgroundViewForReward = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 報酬のアイコン
    private let rewardImageView = UIImageView(image: UIImage(named: "Reward"))
    
    // 報酬label
    private let rewardCoinLabel = UILabel().then {
        $0.text = "0＋"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 23)
    }
    
    // スラッシュ線2
    private let slashView2 = UIView().then {
        $0.backgroundColor = .gray
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 15 / 360)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1.5, height: 15))
        }
    }
    
    // ボーナスタイトルlabel（達成後に表示）
    private let bonusTitleLabel = UILabel().then {
        $0.text = "1時間毎"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 13)
    }
    
    private lazy var bonusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slashView2, bonusTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.isHidden = true
        return stackView
    }()
    
    // 縦の区切り線
    private let verticalDivider = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // 横の区切り線
    private let horizontalDivider = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // セクション選択colloectionView
    let locationCategoryCollectionView: LocationCategoryCollectionView = LocationCategoryCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        applyShadow(color: .black, opacity: 0.6, offset: CGSize(width: 0.5, height: 4), radius: 5)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubview(distanceAndCoinBackgroundView)
        distanceAndCoinBackgroundView.addSubview(distanceImageView)
        distanceAndCoinBackgroundView.addSubview(IconImageDivider)
        distanceAndCoinBackgroundView.addSubview(coinImageView)
        addSubview(distanceAndCoinValueLabel)
        
        addSubview(verticalDivider)
        addSubview(horizontalDivider)
        
        backgroundViewForMission.addSubview(missionImageView)
        addSubview(backgroundViewForMission)
        addSubview(totalStudyTimeLabel)
        addSubview(requiredStudyHoursStackView)
        backgroundViewForReward.addSubview(rewardImageView)
        addSubview(backgroundViewForReward)
        addSubview(rewardCoinLabel)
        addSubview(bonusStackView)
        
        addSubview(locationCategoryCollectionView)
        
        // 距離アイコンとコインアイコンをまとめる背景View
        distanceAndCoinBackgroundView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(12)
            $0.height.equalTo(35)
            $0.right.equalTo(coinImageView).offset(8)
        }
        
        // 距離アイコン
        distanceImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 45))
            $0.left.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        // 距離アイコンとコインアイコンの区切り線
        IconImageDivider.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 1))
            $0.left.equalTo(distanceImageView.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        // コインアイコン
        coinImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
            $0.left.equalTo(IconImageDivider.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        // 距離とコインの値
        distanceAndCoinValueLabel.snp.makeConstraints {
            $0.centerX.equalTo(distanceAndCoinBackgroundView)
            $0.centerY.equalTo(rewardCoinLabel)
        }
        
        // 縦の区切り線
        verticalDivider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.left.equalTo(distanceAndCoinBackgroundView.snp.right).inset(-16)
            $0.top.equalTo(distanceAndCoinBackgroundView)
            $0.bottom.equalTo(backgroundViewForReward)
        }
        
        // 横の区切り線
        horizontalDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // ミッションアイコン背景View
        backgroundViewForMission.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.left.equalTo(verticalDivider.snp.right).inset(-16)
            $0.centerY.equalTo(distanceAndCoinBackgroundView)
        }
        
        // ミッションアイコン
        missionImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 合計勉強時間
        totalStudyTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(missionImageView)
            $0.left.equalTo(backgroundViewForMission.snp.right).offset(12)
        }
        
        // 「/ hours XX」を表示するstackView
        requiredStudyHoursStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(totalStudyTimeLabel)
        }
        
        // 報酬アイコン背景View
        backgroundViewForReward.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.top.equalTo(backgroundViewForMission.snp.bottom).offset(6)
            $0.left.equalTo(backgroundViewForMission)
        }
        
        // 報酬アイコン
        rewardImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 報酬label
        rewardCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backgroundViewForReward)
            $0.left.equalTo(backgroundViewForReward.snp.right).offset(12)
        }
        
        // ボーナスタイトルlabel
        bonusStackView.snp.makeConstraints {
            $0.centerY.equalTo(rewardCoinLabel)
            $0.right.equalToSuperview().inset(16)
        }
        
        // セクション選択collectionView
        locationCategoryCollectionView.snp.makeConstraints {
            $0.right.left.bottom.equalToSuperview()
            $0.top.equalTo(horizontalDivider.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailView {
    // 各UIを更新
    func update(ticketInfo: TicketInfo, locationStatus: LocationStatus) {
        let isCompleted = locationStatus.isCompleted
        let completedColor = ColorCodes.completedGreen.color()
        
        // ラベルの色設定
        let labelColor = isCompleted ? completedColor : .black
        totalStudyTimeLabel.textColor = labelColor
        rewardCoinLabel.textColor = labelColor
        
        // ボーナス表示
        bonusStackView.isHidden = !isCompleted
        
        // テキストの更新
        distanceAndCoinValueLabel.text = ticketInfo.travelDistanceAndCost.toString
        totalStudyTimeLabel.text = Int.toTimeFormat(hours: ticketInfo.totalStudyHours, mins: ticketInfo.totalStudyMins)
        requiredStudyHours.text = ticketInfo.requiredStudyHours.toString
        
        // 報酬コインラベルの更新
        rewardCoinLabel.text = isCompleted ? "\(MyAppSettings.bonusCoinMultiplier)＋" : "\(ticketInfo.rewardCoin.toString)＋"
    }
}

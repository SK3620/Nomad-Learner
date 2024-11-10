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
    private let distanceAndCoinBackgroundView: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 距離のアイコン
    private lazy var distanceImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "distance")
        $0.layer.masksToBounds = true
    }
    
    // 距離アイコンとコインアイコンの区切り線
    private lazy var IconImageDivider: UIView = UIView().then {
        $0.backgroundColor = .black
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2.5)
        $0.layer.masksToBounds = true
    }
    
    // コインのアイコン
    private lazy var coinImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "coin")
        $0.layer.masksToBounds = true
    }
    
    // 距離とコインの値
    private lazy var distanceAndCoinValueLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiSuperLarge)
        $0.textAlignment = .center
    }
    
    // ミッションアイコン背景View
    private let backgroundViewForMission: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // ミッションのアイコン
    private let missionImageView: UIImageView = UIImageView(image: UIImage(named: "Study2"))
    
    // 合計勉強時間
    private let totalStudyTimeLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiSuperLarge)
    }
    
    // スラッシュ線
    private let slashView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 15 / 360)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 2, height: 30))
        }
    }
    
    // 必要な勉強時間
    private let requiredStudyHours: UILabel = UILabel().then {
        $0.textColor = .orange
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiMedium)
        $0.textAlignment = .right
    }
    
    // "hours"テキスト
    private let hoursTextLabel = UILabel().then {
        $0.text = "hours"
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiMedium)
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
    private let backgroundViewForReward: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 報酬のアイコン
    private let rewardImageView: UIImageView = UIImageView(image: UIImage(named: "Reward"))
    
    // 報酬label
    private let rewardCoinLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiSuperLarge)
        $0.text = "22500＋"
    }
    
    // 縦の区切り線
    private lazy var verticalDivider: UIView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // 横の区切り線
    private lazy var horizontalDivider: UIView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // セクション選択colloectionView
    lazy var locationCategoryCollectionView: LocationCategoryCollectionView = LocationCategoryCollectionView()
    
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
        
        addSubview(locationCategoryCollectionView)
        
        // 距離アイコンとコインアイコンをまとめる背景View
        distanceAndCoinBackgroundView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(UIConstants.Layout.semiStandardPadding)
            $0.height.equalTo(35)
            $0.right.equalTo(coinImageView).offset(UIConstants.Layout.smallPadding)
        }
        
        // 距離アイコン
        distanceImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 25))
            $0.left.equalToSuperview().inset(UIConstants.Layout.smallPadding)
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
            $0.size.equalTo(distanceImageView.snp.height)
            $0.left.equalTo(IconImageDivider.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        // 距離とコインの値
        distanceAndCoinValueLabel.snp.makeConstraints {
            $0.centerX.equalTo(distanceAndCoinBackgroundView)
            $0.bottom.equalTo(rewardCoinLabel.snp.bottom)
        }
        
        // 縦の区切り線
        verticalDivider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.left.equalTo(distanceAndCoinBackgroundView.snp.right).inset(-UIConstants.Layout.standardPadding)
            $0.top.equalTo(distanceAndCoinBackgroundView)
            $0.bottom.equalTo(backgroundViewForReward)
        }
        
        // 横の区切り線
        horizontalDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            // $0.top.equalTo(backgroundViewForReward.snp.bottom).offset(UIConstants.Layout.smallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        // ミッションアイコン背景View
        backgroundViewForMission.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.left.equalTo(verticalDivider.snp.right).inset(-UIConstants.Layout.standardPadding)
            $0.centerY.equalTo(distanceAndCoinBackgroundView)
        }
        
        // ミッションアイコン
        missionImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 合計勉強時間
        totalStudyTimeLabel.snp.makeConstraints {
            $0.bottom.equalTo(backgroundViewForMission)
            $0.left.equalTo(backgroundViewForMission.snp.right).offset(UIConstants.Layout.semiStandardPadding)
        }
        
        // 「/ hours XX」を表示するstackView
        requiredStudyHoursStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.centerY.equalTo(totalStudyTimeLabel)
        }
        
        // 報酬アイコン背景View
        backgroundViewForReward.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.top.equalTo(backgroundViewForMission.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.left.equalTo(backgroundViewForMission)
        }
        
        // 報酬アイコン
        rewardImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 報酬label
        rewardCoinLabel.snp.makeConstraints {
            $0.bottom.equalTo(backgroundViewForReward)
            $0.left.equalTo(backgroundViewForReward.snp.right).offset(UIConstants.Layout.semiStandardPadding)
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
        distanceAndCoinValueLabel.text = ticketInfo.travelDistanceAndCost.toString
        totalStudyTimeLabel.text = Int.toTimeFormat(hours: ticketInfo.totalStudyHours, mins: ticketInfo.totalStudyMins)
        requiredStudyHours.text = ticketInfo.requiredStudyHours.toString
        rewardCoinLabel.text = "\(ticketInfo.rewardCoin.toString)＋"
        
        let isCompleted = locationStatus.isCompleted
        let completedColor = ColorCodes.completedGreen.color()
        totalStudyTimeLabel.textColor = isCompleted ? completedColor : .black
        rewardCoinLabel.textColor = isCompleted ? completedColor : .black
    }
}

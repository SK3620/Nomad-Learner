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
        $0.text = "20500"
        $0.textAlignment = .center
    }
    
    // ミッションアイコン背景View
    private let backgroundViewForMission: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // ミッションのアイコン
    private let missionImageView: UIImageView = UIImageView(image: UIImage(named: "Study2"))
    
    // ミッションlabel
    private let missionLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiSuperLarge)
        $0.text = "21 "
    }
    
    // ミッションサブlabel
    private let missionSubLabel: UILabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiMedium)
        $0.text = "/ 30 hours"
        $0.textAlignment = .right
    }
    
    // 報酬アイコン背景View
    private let backgroundViewForReward: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 報酬のアイコン
    private let rewardImageView: UIImageView = UIImageView(image: UIImage(named: "Reward"))
    
    // 報酬label
    private let rewardLabel: UILabel = UILabel().then {
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
        addSubview(missionLabel)
        addSubview(missionSubLabel)
        backgroundViewForReward.addSubview(rewardImageView)
        addSubview(backgroundViewForReward)
        addSubview(rewardLabel)
        
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
            $0.bottom.equalTo(rewardLabel.snp.bottom)
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
        
        // ミッションlabel
        missionLabel.snp.makeConstraints {
            $0.bottom.equalTo(backgroundViewForMission)
            $0.left.equalTo(backgroundViewForMission.snp.right).offset(UIConstants.Layout.semiStandardPadding)
        }
        
        // ミッションサブlabel
        missionSubLabel.snp.makeConstraints {
            $0.left.equalTo(missionLabel.snp.right)
            $0.bottom.equalTo(missionLabel).inset(3) // 微調整
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
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
        rewardLabel.snp.makeConstraints {
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
    func update(ticketInfo: TicketInfo) {
        distanceAndCoinValueLabel.text = ticketInfo.travelDistanceAndCost.toString
        missionLabel.text = "\(ticketInfo.totalStudyHours.toString)：\(ticketInfo.totalStudyMins.toString)"
        missionSubLabel.text = "/ \(ticketInfo.requiredStudyHours.toString) hours"
        rewardLabel.text = "\(ticketInfo.rewardCoin.toString)＋"
    }
}

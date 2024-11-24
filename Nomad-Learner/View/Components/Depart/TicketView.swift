//
//  TicketView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/12.
//

import UIKit
import SnapKit
import Then

class TicketView: UIView {
    
    // ダッシュ線のX座標
    private let dashPointX: CGFloat = 80
    // ダッシュ線の幅
    private let dashWidth: CGFloat = 8
    
    // 現在地の国旗と目的地の国旗をまとめる背景View
    private lazy var nationalFlagBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = (self.dashPointX - 16 * 2) / 2
    }
    
    // 現在地の国旗
    private let currentNationalFlag = UIImageView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 44 / 2
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
    }
    
    // 目的地の国旗
    private let destinationNationalFlag = UIImageView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 44 / 2
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
    }
    
    // 矢印画像
    private let arrowImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(pointSize: 32)
        $0.image = UIImage(systemName: "arrowshape.up.fill", withConfiguration: configuration)
        $0.tintColor = UIColor(red: 220/255, green: 194/255, blue: 177/255, alpha: 1)
    }
    
    // 距離アイコンとコインアイコンをまとめる背景View
    private let backgroundViewForDistanceAndCoin = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 距離のアイコン
    private let distanceImageView = UIImageView().then {
        $0.image = UIImage(named: "distance")
    }
    
    // 距離アイコンとコインアイコンの区切り線
    private let IconImageDivider = UIView().then {
        $0.backgroundColor = .black
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2.5)
    }
    
    // コインのアイコン
    private let coinImageView = UIImageView().then {
        $0.image = UIImage(named: "coin")
    }
    
    // 距離と旅費（距離==旅費）
    private let travelDistanceAndCost = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 23)
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    // 距離とコインの下線
    private let travelDistanceAndCostUnderline = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
    }
    
    // 目的地label
    private let destinationLabel = UILabel().then {
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.numberOfLines = 2
        $0.text = "The Great Barrier Reef"
        $0.textAlignment = .center
    }
    
    // 地域・国label
    private let countryAndRegion = UILabel().then {
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 2
        $0.text = "United Kingdom / South West England"
        $0.textAlignment = .center
    }
    
    // ミッションアイコン背景View
    private let backgroundViewForMission = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // ミッションのアイコン
    private let missionImageView = UIImageView(image: UIImage(named: "Study2"))
    
    // 合計勉強時間
    private let totalStudyTimeLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 23)
    }
   
    // スラッシュ線
    private let slashView = UIView().then {
        $0.backgroundColor = .gray
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 15 / 360)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1.5, height: 27))
        }
    }
    
    // 必要な勉強時間
    private let requiredStudyHours = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .right
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
        verticalStackView.distribution = .fillProportionally
        
        let horizontalStackView = UIStackView(arrangedSubviews: [slashView, verticalStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        return horizontalStackView
    }()
    // ミッション下線
    private let missionUnderline = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
    }
    
    // 報酬アイコン背景View
    private let backgroundViewForReward = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 報酬のアイコン
    private let rewardImageView = UIImageView(image: UIImage(named: "Reward"))
    
    // 報酬label
    private let rewardCoinLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 23)
        $0.textAlignment = .left
    }
    
    // スラッシュ線2
    private let slashView2 = UIView().then {
        $0.backgroundColor = .darkGray
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 15 / 360)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 2, height: 15))
        }
    }
    
    // ボーナスタイトルlabel（達成後に表示）
    private let bonusTitleLabel = UILabel().then {
        $0.text = "1時間ごと"
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var bonusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slashView2, bonusTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.isHidden = true
        return stackView
    }()
    
    // 報酬の下線
    private let rewardUnderline = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // チケットの枠を設定
    private func setupUI() {
        self.backgroundColor = UIColor(red: 220/255, green: 194/255, blue: 177/255, alpha: 1)
        self.layer.cornerRadius = 32
        self.clipsToBounds = true
        
        addSubview(nationalFlagBackgroundView)
        addSubview(currentNationalFlag)
        addSubview(destinationNationalFlag)
        addSubview(arrowImageView)
        
        backgroundViewForDistanceAndCoin.addSubview(distanceImageView)
        backgroundViewForDistanceAndCoin.addSubview(IconImageDivider)
        backgroundViewForDistanceAndCoin.addSubview(coinImageView)
        addSubview(backgroundViewForDistanceAndCoin)
        addSubview(travelDistanceAndCost)
        addSubview(travelDistanceAndCostUnderline)
        
        addSubview(destinationLabel)
        addSubview(countryAndRegion)
        
        backgroundViewForMission.addSubview(missionImageView)
        addSubview(backgroundViewForMission)
        addSubview(totalStudyTimeLabel)
        addSubview(requiredStudyHoursStackView)
        addSubview(missionUnderline)
        backgroundViewForReward.addSubview(rewardImageView)
        addSubview(backgroundViewForReward)
        addSubview(rewardCoinLabel)
        addSubview(bonusStackView)
        addSubview(rewardUnderline)
        
        // 現在地の国旗と目的地の国旗をまとめる背景View
        nationalFlagBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(dashPointX / 2)
            $0.verticalEdges.equalToSuperview().inset(50)
            $0.width.equalTo(dashPointX - 16 * 2)
        }
        
        // 現在地の国旗
        currentNationalFlag.snp.makeConstraints {
            $0.centerX.equalTo(nationalFlagBackgroundView)
            $0.centerY.equalTo(nationalFlagBackgroundView.snp.bottom)
            $0.size.equalTo(44)
        }
        
        // 目的地の国旗
        destinationNationalFlag.snp.makeConstraints {
            $0.centerX.equalTo(nationalFlagBackgroundView)
            $0.centerY.equalTo(nationalFlagBackgroundView.snp.top)
            $0.size.equalTo(44)
        }
        
        // 上向の矢印
        arrowImageView.snp.makeConstraints {
            $0.center.equalTo(nationalFlagBackgroundView)
        }
        
        // 距離アイコンとコインアイコンをまとめる背景View
        backgroundViewForDistanceAndCoin.snp.makeConstraints {
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + 16)
            $0.right.equalTo(coinImageView).offset(8)
            $0.height.equalTo(35)
            $0.top.equalToSuperview().inset(12)
        }
        
        // 距離アイコン
        distanceImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 25))
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
            $0.size.equalTo(distanceImageView.snp.height)
            $0.left.equalTo(IconImageDivider.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        // 距離とコインの値
        travelDistanceAndCost.snp.makeConstraints {
            $0.left.equalTo(backgroundViewForDistanceAndCoin.snp.right).offset(16)
            $0.centerY.equalTo(distanceImageView)
            $0.right.equalToSuperview().inset(20)
        }
        
        // 距離＆旅費とアイコンの下線
        travelDistanceAndCostUnderline.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.bottom.equalTo(backgroundViewForDistanceAndCoin)
            $0.left.equalTo(backgroundViewForDistanceAndCoin.snp.centerX)
            $0.right.equalTo(travelDistanceAndCost)
        }
        
        // 目的地label
        destinationLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundViewForDistanceAndCoin.snp.bottom).inset(-16)
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + 16)
            $0.right.equalToSuperview().inset(8)
        }
        
        // 地域・国label
        countryAndRegion.snp.makeConstraints {
            $0.top.equalTo(destinationLabel.snp.bottom)
            $0.right.left.equalTo(destinationLabel)
            $0.bottom.equalTo(backgroundViewForMission.snp.top).inset(-15)
        }
        
        // ミッションアイコン背景View
        backgroundViewForMission.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + 16)
            $0.bottom.equalTo(backgroundViewForReward.snp.top).offset(-12)
        }
        
        // ミッションアイコン
        missionImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 合計勉強時間
        totalStudyTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(backgroundViewForMission)
            $0.left.equalTo(backgroundViewForMission.snp.right).offset(16)
        }
        
        // 必要な勉強時間
        requiredStudyHoursStackView.snp.makeConstraints {
            $0.bottom.equalTo(totalStudyTimeLabel)
            $0.right.equalToSuperview().inset(20)
        }
        
        // ミッションの下線
        missionUnderline.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.bottom.equalTo(backgroundViewForMission)
            $0.left.equalTo(backgroundViewForMission.snp.centerX)
            $0.right.equalTo(requiredStudyHoursStackView)
        }
        
        // 報酬アイコン背景View
        backgroundViewForReward.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + 16)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        // 報酬アイコン
        rewardImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 報酬label
        rewardCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(rewardImageView)
            $0.left.equalTo(backgroundViewForReward.snp.right).offset(16)
            $0.right.equalToSuperview().inset(20)
        }
        
        // ボーナスタイトルlabel
        bonusStackView.snp.makeConstraints {
            $0.centerY.equalTo(rewardCoinLabel)
            $0.right.equalToSuperview().inset(20)
        }
        
        // ミッションの下線
        rewardUnderline.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.bottom.equalTo(backgroundViewForReward)
            $0.left.equalTo(backgroundViewForReward.snp.centerX)
            $0.right.equalTo(rewardCoinLabel)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // チケットのダッシュ線を描く
        draw(rect: rect)
    }
}

extension TicketView {
    // 各UIを更新
    func update(with ticketInfo: TicketInfo, locationStatus: LocationStatus) {
        // 基本情報の更新
        travelDistanceAndCost.text = ticketInfo.travelDistanceAndCost.toString
        destinationLabel.text = ticketInfo.destination
        countryAndRegion.text = ticketInfo.countryAndRegion
        totalStudyTimeLabel.text = Int.toTimeFormat(hours: ticketInfo.totalStudyHours, mins: ticketInfo.totalStudyMins)
        requiredStudyHours.text = ticketInfo.requiredStudyHours.toString
        
        // 国旗画像をセット
        currentNationalFlag.setImage(with: ticketInfo.nationalFlagImageUrlString.current)
        destinationNationalFlag.setImage(with: ticketInfo.nationalFlagImageUrlString.destination)
        
        // 達成状況に応じた色設定とボーナス表示
        let completedColor = ColorCodes.completedGreen.color()
        let labelColor = locationStatus.isCompleted ? completedColor : .black
        totalStudyTimeLabel.textColor = labelColor
        rewardCoinLabel.textColor = labelColor
        bonusStackView.isHidden = !locationStatus.isCompleted
        
        // 報酬コインラベルの更新
        rewardCoinLabel.text = locationStatus.isCompleted ? "\(MyAppSettings.bonusCoinMultiplier)＋" : "\(ticketInfo.rewardCoin.toString)＋"
    }
}

extension TicketView {
    // チケットのダッシュ線を描く
    private func draw(rect: CGRect) {
        // ダッシュ線の描画
        let dashWidth: CGFloat = dashWidth   // 楕円の幅
        let dashHeight: CGFloat = 12.0 // 楕円の高さ
        let dashSpacing: CGFloat = 8.0 // 楕円同士の間隔
        
        // ダッシュの数 + 1（最下辺まで表示させる）
        let numberOfDashes = Int(rect.height / (dashHeight + dashSpacing) + 1)
        
        for i in 0..<numberOfDashes {
            let yPosition = CGFloat(i) * (dashHeight + dashSpacing)
            
            let dashRect = CGRect(x: dashPointX, // X位置を中央に調整
                                  y: yPosition,
                                  width: dashWidth,
                                  height: dashHeight)
            
            let dashPath = UIBezierPath(roundedRect: dashRect, cornerRadius: dashWidth / 2)
            UIColor.white.setFill()
            dashPath.fill()
        }
    }
}

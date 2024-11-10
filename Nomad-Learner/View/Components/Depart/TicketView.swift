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
    private lazy var nationalFlagBackgroundView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = (self.dashPointX - UIConstants.Layout.standardPadding * 2) / 2
    }
    
    // 現在地の国旗
    private let currentNationalFlag: UIImageView = UIImageView().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.backgroundColor = UIColor.blue
        $0.layer.cornerRadius = 44 / 2
    }
    
    // 目的地の国旗
    private let destinationNationalFlag: UIImageView = UIImageView().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.green.cgColor
        $0.backgroundColor = UIColor.green
        $0.layer.cornerRadius = 44 / 2
    }
    
    // 矢印画像
    private let arrowImageView: UIImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(pointSize: 32)
        $0.image = UIImage(systemName: "arrowshape.up.fill", withConfiguration: configuration)
        $0.tintColor = UIColor(red: 220/255, green: 194/255, blue: 177/255, alpha: 1)
    }
    
    // 距離アイコンとコインアイコンをまとめる背景View
    private let backgroundViewForDistanceAndCoin: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // 距離のアイコン
    private lazy var distanceImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "distance")
    }
    
    // 距離アイコンとコインアイコンの区切り線
    private lazy var IconImageDivider: UIView = UIView().then {
        $0.backgroundColor = .black
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2.5)
    }
    
    // コインのアイコン
    private lazy var coinImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "coin")
    }
    
    // 距離と旅費（距離==旅費）
    private lazy var travelDistanceAndCost: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiSuperLarge)
        $0.text = "21600"
        $0.textAlignment = .left
    }
    
    // 距離とコインの下線
    private let travelDistanceAndCostUnderline: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
    }
    
    // 目的地label
    private lazy var destinationLabel: UILabel = UILabel().then {
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiExtraLarge, weight: .heavy)
        $0.numberOfLines = 2
        $0.text = "The Great Barrier Reef"
        $0.textAlignment = .center
    }
    
    // 地域・国label
    private lazy var countryAndRegion: UILabel = UILabel().then {
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.small, weight: .ultraLight)
        $0.numberOfLines = 2
        $0.text = "United Kingdom / South West England"
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
   
    // スラッシュ線
    private let slashView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 15 / 360)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 23))
        }
    }
    
    // 必要な勉強時間
    private let requiredStudyHours: UILabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.small)
        $0.textAlignment = .right
    }
    
    // "hours"テキスト
    private let hoursTextLabel = UILabel().then {
        $0.text = "hours"
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.small)
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
    private let missionUnderline: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
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
        $0.textAlignment = .left
    }
    
    // 報酬の下線
    private let rewardUnderline: UIView = UIView().then {
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
        addSubview(missionLabel)
        addSubview(requiredStudyHoursStackView)
        addSubview(missionUnderline)
        backgroundViewForReward.addSubview(rewardImageView)
        addSubview(backgroundViewForReward)
        addSubview(rewardLabel)
        addSubview(rewardUnderline)
        
        // 現在地の国旗と目的地の国旗をまとめる背景View
        nationalFlagBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(dashPointX / 2)
            $0.verticalEdges.equalToSuperview().inset(50)
            $0.width.equalTo(dashPointX - UIConstants.Layout.standardPadding * 2)
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
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + UIConstants.Layout.standardPadding)
            $0.right.equalTo(coinImageView).offset(UIConstants.Layout.semiSmallPadding)
            $0.height.equalTo(35)
            $0.top.equalToSuperview().inset(UIConstants.Layout.semiStandardPadding)
        }
        
        // 距離アイコン
        distanceImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 25))
            $0.left.equalToSuperview().inset(UIConstants.Layout.semiSmallPadding)
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
            $0.left.equalTo(backgroundViewForDistanceAndCoin.snp.right).offset(UIConstants.Layout.standardPadding)
            $0.centerY.equalTo(distanceImageView).offset(3) // 微調整
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
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
            $0.top.equalTo(backgroundViewForDistanceAndCoin.snp.bottom).inset(-UIConstants.Layout.standardPadding)
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + UIConstants.Layout.standardPadding)
            $0.right.equalToSuperview().inset(UIConstants.Layout.smallPadding)
        }
        
        // 地域・国label
        countryAndRegion.snp.makeConstraints {
            $0.top.equalTo(destinationLabel.snp.bottom)
            $0.right.left.equalTo(destinationLabel)
            $0.bottom.equalTo(backgroundViewForMission.snp.top).inset(-UIConstants.Layout.standardPadding)
        }
        
        // ミッションアイコン背景View
        backgroundViewForMission.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + UIConstants.Layout.standardPadding)
            $0.bottom.equalTo(backgroundViewForReward.snp.top).offset(-UIConstants.Layout.semiSmallPadding)
        }
        
        // ミッションアイコン
        missionImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // ミッションlabel
        missionLabel.snp.makeConstraints {
            $0.bottom.equalTo(backgroundViewForMission)
            $0.left.equalTo(backgroundViewForMission.snp.right).offset(UIConstants.Layout.standardPadding)
        }
        
        // 必要な勉強時間
        requiredStudyHoursStackView.snp.makeConstraints {
            $0.bottom.equalTo(missionLabel).inset(8) // 微調整
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
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
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview().inset(UIConstants.Layout.semiStandardPadding)
        }
        
        // 報酬アイコン
        rewardImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.center.equalToSuperview()
        }
        
        // 報酬label
        rewardLabel.snp.makeConstraints {
            $0.bottom.equalTo(backgroundViewForReward)
            $0.left.equalTo(backgroundViewForReward.snp.right).offset(UIConstants.Layout.standardPadding)
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        // ミッションの下線
        rewardUnderline.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.bottom.equalTo(backgroundViewForReward)
            $0.left.equalTo(backgroundViewForReward.snp.centerX)
            $0.right.equalTo(rewardLabel)
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
    func update(with ticketInfo: TicketInfo) {
        travelDistanceAndCost.text = ticketInfo.travelDistanceAndCost.toString
        destinationLabel.text = ticketInfo.destination
        countryAndRegion.text = ticketInfo.countryAndRegion
        missionLabel.text = Int.toTimeFormat(hours: ticketInfo.totalStudyHours, mins: ticketInfo.totalStudyMins)
        requiredStudyHours.text = ticketInfo.requiredStudyHours.toString
        rewardLabel.text = "\(ticketInfo.rewardCoin.toString)＋"
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

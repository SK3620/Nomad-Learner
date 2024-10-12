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
    private let roundedBackgroundView1: UIView = UIView().then {
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
    
    // 距離と支払うコインの値
    private lazy var distanceAndCoinValueLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiSuperLarge)
        $0.text = "21600"
        $0.textAlignment = .left
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
    private lazy var regionLabel: UILabel = UILabel().then {
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.small, weight: .ultraLight)
        $0.numberOfLines = 2
        $0.text = "United Kingdom / South West England"
        $0.textAlignment = .center
    }
    
    // お財布アイコンの背景View
    private let roundedBackgroundView2: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // お財布のアイコン
    private let walletImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "wallet")
    }
    
    // ユーザーが持つ現在の所持金
    private let currentCoinLabel: UILabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.large)
        $0.text = "1000000"
    }
    
    // 右矢印アイコン
    private let arrowRightImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.right")
    }
    
    // 旅費支払い後の残高
    private let remainingCoinLabel: UILabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.large)
        $0.text = "500000"
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
        
        roundedBackgroundView1.addSubview(distanceImageView)
        roundedBackgroundView1.addSubview(IconImageDivider)
        roundedBackgroundView1.addSubview(coinImageView)
        addSubview(roundedBackgroundView1)
        addSubview(distanceAndCoinValueLabel)
        
        let stackView = UIStackView(arrangedSubviews: [
            destinationLabel, regionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        roundedBackgroundView2.addSubview(walletImageView)
        addSubview(roundedBackgroundView2)
        addSubview(currentCoinLabel)
        addSubview(arrowRightImageView)
        addSubview(remainingCoinLabel)
        
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
        roundedBackgroundView1.snp.makeConstraints {
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
        distanceAndCoinValueLabel.snp.makeConstraints {
            $0.left.equalTo(roundedBackgroundView1.snp.right).offset(UIConstants.Layout.standardPadding)
            $0.centerY.equalTo(distanceImageView).offset(3) // 微調整
        }
       
        // 目的地labelと地域・国label
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(distanceImageView)
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
       
        // 目的地label
        destinationLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(regionLabel.snp.top)
        }
        
        // 地域・国label
        regionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        // お財布アイコンの背景View
        roundedBackgroundView2.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.left.equalToSuperview().inset(dashPointX + dashWidth + UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview().inset(UIConstants.Layout.semiStandardPadding)
        }
        
        // お財布アイコン
        walletImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.center.equalToSuperview()
        }
        
        // 現在の所持金
        currentCoinLabel.snp.makeConstraints {
            $0.bottom.equalTo(roundedBackgroundView2)
            $0.left.equalTo(roundedBackgroundView2.snp.right).offset(UIConstants.Layout.standardPadding)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // チケットのダッシュ線を描く
        draw(rect: rect)
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

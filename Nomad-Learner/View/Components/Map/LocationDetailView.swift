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
    
    // 距離のアイコン
    private lazy var distanceImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "distance2")
    }
    
    // 距離アイコンとコインアイコンの区切り線
    private lazy var IconImageDivider: UIView = UIView().then {
        $0.backgroundColor = .black
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2.5)
    }
    
    // コインのアイコン
    private lazy var coinImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "coin2")
    }
    
    // 距離とコインの値
    private lazy var distanceAndCoinValueLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.extraLarge)
        $0.text = "12600"
        $0.textAlignment = .center
    }
    
    // 目的地label
    private lazy var destinationLabel: LocationLabel = LocationLabel(textColor: .darkGray, fontSize: UIConstants.TextSize.semiLarge)
    
    // 目的地scrollView
    private lazy var destinationScrollView: UIScrollView = UIScrollView().then {
        $0.setup()
    }
    
    // 地域・国label
    private lazy var regionLabel: LocationLabel = LocationLabel(textColor: .lightGray, fontSize: UIConstants.TextSize.small)
    
    // 地域・国scrollView
    private lazy var regionScrollView: UIScrollView = UIScrollView().then {
        $0.setup()
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
        self.layer.cornerRadius = UIConstants.Layer.radius
        applyShadow(color: .black, opacity: 0.6, offset: CGSize(width: 0.5, height: 4), radius: 5)
        
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(distanceImageView)
        addSubview(IconImageDivider)
        addSubview(coinImageView)
        addSubview(distanceAndCoinValueLabel)
        
        addSubview(verticalDivider)
        addSubview(horizontalDivider)
       
        destinationScrollView.addSubview(destinationLabel)
        regionScrollView.addSubview(regionLabel)
        addSubview(destinationScrollView)
        addSubview(regionScrollView)
        
        addSubview(locationCategoryCollectionView)
        
        // 距離アイコン
        distanceImageView.snp.makeConstraints {
             $0.size.equalTo(UIConstants.Image.superLarge)
            $0.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.top.equalToSuperview().inset(UIConstants.Layout.smallPadding)
        }
        
        // 距離アイコンとコインアイコンの区切り線
        IconImageDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(20)
            $0.left.equalTo(distanceImageView.snp.right)
            $0.centerY.equalTo(distanceImageView)
        }
        
        // コインアイコン
        coinImageView.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Image.large)
            $0.left.equalTo(IconImageDivider.snp.right)
            $0.centerY.equalTo(distanceImageView)
        }
        
        // 距離とコインの値
        distanceAndCoinValueLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.right.equalTo(coinImageView)
            $0.bottom.equalTo(horizontalDivider.snp.top).inset(-(UIConstants.Layout.extraSmallPadding))
        }
        
        // 縦の区切り線
        verticalDivider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.left.equalTo(coinImageView.snp.right).inset(-(UIConstants.Layout.standardPadding))
            $0.top.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalTo(horizontalDivider.snp.top).inset(-(UIConstants.Layout.smallPadding))
        }
        
        // 横の区切り線
        horizontalDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        // contentSizeの設定（後でgetterとして定義する必要あり？）
        destinationScrollView.contentSize.width = destinationLabel.contentSizeWidth()
        regionScrollView.contentSize.width = regionLabel.contentSizeWidth()
        
        // 目的地scrollView
        destinationScrollView.snp.makeConstraints {
            $0.left.equalTo(verticalDivider.snp.right).inset(-(UIConstants.Layout.standardPadding))
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.top.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.height.equalTo(destinationLabel.contentSizeHeight())
        }
        // 目的地label
        destinationLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        // 地域・国scrollView
        regionScrollView.snp.makeConstraints {
            $0.top.equalTo(destinationScrollView.snp.bottom)
            $0.horizontalEdges.equalTo(destinationScrollView)
            $0.height.equalTo(regionLabel.contentSizeHeight())
        }
        // 地域・国label
        regionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalToSuperview()
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

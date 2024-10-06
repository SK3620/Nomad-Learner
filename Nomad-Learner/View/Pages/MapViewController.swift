//
//  MapViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/04.
//

import UIKit
import SwiftUI

class MapViewController: UIViewController {
    
    private lazy var navigationBoxBar: NavigationBoxBar = NavigationBoxBar()
    
    private lazy var locationDetailView: LocationDetailView = LocationDetailView()
    
    // タブバー
    private lazy var mapTabBar: MapTabBar = MapTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        // UIのセットアップ
        setupUI()
    }
    
    private func setupUI() {
        
        // ナビゲーションバーの設定
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        title = "NavigationBar"
        
        view.addSubview(navigationBoxBar)
        view.addSubview(locationDetailView)
        view.addSubview(mapTabBar)
        
        navigationBoxBar.snp.makeConstraints {
            $0.width.top.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        locationDetailView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.top.equalToSuperview().offset(NavigationHeightProvidable.totalTopBarHeight(navigationController: navigationController))
            $0.height.equalTo(180)
        }
        
        mapTabBar.snp.makeConstraints {
            $0.height.equalTo(UIConstants.TabBarHeight.height)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview().inset(UIConstants.Layout.semiMediumPadding)
        }
    }
}

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: AuthViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}


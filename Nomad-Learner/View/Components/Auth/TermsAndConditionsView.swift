//
//  TermsAndConditionsView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/12/05.
//

import Foundation
import UIKit
import WebKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TermsAndConditionsView: UIView {
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    // ナビゲーションバー
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.addSubview(self.title)
        self.title.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private let title = UILabel().then {
        $0.text = "利用規約"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    // WebView
    let webView = WKWebView().then {
        $0.navigationDelegate = nil // Rxでナビゲーションを管理するために未設定
    }
    
    // 同意ボタン
    let agreeButton = UIButton(type: .system).then {
        $0.setTitle("同意する", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = 10
    }
    
    // アクティビティインジケーター
    let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
        $0.color = ColorCodes.primaryPurple.color()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = ColorCodes.modalBackground.color()
        
        containerView.addSubview(navigationBar)
        containerView.addSubview(webView)
        containerView.addSubview(agreeButton)
        containerView.addSubview(activityIndicator)
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.equalToSuperview().multipliedBy(0.75)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(agreeButton.snp.top).offset(-16)
        }
        
        agreeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(webView)
        }
    }
    
    func loadTermsAndConditions(url: URL?) {
        if let url = MyAppSettings.termsAndConditionsUrl {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

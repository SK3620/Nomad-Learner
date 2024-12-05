//
//  TermsAndConditionsViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/12/05.
//

import UIKit
import SnapKit
import Then
import WebKit
import RxSwift
import RxCocoa

class TermsAndConditionsViewController: UIViewController {
    
    var customAuthPickerVC: CustomAuthPickerViewController?
    
    private let webView = WKWebView()
    private let agreeButton = UIButton(type: .system).then {
        $0.setTitle("同意する", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = 10
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
        $0.color = ColorCodes.primaryPurple.color()
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "利用規約"
        setupUI()
        bindWebView()
        loadTermsAndConditions()
    }
}

extension TermsAndConditionsViewController: AlertEnabled, KRProgressHUDEnabled {
    
    private func setupUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        view.backgroundColor = .white
        
        view.addSubview(webView)
        view.addSubview(agreeButton)
        view.addSubview(activityIndicator)
        
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(agreeButton.snp.top).offset(-16)
        }
        
        agreeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(webView)
        }
    }
    
    private func bindWebView() {
        
        webView.rx
            .didStartLoad
            .subscribe(onNext: { [weak self] _ in
                self?.activityIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
        
        webView.rx
            .didFinishLoad
            .subscribe(onNext: { [weak self] _ in
                 self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        webView.rx
            .didFailLoad
            .map { [weak self] _, error in
                self?.activityIndicator.stopAnimating()
                return AlertActionType.error(.loadTermsAndConditionsFailed(error)) }
            .bind(to: self.rx.showAlert)
            .disposed(by: disposeBag)
        
        agreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                customAuthPickerVC?.didAgreeTermsAndConditions = true
                Router.dismissModal(vc: self)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadTermsAndConditions() {
        if let url = MyAppSettings.termsAndConditionsUrl {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            // エラーアラート表示
            self.rx.showAlert.onNext(AlertActionType.error(.loadTermsAndConditionsFailed(nil)))
        }
    }
}

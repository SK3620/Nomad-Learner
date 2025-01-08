//
//  SeventhPageViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2025/01/08.
//

import UIKit
import Then
import SnapKit
import RxSwift

class AppStartPageController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.descriptionStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.descriptionLabel1,
            self.descriptionLabel2
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = MyAppSettings.appStartPageTitle
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textAlignment = .center
    }
    
    private lazy var descriptionLabel1 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.appStartPageDesc1,
            highlightedWords: [MyAppSettings.appStartPageBluredDesc1]
        )
    }
    
    private lazy var descriptionLabel2 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.appStartPageDesc2
        )
    }
    
    lazy var startAppButton = UIButton(type: .system).then {
        $0.setTitle("始める", for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.layer.cornerRadius = 44 / 2
        $0.layer.borderColor = ColorCodes.primaryPurple.color().cgColor
        $0.layer.borderWidth = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
        
    private func setupUI() {
        view.backgroundColor = ColorCodes.primaryLightPurple.color()
        view.addSubview(stackView)
        view.addSubview(startAppButton)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        startAppButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension AppStartPageController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

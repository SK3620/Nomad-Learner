//
//  SecondPageViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2025/01/05.
//

import UIKit

class SelectLocationPageViewController: UIViewController {

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
            self.descriptionLabel2,
            self.imageView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = MyAppSettings.selectLocationPageTitle
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textAlignment = .center
    }

    private lazy var descriptionLabel1 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.selectLocationPageDesc1,
            highlightedWords: [MyAppSettings.selectLocationPageBluredDesc1]
        )
    }
    
    private lazy var descriptionLabel2 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.selectLocationPageDesc2,
            highlightedWords: [MyAppSettings.selectLocationPageBluredDesc2]
        )
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.selectLocationPageImage)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.height.equalTo(view.screenHeight * 0.45) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.primaryLightPurple.color()
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension SelectLocationPageViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


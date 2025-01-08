//
//  SixthPageViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2025/01/05.
//

import UIKit

import UIKit

class StudyStartPageViewController: UIViewController {

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
            self.descriptionLabel3,
            self.imageStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.imageView2,
            self.imageView1,
            self.imageView3
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = MyAppSettings.studyStartPageTitle
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textAlignment = .center
    }
    
    private lazy var descriptionLabel1 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.studyStartPageDesc1
        )
    }
    
    private lazy var descriptionLabel2 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.studyStartPageDesc2,
            highlightedWords: [MyAppSettings.studyStartPageBluredDesc2]
        )
    }
    
    private lazy var descriptionLabel3 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.studyStartPageDesc3,
            highlightedWords: [MyAppSettings.studyStartPageBluredDesc3]
        )
    }
        
    private lazy var imageView1 = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.studyStartPageImage1)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.height.equalTo(view.screenHeight * 0.2) }
    }
    
    private lazy var imageView2 = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.studyStartPageImage2)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.height.equalTo(view.screenHeight * 0.15) }
    }
    
    private lazy var imageView3 = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.studyStartPageImage3)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.height.equalTo(view.screenHeight * 0.15) }
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
        
        descriptionStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension StudyStartPageViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

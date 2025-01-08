//
//  NinthViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2025/01/08.
//

import UIKit

class StudyMidwayFinishPageController: UIViewController {

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
            self.descriptionLabel,
            self.imageView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = MyAppSettings.studyMidwayFinishPageTitle
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.studyMidwayFinishPageDesc,
            highlightedWords: [MyAppSettings.studyMidwayFinishPageBluredDesc]
        )
    }
        
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.studyMidwayFinishPageImage)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.height.equalTo(view.screenHeight * 0.2) }
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

extension StudyMidwayFinishPageController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


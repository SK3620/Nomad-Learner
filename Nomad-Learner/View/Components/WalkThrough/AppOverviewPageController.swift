//
//  FirstPageViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2025/01/05.
//

import UIKit
import SnapKit
import Then

class AppOverviewPageController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.titleStackView,
            self.descriptionStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.subtitleLabel,
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.descriptionLabel1,
            self.descriptionLabel2,
            self.descriptionLabel3,
            self.pyramidView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel = UILabel().then {
        $0.text = MyAppSettings.appOverviewPageTitle
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textAlignment = .center
    }

    private lazy var subtitleLabel = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.appOverviewPageSubtitle,
            font: UIFont.boldSystemFont(ofSize: 16)
        )
    }

    private lazy var descriptionLabel1 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.appOverviewPageDesc1,
            highlightedWords: [MyAppSettings.appOverviewPageBluredDesc1]
        )
    }

    private lazy var descriptionLabel2 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.appOverviewPageDesc2,
            highlightedWords: [MyAppSettings.appOverviewPageBluredDesc2]
        )
    }
    
    private lazy var descriptionLabel3 = UILabel().then {
        $0.attributedText = $0.createAttributedText(
            text: MyAppSettings.appOverviewPageDesc3
        )
    }
    
    private lazy var pyramidView = PyramidView()
    
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
        
        pyramidView.snp.makeConstraints {
            $0.height.equalTo(view.screenHeight * 0.4)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

class PyramidView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.imageView2,
            self.imageView3
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var imageView1 = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.appOverviewPageImage1)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var imageView2 = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.appOverviewPageImage2)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.width.equalTo(screenWidth * 0.3) }
    }
    
    private lazy var imageView3 = UIImageView().then {
        $0.image = UIImage(named: MyAppSettings.appOverviewPageImage3)
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.width.equalTo(screenWidth * 0.3) }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(stackView)
        addSubview(imageView1)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        imageView1.snp.makeConstraints {
            $0.center.equalTo(stackView)
            $0.height.equalToSuperview()
        }
    }
}

extension AppOverviewPageController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


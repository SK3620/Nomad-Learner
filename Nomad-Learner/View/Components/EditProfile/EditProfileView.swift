//
//  EditProfileView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import Foundation
//
//  EditProfileView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import UIKit
import RxSwift

class EditProfileView: UIView {
    
    // MARK: - Public Properties
    public let navigationBar = EditProfileViewNavigationBar()
    
    // MARK: - Private UI Elements
    private let pictureView = EditProfileView.createRoundedView()
    private let usernameView = EditProfileView.createRoundedView()
    private let countryAndOccupationView = EditProfileView.createRoundedView()
    private let studyContentView = EditProfileView.createRoundedView()
    private let goalView = EditProfileView.createRoundedView()
    
    private let addPictureButton: UIButton = UIButton(type: .system).then {
        let plusImage = UIImage(systemName: "plus")
        $0.setImage(plusImage, for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.imageView?.contentMode = .scaleAspectFit
    }
    private let pictureImageView = UIImageView().then {
        $0.layer.borderColor = ColorCodes.primaryPurple.color().cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 70 / 2
    }
    
    private let usernameLabel = ProfileLabel(text: "Name", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    private let usernameTextView = EditProfileTextView(text: "aaaa")
    
    private let countryAndOccupationLabel = ProfileLabel(text: "Country / Occupation", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    private let countryAndOccupationTextView = EditProfileTextView(text: "aaaa")
    
    private let studyContentLabel = ProfileLabel(text: "Study Content", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    private let studyContentTextView = EditProfileTextView(text: "aaaa")
    
    private let goalLabel = ProfileLabel(text: "Goal", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    private let goalTextView = EditProfileTextView(text: "aaaa")
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        
        // Picture and Username Horizontal Stack
        let pictureAndUsernameStackView = UIStackView(arrangedSubviews: [pictureView, usernameView])
        pictureAndUsernameStackView.axis = .horizontal
        pictureAndUsernameStackView.spacing = UIConstants.Layout.standardPadding
        pictureAndUsernameStackView.alignment = .fill
        pictureAndUsernameStackView.distribution = .fill
        
        // Set Picture and Username Proportions
        pictureView.snp.makeConstraints {
            $0.width.equalTo(pictureAndUsernameStackView.snp.width).multipliedBy(0.35)
        }
        usernameView.snp.makeConstraints {
            $0.left.equalTo(pictureView.snp.right).offset(UIConstants.Layout.standardPadding)
            $0.right.equalToSuperview()
        }
        
        // Main Vertical Stack
        let stackView = UIStackView(arrangedSubviews: [
            pictureAndUsernameStackView,
            countryAndOccupationView,
            studyContentView,
            goalView
        ])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.Layout.standardPadding
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        addSubview(navigationBar)
        addSubview(stackView)
        pictureView.addSubview(addPictureButton)
        pictureView.addSubview(pictureImageView)
        usernameView.addSubview(usernameLabel)
        usernameView.addSubview(usernameTextView)
        countryAndOccupationView.addSubview(countryAndOccupationLabel)
        countryAndOccupationView.addSubview(countryAndOccupationTextView)
        studyContentView.addSubview(studyContentLabel)
        studyContentView.addSubview(studyContentTextView)
        goalView.addSubview(goalLabel)
        goalView.addSubview(goalTextView)
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(UIConstants.NavigationBar.standardHeight)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(UIConstants.Layout.standardPadding)
            make.left.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            make.bottom.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        pictureImageView.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.center.equalToSuperview()
        }
        
        addPictureButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(UIConstants.Layout.semiStandardPadding)
        }
                
        usernameLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        usernameTextView.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        countryAndOccupationLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        countryAndOccupationTextView.snp.makeConstraints {
            $0.top.equalTo(countryAndOccupationLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        studyContentLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        studyContentTextView.snp.makeConstraints {
            $0.top.equalTo(studyContentLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        goalLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        goalTextView.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
    }
    
    // MARK: - Helper Methods
    private static func createRoundedView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = ColorCodes.primaryLightPurple.color()
        return view
    }
}

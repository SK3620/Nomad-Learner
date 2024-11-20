//
//  EditProfileView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileView: UIView {
    // MARK: - Public Properties
    let navigationBar = EditProfileViewNavigationBar()
    
    // MARK: - Private UI Elements
    private let pictureView = EditProfileView.createRoundedView()
    private let usernameView = EditProfileView.createRoundedView()
    private let studyContentView = EditProfileView.createRoundedView()
    private let goalView = EditProfileView.createRoundedView()
    private let othersView = EditProfileView.createRoundedView()
    
    // 画像ライブラリ表示ボタン
    let addPictureButton = UIButton(type: .system).then {
        let plusImage = UIImage(systemName: "plus")
        $0.setImage(plusImage, for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.imageView?.contentMode = .scaleAspectFit
    }
    // デフォルト画像適用ボタン
    let applyDefaultPictureButton = UIButton(type: .system).then {
        let plusImage = UIImage(systemName: "minus")
        $0.setImage(plusImage, for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.imageView?.contentMode = .scaleAspectFit
    }
    // プロフィール画像
    let pictureImageView = UIImageView().then {
        $0.backgroundColor = UIColor(white: 0.85, alpha: 1)
        $0.layer.borderColor = ColorCodes.primaryPurple.color().cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 80 / 2
        $0.layer.masksToBounds = true
    }
    
    private let usernameTitle: ProfileLabel = ProfileLabel(text: "名前", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    let usernameTextView = EditProfileTextView()
    
    /*
    private let livingPlaceAndWorkTitle = ProfileLabel(text: "Country / Occupation", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    let livingPlaceAndWorkTextView = EditProfileTextView(text: "")
     */
    
    private let studyContentTitle: ProfileLabel = ProfileLabel(text: "勉強内容", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    let studyContentTextView = EditProfileTextView()
    
    private let goalTitle: ProfileLabel = ProfileLabel(text: "目標", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    let goalTextView = EditProfileTextView()
    
    private let othersTitle: ProfileLabel = ProfileLabel(text: "その他", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let othersTextView = EditProfileTextView()
    
    init() {
        super.init(frame: .zero)
        setupUI()
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
            $0.left.equalTo(pictureView.snp.right).offset(16)
            $0.right.equalToSuperview()
        }
        
        // Main Vertical Stack
        let stackView = UIStackView(arrangedSubviews: [
            pictureAndUsernameStackView,
            studyContentView,
            goalView,
            othersView
        ])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.Layout.standardPadding
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        addSubview(navigationBar)
        addSubview(stackView)
        pictureView.addSubview(addPictureButton)
        pictureView.addSubview(applyDefaultPictureButton)
        pictureView.addSubview(pictureImageView)
        usernameView.addSubview(usernameTitle)
        usernameView.addSubview(usernameTextView)
        studyContentView.addSubview(studyContentTitle)
        studyContentView.addSubview(studyContentTextView)
        goalView.addSubview(goalTitle)
        goalView.addSubview(goalTextView)
        othersView.addSubview(othersTitle)
        othersView.addSubview(othersTextView)
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        pictureImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.center.equalToSuperview()
        }
        
        addPictureButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(12)
        }
        
        applyDefaultPictureButton.snp.makeConstraints {
            $0.bottom.left.equalToSuperview().inset(12)
        }
        
        usernameTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        usernameTextView.snp.makeConstraints {
            $0.top.equalTo(usernameTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
        
        studyContentTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        studyContentTextView.snp.makeConstraints {
            $0.top.equalTo(studyContentTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
        
        goalTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        goalTextView.snp.makeConstraints {
            $0.top.equalTo(goalTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
        
        othersTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }
        
        othersTextView.snp.makeConstraints {
            $0.top.equalTo(othersTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    // ユーザープロフィール情報を受け取り、UI更新
    func update(with userProfile: User, completion: (UIImage?) -> Void) {
        if userProfile.profileImageUrl.isEmpty {
            pictureImageView.image = UIImage(named: "Globe") // 空の場合はデフォルト画像
            completion(nil) // 画像セット後、空の場合はnilを渡す
        } else {
            pictureImageView.setImage(with: userProfile.profileImageUrl)
            completion(pictureImageView.image) // 画像セット後、画像データを渡す
        }
        usernameTextView.text = userProfile.username
        studyContentTextView.text = userProfile.studyContent
        goalTextView.text = userProfile.goal
        othersTextView.text = userProfile.others
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProfileView {
    // MARK: - Helper Methods
    private static func createRoundedView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = ColorCodes.primaryLightPurple.color()
        return view
    }
}

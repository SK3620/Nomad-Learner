//
//  EditProfileViewNavigationBar.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import UIKit
import Then

class EditProfileViewNavigationBar: UINavigationBar {
    
    // プロフィール画面へ戻るボタン
    public lazy var closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = .white
    }
    
    // 保存ボタン
    public lazy var saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .done, target: nil, action: nil).then {
        $0.tintColor = .white
    }
        
    private lazy var navigationItem = UINavigationItem().then {
        $0.leftBarButtonItem = closeButton
        $0.rightBarButtonItem = saveButton
        $0.title = "Edit Profile"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        self.barTintColor = ColorCodes.primaryPurple.color()
        self.backgroundColor = ColorCodes.primaryPurple.color()
        self.tintColor = ColorCodes.primaryPurple.color()
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        // 半透明を無効にしtintColorを反映
        self.isTranslucent = false
        
        // ナビゲーションアイテムを設定
        self.setItems([navigationItem], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

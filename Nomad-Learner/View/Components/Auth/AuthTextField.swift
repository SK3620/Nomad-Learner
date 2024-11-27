//
//  AuthTextField.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit

class AuthTextField: UITextField {
    
    // ユーザー名, メールアドレス, パスワードのアイコン画像表示
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray
    }
    
    // パスワード表示/非表示切り替えボタン
    lazy var togglePasswordVisibilityButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "eye.slash.fill")
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
    }
    
    // 初期化処理
    init(
        placeholder: String,
        isSecureTextEntry: Bool = false,
        keyboardType: UIKeyboardType = .default,
        leftImageName: String,
        needsRightImage: Bool = false
    ) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.font = UIFont.systemFont(ofSize: 16)
        
        setupUI()
        setupLeftView(with: leftImageName)
        if needsRightImage { setupRightView() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // 枠線は下線のみ表示
    override func draw(_ rect: CGRect) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: rect.height, width: rect.width, height: 0.75)
        border.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(border)
    }
    
    private func setupUI() {
        // 入力文字が勝手に大文字にならないようにする
        autocapitalizationType = .none
        // 入力文字が自動で補正されないようにする
        autocorrectionType = .no
        // 高さ調整
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        // キーボードに完了ボタン表示
        self.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTapped)))
    }
    
    // キーボード閉じる
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
}

extension AuthTextField {
    
    // TextFieldの左端に画像を配置
    private func setupLeftView(with systemName: String) {
        let image = UIImage(systemName: systemName)!
        imageView.image = image
    
        // コンテナビューに入れてレイアウトを微調整
        let containerView = UIView()
        containerView.addSubview(imageView)
        
        // 画像
        imageView.snp.makeConstraints {
            $0.size.equalTo(24) // アイコンサイズ
            $0.left.equalToSuperview().offset(8) // 左側の余白
            $0.centerY.equalToSuperview()
        }
        
        // コンテナビューサイズ制約
        containerView.snp.makeConstraints {
            $0.size.equalTo(imageView).multipliedBy(2) // アイコンサイズの2倍
        }
                
        // leftViewに設定
        leftView = containerView
        leftViewMode = .always
    }
    
    // TextFieldの右端に画像を配置
    private func setupRightView() {
        // rightViewに設定
        rightView = togglePasswordVisibilityButton
        rightViewMode = .always
    }
}

extension AuthTextField {
    func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        togglePasswordVisibilityButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

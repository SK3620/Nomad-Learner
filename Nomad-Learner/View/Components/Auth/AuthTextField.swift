//
//  AuthTextField.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit

class AuthTextField: UITextField {
        
    // 初期化処理
    init(placeholder: String, isSecureTextEntry: Bool = false, keyboardType: UIKeyboardType = .default, imageName: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.font = UIFont.systemFont(ofSize: UIConstants.TextField.fontSize)
        
        // TextField左端に画像配置
        setupLeftView(with: imageName)
        setupUI()
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
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }

        // キーボードに完了ボタン表示
        self.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTapped)))
    }
    
    // キーボード閉じる
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
    
    // TextFieldの左端に画像を配置
    private func setupLeftView(with systemName: String) {
        guard let image = UIImage(systemName: systemName) else {
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        // コンテナビューを作成
        let containerView = UIView()
        containerView.addSubview(imageView)
        
        // 画像
        imageView.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Image.size) // アイコンサイズ
            $0.left.equalToSuperview().offset(UIConstants.Layout.smallPadding) // 左側の余白
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
}

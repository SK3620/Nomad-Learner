//
//  UIImageView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = UIImage(named: "photo") // URLが不正の場合はデフォルトの画像
            return
        }
        
        // Kingfisherを使用して画像を非同期に設定
        self.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                print("Failed to load image, error: \(error)")
                self.image = UIImage(named: "photo")
            }
        }
    }
}


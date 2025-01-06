//
//  UIImageView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/22.
//

import Foundation
import UIKit
import Kingfisher
import SVGKit

extension UIImageView {
    
    // ロケーション画像表示
    func setImage(with urlString: String, options: KingfisherOptionsInfo? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "photo") // URLが不正の場合はデフォルトの画像
            return
        }
        
        // Kingfisherを使用して画像を非同期に設定
        self.kf.setImage(with: url, options: options) { result in
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                print("Failed to load image, error: \(error)")
                self.image = UIImage(named: "Globe")
            }
        }
    }
    
    // SVG国旗画像表示
    func setSVGImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "photo") // URLが不正の場合はデフォルトの画像
            return
        }
        self.kf.setImage(with: url, options: [.processor(SVGImgProcessor())]) { result in
            switch result {
            case .success:
                print("SVG画像国旗を表示しました")
            case .failure(let error):
                // SVGではない国旗画像（png等）の場合は、setImage(with:)で通常表示
                print("Failed to load image, error: \(error)")
                self.setImage(with: urlString)
            }
        }
    }
}

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}


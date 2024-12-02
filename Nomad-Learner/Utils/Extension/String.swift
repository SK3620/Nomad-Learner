//
//  String.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/12/01.
//

import Foundation
import UIKit

extension String {
    /// 指定された幅とフォントでテキストを描画した際のサイズを計算
    /// - Parameters:
    ///   - width: 制約する幅
    ///   - font: 使用するフォント
    ///   - lineBreakMode: 行の折り返し方法（デフォルトは単語単位で折り返し）
    /// - Returns: テキストの描画サイズ
    func height(width: CGFloat,
                font: UIFont,
                lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGFloat {
        // 制約するサイズを定義（幅は指定、高さは最大）
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        // 段落スタイルを作成し、行の折り返し方法を設定
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        
        let boundingBox = self.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        // 計算された高さを返す（切り上げて整数に）
        return ceil(boundingBox.height)
    }
}

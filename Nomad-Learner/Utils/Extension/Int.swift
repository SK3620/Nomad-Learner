//
//  Int.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/08.
//

import Foundation

extension Int {
    var toString: String {
        return String(self)
    }
    
    // 時間と分を「00:00」形式の文字列にフォーマット
    static func toTimeFormat(hours: Int, mins: Int) -> String {
        return String(format: "%02d:%02d", hours, mins)
    }
}

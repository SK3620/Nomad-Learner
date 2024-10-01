//
//  ViewModelType.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/01.
//

import Foundation

// viewModelTypeプロトコルを採用できるのはクラス型のみを保証
protocol ViewModelType: class {
    // 入力と出力という統一された形式に従う
    associatedtype Input
    associatedtype Output
}

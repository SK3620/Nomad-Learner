//
//  DataHandlingType.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation

enum DataHandlingType {
    case initialFetch // 初回の自動取得
    case manualReload // リロードボタンで取得
    case filtering // カテゴリーで絞り込み
    case listenerTriggered // リアルタイムリスナーで取得
    case fetchWithRewardAlert //　データ取得後にアラート表示
}

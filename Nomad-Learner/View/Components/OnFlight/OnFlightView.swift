//
//  onFlightView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/16.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnFlightView: UIView {
    
    private let onFlightImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "OnFlightPurple")
        $0.snp.makeConstraints { $0.size.equalTo(50) }
    }
    
    private let loadingLabel: UILabel = UILabel().then {
        $0.text = "on a flight to the destination . . ."
        $0.textColor = ColorCodes.primaryPurple.color()
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [onFlightImageView, loadingLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private var animationDisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startAnimatingDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        startAnimatingDots()
    }
    
    private func setupUI() {
        addSubview(stackView)
        
        // 制約を設定して、stackViewを画面の中央に配置
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension OnFlightView {
    
    func startAnimatingDots() {
        var dotCount: Int = 0
        let maxDots: Int = 3
        // 0.5秒ごとに点の数を更新するObservableを作成
        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                dotCount = (dotCount + 1) % (maxDots + 1) // 0から3までのサイクル
                let dots = String(repeating: " .", count: dotCount) // 現在の点の数を反映
                self.loadingLabel.text = "on a flight to the destination \(dots)"
            })
            .disposed(by: animationDisposeBag)
    }
    
    func stopAnimatingDots() {
        animationDisposeBag = DisposeBag() // DisposeBagを再生成してアニメーションを停止
    }
}

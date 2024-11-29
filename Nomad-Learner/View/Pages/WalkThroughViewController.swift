//
//  WalkThroughViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/29.
//

import SnapKit
import Then
import RxSwift
import UIKit

class WalkThroughViewController: UIViewController {
        
    private let tapGesture = UITapGestureRecognizer()
    
    private lazy var walkThroughImageView = UIImageView().then {
        $0.image = UIImage(named: "WalkThrough")
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(self.tapGesture)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
}

extension WalkThroughViewController {
    
    private func setupUI() {
        view.addSubview(walkThroughImageView)
        walkThroughImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        tapGesture.rx.event
            .map { _ in () }
            .bind(to: backToMapVC)
            .disposed(by: disposeBag)
    }
}

extension WalkThroughViewController {
    // MapVC（マップ画面）へ戻る
    private var backToMapVC: Binder<Void> { Binder(self, binding: { base, _ in Router.dismissModal(vc: base) })}
}

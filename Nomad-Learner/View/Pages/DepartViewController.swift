//
//  DepartViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/11.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SwiftUI

class DepartViewController: UIViewController {
    
    // 基本のView
    private let basicView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    // DepartVC（出発画面）→ StudyRoomVC（勉強部屋画面）
    private func toStudyRoomVC() {
        // Router.showStudyRoomVC(vc: self)
        Router.showOnFlightVC(vc: self)
    }
    
    // 出発View
    private lazy var departView: DepartView = DepartView(toStudyRoomVC: self.toStudyRoomVC)
    
    // 出発キャンセルボタン
    private let cancelButton: UIButton = UIButton(type: .system).then {
        $0.setTitle("Cancel", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.TextSize.large)
        $0.tintColor = .red
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .white
    }
    
    // MapVC（マップ画面）に戻る
    private var backToMapVC: Void {
        Router.dismissModal(vc: self)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    private func setupUI() {
        // 上部のSafeArea内を塗りつぶす
        view.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.94, alpha: 1.0)
        
        view.addSubview(basicView)
        view.addSubview(departView)
        view.addSubview(cancelButton)
        
        basicView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.left.bottom.equalToSuperview()
        }
        
        departView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.85)
            $0.right.left.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(touchedKnob(_:)))
        departView.knobImageButton.addGestureRecognizer(panGesture)
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.extraLargePadding)
            $0.height.equalTo(60)
        }
    }
    
    private func bind() {
        
        // MapVC（マップ画面）に戻る
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.backToMapVC
            })
            .disposed(by: disposeBag)
    }
}

extension DepartViewController {
    
    // つまみ（knobButton)をスライド
    @objc func touchedKnob(_ sender: UIPanGestureRecognizer) {
        departView.slideKnob(sender: sender)
    }
}

extension DepartViewController {
    
    // 自動的に回転を許可しない
    override var shouldAutorotate: Bool {
        return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

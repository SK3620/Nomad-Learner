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
    
    // タップされたマーカーのロケーション情報
    var locationInfo: LocationInfo?
    
    // つまみの位置が最上部に達した時にイベントを流す
    var knobDidReachTopRelay = PublishRelay<Void>()
    
    // 基本のView
    private let basicView = UIView().then {
        $0.backgroundColor = .white
    }
    
    // 出発View
    private lazy var departView: DepartView = DepartView(locationInfo: self.locationInfo!)
    
    // 出発キャンセルボタン
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("Cancel", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        $0.tintColor = .red
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .white
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // つまみ位置を初期位置に戻す
        departView.resetKnobPosition()
    }
}

extension DepartViewController {
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
            $0.height.equalToSuperview().multipliedBy(0.75)
            $0.right.left.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(touchedKnob(_:)))
        departView.knobImageButton.addGestureRecognizer(panGesture)
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }
    }
    
    private func bind() {
        // MapVC（マップ画面）に戻る
        cancelButton.rx.tap
            .bind(to: backToMapVC)
            .disposed(by: disposeBag)
        
        // つまみが最上部に到達した時に実行する処理を渡す
        departView.knobDidReachTopHandler = { [weak self] in
            self?.knobDidReachTopRelay.accept(())
        }
        
        // 0.5秒遅延でOnFlightVC（出発準備画面）へ遷移
        knobDidReachTopRelay
            .delay(.milliseconds(500), scheduler: MainScheduler.instance) // メインスレッドで遅延処理
            .observe(on: MainScheduler.instance) // 遅延後もメインスレッドで実行
            .bind(to: toOnFlightVC)
            .disposed(by: disposeBag)
    }
}

extension DepartViewController {
    // MapVC（マップ画面）に戻る
    private var backToMapVC: Binder<Void> {
        return Binder(self) { base, _ in 
            if let navForMapVC = base.presentingViewController as? NavigationControllerForMapVC, let mapVC = navForMapVC.viewControllers[0] as? MapViewController {
                mapVC.fromScreen = .departVC
            }
            Router.dismissModal(vc: base)
        }
    }
    
    // OnFlightVC（出発準備画面）へ遷移
    private var toOnFlightVC: Binder<Void> {
        return Binder(self) { base, _ in Router.showOnFlightVC(vc: self, locationInfo: base.locationInfo!) }
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

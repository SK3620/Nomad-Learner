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
    
    // 出発View
    private let departView: DepartView = DepartView()
    
    // チケット画像
    private let departImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "ticket")
    }
    
    // 出発キャンセルボタン
    private let cancelButton: UIButton = UIButton(type: .system).then {
        $0.setTitle("Cancel", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.TextSize.large)
        $0.tintColor = .red
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 20
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
        view.backgroundColor = .white
        
        view.addSubview(departView)
        view.addSubview(cancelButton)
        
        departView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.85)
            $0.top.right.left.equalToSuperview()
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(touchedKnob(_:)))
        departView.knobButton.addGestureRecognizer(panGesture)
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(departView.snp.bottom).offset(UIConstants.Layout.extraLargePadding)
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

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: DepartViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}


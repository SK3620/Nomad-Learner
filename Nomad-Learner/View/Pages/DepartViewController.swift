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
    
    // 出発キャンセルボタン
    private let cancelButton: UIButton = UIButton(type: .system).then {
        $0.setTitle("キャンセル", for: .normal)
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
        
        view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(UIConstants.Layout.standardPadding)
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


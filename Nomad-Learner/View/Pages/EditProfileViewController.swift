//
//  EditProfileViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import UIKit
import SwiftUI
import RxSwift

class EditProfileViewController: UIViewController {
    
    private lazy var editProfileView: EditProfileView = EditProfileView(frame: .zero)
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let disposeBag = DisposeBag()
    
    // ProfileVC（プロフィール画面に戻る）
    private var backToProfileVC: Void {
        Router.dismissModal(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(editProfileView)
        
        editProfileView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.height.equalTo(650)
        }
    }
    
    private func bind() {
        // ProfileVC（プロフィール画面に戻る）
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] sender in
                guard let self = self else { return }
                // タップ位置取得
                let tapLocation = sender.location(in: self.view)
                // profileView枠外のタップの場合、EditProfileVCへ戻る
                if !self.editProfileView.frame.contains(tapLocation) {
                    self.backToProfileVC
                }
                
            })
            .disposed(by: disposeBag)
        // ProfileVC（プロフィール画面に戻る）
        editProfileView.navigationBar.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.backToProfileVC
            })
            .disposed(by: disposeBag)
    }
}

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: EditProfileViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}

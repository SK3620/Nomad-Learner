//
//  ProfileViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import Then
import SnapKit

class ProfileViewController: UIViewController {
    
    var isFromStudyRoomVC: Bool = false
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let disposeBag = DisposeBag()
        
    private lazy var profileView: ProfileView = ProfileView(frame: .zero)
    
    // MapVC（マップ画面）へ戻る
    private var backToMapVC: Void {
        Router.dismissModal(vc: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // UIセットアップ
        setupUI()
        // バインディング
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.modalBackground.color()
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(profileView)
        
        profileView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.semiMediumPadding)
            $0.center.equalToSuperview()
            $0.height.equalTo(400)
        }
    }
    
    private func bind() {
        
        // MapVCへ戻る
        tapGesture.rx.event
            .filter { sender in
                // タップ位置取得
                let tapLocation = sender.location(in: self.view)
                // profileView枠外のタップの場合、MapVCへ戻る
                return !self.profileView.frame.contains(tapLocation)
            }
            .subscribe(onNext: { _ in
                self.backToMapVC
            })
            .disposed(by: disposeBag)
        
        // MapVCへ戻る
        profileView.navigationBar.closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.backToMapVC
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    
    // 自動的に回転を許可するか（デフォルト値: true）
    override var shouldAutorotate: Bool {
       return !isFromStudyRoomVC
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isFromStudyRoomVC ? .landscapeRight : .portrait
    }
}

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: ProfileViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}

class HogeViewController: UIViewController {
    
    var view1 = UIView()
    var view2 = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view1.backgroundColor = .red
        
        view2.backgroundColor = .blue
        
        view.addSubview(view1)
        view1.addSubview(view2)
        
        view1.snp.makeConstraints {
            $0.size.equalTo(300)
            $0.bottom.equalToSuperview()
        }
        
        view2.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(50)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.3) {
            
//            self.view1.frame.size.height = 600
            self.view1.frame.origin.y = 0
            self.view1.frame.size.height = 300
        }
    }
}

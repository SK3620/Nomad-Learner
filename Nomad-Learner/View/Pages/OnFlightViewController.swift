//
//  OnFlightViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/16.
//

import UIKit
import KRProgressHUD
import SnapKit
import SwiftUI

class OnFlightViewController: UIViewController {
    
    private let onFlightView: OnFlightView = OnFlightView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            Router.showStudyRoomVC(vc: self)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(onFlightView)
        
        onFlightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension OnFlightViewController {
    
    // 自動的に回転を許可しない
    override var shouldAutorotate: Bool {
        return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}

/*
struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            OnFlightViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
 */




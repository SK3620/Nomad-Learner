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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            Router.showStudyRoomVC(vc: self)
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




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

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

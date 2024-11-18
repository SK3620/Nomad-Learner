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
import Firebase
import RxSwift
import RxCocoa

class OnFlightViewController: UIViewController, AlertEnabled {
    
    var locationInfo: LocationInfo!
    
    private let onFlightView: OnFlightView = OnFlightView()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 画面の回転が完了してから実行し、エラーアラートを正常に表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bind()
        }
    }
}

extension OnFlightViewController {
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(onFlightView)
        
        onFlightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        
        let viewModel = OnFlightViewModel(
            mainService: MainService.shared,
            locationInfo: locationInfo
        )
        
        Driver.combineLatest(
            viewModel.userProfiles,
            viewModel.latestLoadedDocDate,
            viewModel.oldestDocument
        ) { userProfiles, latestLoadedDocDate, oldestDocument in (userProfiles, latestLoadedDocDate, oldestDocument) }
        .drive(toStudyRoomVC)
        .disposed(by: disposeBag)
        
        // ローディングインジケーター
        viewModel.isLoading
            .drive(self.showOnFlightLoading)
            .disposed(by: disposeBag)
        
        // エラー
        viewModel.myAppError
            .map { AlertActionType.error($0, onConfim: { Router.dismissModal(vc: self) }) }
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
    }
}

extension OnFlightViewController {
    // StudyRoomVC（勉強部屋画面）へ遷移
    private var toStudyRoomVC: Binder<([User], Timestamp?, QueryDocumentSnapshot?)> {
        return Binder(self) { base, tuple in
            let (userProfiles, latestLoadedDocDate, oldestDocument) = tuple
            Router.showStudyRoomVC(
                vc: base,
                locationInfo: base.locationInfo,
                userProfiles: userProfiles,
                latestLoadedDocDate: latestLoadedDocDate,
                oldestDocument: oldestDocument
            )
        }
    }
    // フライト中はローディングアニメーションを表示
    private var showOnFlightLoading: Binder<Bool> {
        return Binder(self) { base, isShow in
            if isShow {
                base.onFlightView.startAnimatingDots()
            } else {
                base.onFlightView.stopAnimatingDots()
            }
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




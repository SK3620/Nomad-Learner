//
//  TicketBackgroundViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/11.
//

import UIKit
import RxSwift

class TicketConfirmViewController: UIViewController {
    // ロケーション情報
    var locationInfo: LocationInfo!
    // チケット
    private let ticketView: TicketView = TicketView()
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        update(locationInfo: locationInfo)
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.modalBackground.color()
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(ticketView)
        
        ticketView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(view.screenHeight - 16 * 2)
        }
    }
    
    private func update(locationInfo: LocationInfo) {
        let ticketInfo = locationInfo.ticketInfo
        let locationStatus = locationInfo.locationStatus
        
        ticketView.update(with: ticketInfo, locationStatus: locationStatus)
    }
}

extension TicketConfirmViewController {
    private func bind() {
        // MapVCへ戻る
        tapGesture.rx.event
            .map { [weak self] sender in
                guard let self = self else { return false }
                let tapLocation = sender.location(in: sender.view)
                return !self.ticketView.frame.contains(tapLocation)
            }
            .filter { $0 } // 枠外タップ（true）のみ処理
            .map { _ in () }
            .bind(to: backToStudyRoomVC)
            .disposed(by: disposeBag)
    }
}

extension TicketConfirmViewController {
    private var backToStudyRoomVC: Binder<Void> {
        return Binder(self) { base, _ in
            Router.dismissModal(vc: base)
        }
    }
}

extension TicketConfirmViewController {
    
    // 自動的に回転を許可するか（デフォルト値: true）
    override var shouldAutorotate: Bool {
       return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

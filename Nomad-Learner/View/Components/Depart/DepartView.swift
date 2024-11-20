//
//  DepartView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/11.
//

import UIKit
import Then
import SnapKit
import RxSwift

class DepartView: UIView {
    
    // タップされたマーカーのロケーション情報
    var locationInfo: LocationInfo
    
    // つまみの位置が最上部に達した時にイベントを流す
    var knobDidReachTopHandler: (() -> Void)?
    
    // つまみの初期中心位置
    private lazy var startCenterY: CGFloat = {
       return self.knobImageButton.center.y
    }()
    
    // つまみの最大中心位置
    private lazy var endCenterY: CGFloat = {
        return self.knobImageButton.bounds.height / 2
    }()
    
    private let ticketView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.94, alpha: 1.0)
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 32
    }

    // 矢印画像
    private let arrowImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
        $0.image = UIImage(systemName: "arrowshape.up.fill", withConfiguration: configuration)
        $0.tintColor = ColorCodes.primaryLightPurple.color()
        $0.tintColor = UIColor(red: 0.97, green: 0.97, blue: 1.0, alpha: 1.0)
    }
    
    // くの字の矢印画像を生成
    private func createChevronImageView() -> UIImageView {
        return UIImageView().then {
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            $0.image = UIImage(systemName: "chevron.up", withConfiguration: configuration)
            $0.tintColor = ColorCodes.primaryPurple.color()
        }
    }
        
    // chevronImageViews用のUIStackView
    private lazy var chevronStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createChevronImageView(), createChevronImageView(), createChevronImageView()])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    // つまみが移動する範囲のView
   private let knobBackgroundView = UIView().then {
       $0.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.94, alpha: 1.0)
        $0.layer.cornerRadius = 80 / 2
    }
    
    // つまみ
    public let knobImageButton = UIButton().then {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "airplane", withConfiguration: configuration), for: .normal)
        $0.layer.cornerRadius = 80 / 2
        // 縦向きの飛行機に調整
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 270 / 360)
        $0.isUserInteractionEnabled = true
    }
    
    // チケット
    private let ticketFrame: TicketView = TicketView()
    
    // お財布アイコンの背景View
    private let backgroundViewForWallet = UIView().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 224/255, blue: 207/255, alpha: 1)
        $0.layer.cornerRadius = 35 / 2
    }
    
    // お財布のアイコン
    private let walletImageView = UIImageView().then {
        $0.image = UIImage(named: "wallet")
    }
    
    // ユーザーが持つ現在の所持金
    private let currentCoinLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    // 右矢印アイコン
    private let arrowRightImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        $0.image = UIImage(systemName: "arrowtriangle.forward", withConfiguration: configuration)
        $0.tintColor = .lightGray
    }
    
    // 旅費支払い後の残高
    private let remainingCoinLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .orange
    }
    
    init(locationInfo: LocationInfo) {
        self.locationInfo = locationInfo
        super.init(frame: .zero)
        
        setupUI()
        update(locationInfo: locationInfo)
    }
    
    private func setupUI() {
        
        addSubview(ticketView)
        addSubview(arrowImageView)
        addSubview(knobBackgroundView)
        knobBackgroundView.addSubview(chevronStackView)
        knobBackgroundView.addSubview(knobImageButton)
        addSubview(ticketFrame)
        backgroundViewForWallet.addSubview(walletImageView)
        addSubview(backgroundViewForWallet)
        addSubview(currentCoinLabel)
        addSubview(arrowRightImageView)
        addSubview(remainingCoinLabel)
        
        ticketView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.75)
            $0.top.right.left.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(ticketFrame.snp.top)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(-16)
        }
        
        knobBackgroundView.snp.makeConstraints {
            $0.center.equalTo(arrowImageView)
            $0.height.equalTo(arrowImageView).multipliedBy(0.7)
            $0.width.equalTo(80)
        }
        
        knobImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        knobImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        chevronStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        ticketFrame.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(ticketView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
        
        backgroundViewForWallet.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.top.equalTo(ticketFrame.snp.bottom).offset(16)
            $0.left.equalTo(ticketFrame).inset(16)
        }
        
        walletImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        currentCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backgroundViewForWallet)
            $0.left.equalTo(backgroundViewForWallet.snp.right).offset(16)
        }
        
        arrowRightImageView.snp.makeConstraints {
            $0.top.equalTo(currentCoinLabel)
            $0.left.equalTo(currentCoinLabel.snp.right).offset(16)
        }
        
        remainingCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backgroundViewForWallet)
            $0.left.equalTo(arrowRightImageView.snp.right).offset(16)
        }
    }
    
    // UIを更新
    private func update(locationInfo: LocationInfo) {
        let ticketInfo = locationInfo.ticketInfo
        let locationStatus = locationInfo.locationStatus
        
        ticketFrame.update(with: ticketInfo, locationStatus: locationStatus)
        currentCoinLabel.text = ticketInfo.currentCoin.toString
        remainingCoinLabel.text = ticketInfo.remainingCoin.toString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DepartView {
    
    // つまみ位置を初期位置に戻す
    func resetKnobPosition() {
        knobImageButton.frame.origin.y = 0
    }
    
    func slideKnob(sender: UIPanGestureRecognizer){
        // knob（つまみ）の移動量を取得
        let point = sender.translation(in: knobBackgroundView)
        // つまみの中心Y座標
        let knobCenterY = sender.view!.center.y + point.y
        var newCenterY: CGFloat = CGFloat()
        
        if sender.state == .ended {
            // つまみから指が離れた時の処理
            if knobCenterY < endCenterY * 2 {
                newCenterY = endCenterY
            } else {
                newCenterY = self.startCenterY
            }
            
            // つまみのアニメーション処理
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                sender.view!.center.y = newCenterY
            } completion: { _ in
                // アニメーション終了時につまみが移動限界位置にあった場合の処理
                if sender.view!.center.y == self.endCenterY {
                    self.knobDidReachTopHandler!()
                }
            }
            // senderが示すUIPanGestureRecognizerによって追跡されているジェスチャーの移動量をゼロにリセットする
            sender.setTranslation(.zero, in: self.knobBackgroundView)
        } else {
            if self.startCenterY >= knobCenterY && self.endCenterY <= knobCenterY {
                newCenterY = knobCenterY
            } else if startCenterY < knobCenterY {
                newCenterY = self.startCenterY
            } else if self.endCenterY > knobCenterY {
                newCenterY = self.endCenterY
            }
            
            sender.view!.center.y = newCenterY
            sender.setTranslation(.zero, in: self.knobBackgroundView)
        }
    }
}

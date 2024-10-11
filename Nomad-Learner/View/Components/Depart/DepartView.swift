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
    private let disposeBag = DisposeBag()
    
    // つまみの初期中心位置
    private lazy var startCenterY: CGFloat = {
       return self.knobButton.center.y
    }()
    
    // つまみの最大中心位置
    private lazy var endCenterY: CGFloat = {
        return self.knobButton.bounds.height / 2
    }()
    
    private let ticketView: UIView = UIView().then {        $0.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.94, alpha: 1.0)
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 32
    }

    // 矢印画像
    private let arrowImageView: UIImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .ultraLight) // ここでアイコンの太さを設定
        $0.image = UIImage(systemName: "arrowshape.up.fill", withConfiguration: configuration)
        $0.tintColor = ColorCodes.primaryLightPurple.color()
        $0.tintColor = UIColor(red: 0.97, green: 0.97, blue: 1.0, alpha: 1.0)
    }
    
    // つまみが移動する範囲のView
   private let knobBackgroundView: UIView = UIView().then {
        $0.layer.cornerRadius = 80 / 2
        $0.backgroundColor = .lightGray
    }
    
    // つまみ
    public let knobButton: UIButton = UIButton().then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "airplane"), for: .normal)
        $0.layer.cornerRadius = 80 / 2
        // 縦向きの飛行機に調整
        $0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 270 / 360)
    }
    
    // チケット画像
    private let departImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "ticket")
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
                
        addSubview(ticketView)
        addSubview(arrowImageView)
        addSubview(knobBackgroundView)
        knobBackgroundView.addSubview(knobButton)
        addSubview(departImageView)
        
        ticketView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.75)
            $0.top.right.left.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(departImageView.snp.top).offset(UIConstants.Layout.mediumPadding)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(-(UIConstants.Layout.standardPadding))
        }
        
        knobBackgroundView.snp.makeConstraints {
            $0.center.equalTo(arrowImageView)
            $0.height.equalTo(arrowImageView).multipliedBy(0.75)
            $0.width.equalTo(80)
        }
        
        knobButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        knobButton.imageView?.snp.makeConstraints {
            $0.size.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
                        
        departImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(ticketView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.extraLargePadding)
            $0.height.equalTo(250)
        }
    }
    
    /*
    // レイアウト完了後に座標を取得
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // (0.0）のため取得できない
        startCenterY = knobButton.center.y
        endCenterY = knobButton.bounds.height / 2
    }
     */
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DepartView {
    
    public func slideKnob(sender: UIPanGestureRecognizer){
        // knob（つまみ）の移動量を取得
        let point = sender.translation(in: knobBackgroundView)
        // つまみの中心Y座標
        var knobCenterY = sender.view!.center.y + point.y
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
                    print("Depart!!!!!")
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

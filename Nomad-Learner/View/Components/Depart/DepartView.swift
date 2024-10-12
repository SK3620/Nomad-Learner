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
    
    // つまみの初期中心位置
    private lazy var startCenterY: CGFloat = {
       return self.knobImageButton.center.y
    }()
    
    // つまみの最大中心位置
    private lazy var endCenterY: CGFloat = {
        return self.knobImageButton.bounds.height / 2
    }()
    
    private let ticketView: UIView = UIView().then {        $0.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.94, alpha: 1.0)
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 32
    }

    // 矢印画像
    private let arrowImageView: UIImageView = UIImageView().then {
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
        stackView.spacing = UIConstants.Layout.extraSmallPadding
        return stackView
    }()
    
    // つまみが移動する範囲のView
   private let knobBackgroundView: UIView = UIView().then {
       $0.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.94, alpha: 1.0)
        $0.layer.cornerRadius = 80 / 2
    }
    
    // つまみ
    public let knobImageButton: UIButton = UIButton().then {
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
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(ticketView)
        addSubview(arrowImageView)
        addSubview(knobBackgroundView)
        knobBackgroundView.addSubview(chevronStackView)
        knobBackgroundView.addSubview(knobImageButton)
        addSubview(ticketFrame)
        
        ticketView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.75)
            $0.top.right.left.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(ticketFrame.snp.top)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(-(UIConstants.Layout.standardPadding))
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
            $0.center.equalToSuperview()  // knobBackgroundViewの中心
        }
        
        ticketFrame.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(ticketView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.largePadding)
            $0.height.equalTo(227)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DepartView {
    
    public func slideKnob(sender: UIPanGestureRecognizer){
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

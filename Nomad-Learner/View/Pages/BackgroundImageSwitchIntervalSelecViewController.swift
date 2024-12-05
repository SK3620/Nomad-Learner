//
//  BackgroundImageSwitchIntervalSelecViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/12/03.
//

import UIKit
import RxSwift
import SnapKit

class BackgroundImageSwitchIntervalSelectViewController: UIViewController {
    
    // 現在のインターバル時間
    var currentIntervalTime: Int?
    // インターバル時間選択時
    var didIntervalTimeSelect: ((Int) -> Void)?
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let instructionLabel = UILabel().then {
        $0.text = "背景画像を何分ごとに切り替えますか？"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let pickerContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    private let pickerView = UIPickerView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let selectButton = UIButton(type: .system).then {
        $0.setTitle("決定", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            instructionLabel,
            pickerView,
            selectButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    // 1〜60分の選択肢
    private let intervalOptions = Array(1...60)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        
        // 現在のインターバル時間が設定されている場合、UIPickerView の選択項目をセット
        setPickerViewSelection(for: currentIntervalTime)
    }
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.modalBackground.color()
        
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(pickerContainerView)
        pickerContainerView.addSubview(stackView)
        
        pickerContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        pickerView.snp.makeConstraints {
            $0.height.equalTo(90)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // 現在のインターバル時間を UIPickerView に反映させるメソッド
    private func setPickerViewSelection(for interval: Int?) {
        guard let interval = interval, let index = intervalOptions.firstIndex(of: interval) else { return }
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
}

extension BackgroundImageSwitchIntervalSelectViewController {
    private func bind() {
        // MapVCへ戻る
        tapGesture.rx.event
            .map { [weak self] sender in
                guard let self = self else { return false }
                let tapLocation = sender.location(in: sender.view)
                return !self.pickerContainerView.frame.contains(tapLocation)
            }
            .filter { $0 } // 枠外タップ（true）のみ処理
            .map { _ in () }
            .bind(to: backToStudyRoomVC)
            .disposed(by: disposeBag)
        
        // 選択ボタンが押されたときに選択されたインターバルを呼び出し元に通知
        selectButton.rx.tap
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                let selectedInterval = self.intervalOptions[selectedRow]
                self.didIntervalTimeSelect?(selectedInterval)
            })
            .map { _ in () }
            .bind(to: backToStudyRoomVC)
            .disposed(by: disposeBag)
    }
}

// UIPickerViewのデータソースとデリゲートメソッド
extension BackgroundImageSwitchIntervalSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  // 1列の選択肢
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervalOptions.count  // 1〜60の60行
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(intervalOptions[row]) 分"
    }
}

extension BackgroundImageSwitchIntervalSelectViewController {
    private var backToStudyRoomVC: Binder<Void> {
        return Binder(self) { base, _ in Router.dismissModal(vc: base) }
    }
}

extension BackgroundImageSwitchIntervalSelectViewController {
    
    // 自動的に回転を許可するか（デフォルト値: true）
    override var shouldAutorotate: Bool {
       return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

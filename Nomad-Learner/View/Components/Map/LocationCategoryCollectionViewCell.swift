//
//  LocationCategoryCollectionViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

class LocationCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "LocationCategoryCollectionViewCell"
    
    // カラー設定のための構造体
    private let selectionColor = SelectionColor()
    
    var disposeBag = DisposeBag()
    
    private lazy var categoryButtonTaps: Signal<Void> = {
        return categoryButton.rx.tap.asSignal()
    }()
   
    // ImageViewとTitleLabelを格納するUIStackView
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private lazy var categoryButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 42 / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    private func setupUI() {
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(categoryButton)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        categoryButton.snp.makeConstraints {
            $0.size.equalTo(42)
        }
    }
    
    // セルが再利用されるたびにDisposeBagを新たに初期化 重複購読を防ぐ
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationCategoryCollectionViewCell {
    
    // 未/選択状態の色
    struct SelectionColor {
        let selectedBackgroundColor = ColorCodes.primaryPurple.color()
        let unselectedBackgroundColor = UIColor.white
        let selectedTitleColor = ColorCodes.primaryPurple.color()
        let unselectedTitleColor = UIColor.lightGray
    }
    
    func configure(with item: LocationCategory, isSelected: Bool) {
        categoryButton.setImage(item.image, for: .normal)
        
        titleLabel.text = item.title
        
        categoryButton.backgroundColor = isSelected
        ? selectionColor.selectedBackgroundColor
        : selectionColor.unselectedBackgroundColor
        
        categoryButton.tintColor = isSelected
        ? item.selectedColor
        : item.unSelectedColor
        
        titleLabel.textColor = isSelected
        ? selectionColor.selectedTitleColor
        : selectionColor.unselectedTitleColor
        
        categoryButton.isUserInteractionEnabled = !isSelected
        
        // イメージビューのサイズ調整
        if [.hasntVisited, .isOngoing, .isCompleted].contains(item) {
            categoryButton.imageView?.snp.remakeConstraints { $0.size.equalTo(26) }
        } else {
            // デフォルトのサイズに戻す
            categoryButton.imageView?.snp.removeConstraints()
        }
    }
    
    // ViewModelへのバインディング
    func bind(buttonDidTap: @escaping () -> Void) {
        categoryButtonTaps
            .emit(onNext: { buttonDidTap() })
            .disposed(by: disposeBag)
    }
}

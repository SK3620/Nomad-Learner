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
        $0.spacing = UIConstants.Layout.smallPadding
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private lazy var categoryButton = UIButton(type: .system).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
         $0.layer.cornerRadius = UIConstants.Button.smallHeight / 2
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
            $0.size.equalTo(UIConstants.Button.smallHeight)
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
        let selectedTintColor = UIColor.white
        let unselectedTintColor = ColorCodes.primaryPurple.color()
        let selectedTitleColor = ColorCodes.primaryPurple.color()
        let unselectedTitleColor = UIColor.lightGray
    }
    
    func configure(with item: LocationCategoryItem, isSelected: Bool) {
        titleLabel.text = item.title
        categoryButton.setImage(UIImage(systemName: item.systemImageName), for: .normal)
        
        self.categoryButton.backgroundColor = isSelected ? self.selectionColor.selectedBackgroundColor : self.selectionColor.unselectedBackgroundColor
        self.categoryButton.tintColor = isSelected ? self.selectionColor.selectedTintColor : self.selectionColor.unselectedTintColor
        self.titleLabel.textColor = isSelected ? self.selectionColor.selectedTitleColor : self.selectionColor.unselectedTitleColor
    }
    
    // ViewModelへのバインディング
    func bind(indexPath: IndexPath, viewModel: MapViewModel) {
        categoryButtonTaps
            .emit(onNext: {
                viewModel.selectedCategoryIndexRelay.accept(indexPath)
            })
            .disposed(by: disposeBag)
    }
}

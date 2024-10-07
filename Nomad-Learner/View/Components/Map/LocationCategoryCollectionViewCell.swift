//
//  LocationCategoryCollectionViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation

import UIKit

class LocationCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "LocationCategoryCollectionViewCell"
    
    // ImageViewとTitleLabelを格納するUIStackView
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = UIConstants.Layout.smallPadding
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.small)
    }
    
    private lazy var categoryButton = UIButton(type: .system).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
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
            $0.size.equalTo(UIConstants.Image.semiLarge)
        }
    }

    func configure(with item: LocationCategory) {
        titleLabel.text = item.title
        categoryButton.setImage(UIImage(systemName: item.systemImageName), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  LocationDetailView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/06.
//

import Foundation
import UIKit

class LocationDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = UIConstants.Layer.radius
        applyShadow(color: .black, opacity: 0.6, offset: CGSize(width: 0.5, height: 4), radius: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  MapViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel {
    
    // MARK: - Output
    let categories: Driver<[LocationCategory]> = Driver.just(LocationCategory.allCases)

}

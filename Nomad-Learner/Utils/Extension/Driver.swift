//
//  Driver.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation
import RxSwift
import RxCocoa

extension Driver {
    
    func applyFirst(handler: @escaping (Element) -> Void) {
        asObservable().take(1).subscribe(onNext: handler).dispose()
    }
    
    var firstValue: Element? {
      var v: Element?
        applyFirst(handler: {(element) -> Void in
            v = element
        })
      return v
    }
    
    var value: Element? { return firstValue }
    var unwrappedValue: Element { return firstValue! }
}



//
//  Observable.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/08.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
  /// 要素の最初の１つを適用して処理を実行する
  ///
  /// (Variable含む）BehaviorSubject利用のObservableの現在値を適用するのに利用できる。
  /// 注；PublishSubject利用のObservableでは何も起こらない。
    func applyFirst(handler: @escaping (Element) -> Void) {
        take(1).subscribe(onNext: handler).dispose()
  }

  /// 最初の値を取得する。
  ///
  /// 注； 最初の値を持っていない場合はnilを返す。
  var firstValue: Element? {
    var v: Element?
      applyFirst(handler: {(element) -> Void in
          v = element
      })
    return v
  }

  /// 現在値を取得する(firstValueのエイリアス)
  ///
  /// (Variable含む）BehaviorSubject利用のObservableの現在値を取得するのに利用できる。
  var value: Element? { return firstValue }
}

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
}



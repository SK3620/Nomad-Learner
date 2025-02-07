## Nomad-Learner

Nomad-Learner（ノマド・ラーナー）は、「旅 ✖️ 自習」をコンセプトに、世界中を旅するような感覚で、他のユーザーと一緒にリアルタイムで自習できるオンライン自習室アプリです。

## サービスのURL

[https://apps.apple.com/jp/app/nomad-learner-オンライン自習室/id6738982400](https://apps.apple.com/jp/app/nomad-learner-%E3%82%AA%E3%83%B3%E3%83%A9%E3%82%A4%E3%83%B3%E8%87%AA%E7%BF%92%E5%AE%A4/id6738982400)

## サービスへの想い・概要

「もし、世界中を旅するような感覚で他の人たちと切磋琢磨しながら自習ができたら、自習がもっとワクワクするものになるのではないか」そんな想いから、このアプリは生まれました。

「旅」という要素を取り入れることで、ただの自習ではなく、まさに冒険心をくすぐるような斬新な学びの形を提供します。

このアプリでは、まず、マップ上の約70箇所から旅先を選び、その場所で自習を開始します。その場所（旅先）の様々な景色を背景に、そこで出会った他のユーザーとオンライン上で共に自習します。目標の自習時間を達成することで、報酬コインをもらうことができ、貯めたコインを使ってさらに世界中を旅しながら自習をすることができます。

## 機能一覧
| **認証画面**                                                                                   | **ウォークスルー画面**                                                                                   | **マップ画面**                                                                                   |
|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| ![Image 1](https://github.com/user-attachments/assets/7e463051-0d47-4bc6-926c-e60d29045be7)      | ![Image 2](https://github.com/user-attachments/assets/ed776ef4-d6b0-42a8-be8f-992e66646452)      | ![Image 3](https://github.com/user-attachments/assets/8aef3817-b3c9-44aa-8763-2b9101ebd49a)      |
| 認証プロバイダーを用いた認証機能と登録せずにアプリをお試しいただくためのトライアル機能を実装しました。| アプリの使い方を説明するため、ウォークスルー画面を実装しました。| マップ上の約70箇所から旅先を選択することができます。

| **プロフィール画面**                                                                                   | **プロフィール編集画面**                                                                           | **出発画面**                                                                             |
|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| ![Image 4](https://github.com/user-attachments/assets/4c5ceb65-caff-428c-87c5-520ce0cf99ae)      | ![Image 5](https://github.com/user-attachments/assets/6092bc7e-904f-447a-bd50-e5980f31ae2f)    | ![Image 6](https://github.com/user-attachments/assets/af02f27a-2dd9-4f8f-8841-11a90f0aa95b)    |
| ユーザーの自習内容や目標の設定機能、合計自習時間や訪問国数などの実績表示機能を実装しました。| プロフィールの編集機能を実装しました。| マップ画面で選択された旅先へのチケット情報や残高等を確認することができます。|

| **自習部屋画面（旅先画面）**                                                                                   | **報酬コイン獲得ダイアログ**                                                                                         |
|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| ![Giffy Canvas](https://github.com/user-attachments/assets/2e2cfeb2-9081-4f37-894c-50bd531e78f1)   | ![Image 5](https://github.com/user-attachments/assets/1ffadbb2-6db3-423a-b88a-ad7c81520c4c)    |
| その旅先の様々な景色を背景に自習します。同じ旅先にいる他のユーザーのプロフィールを表示し、閲覧することができます。その他に、タイマー機能、休憩機能、他ユーザーの入退室通知機能、画面レイアウト切り替え機能等を実装しました。| その旅先での目標の自習時間を達成することで、報酬コインを獲得でき、貯めたコインでさらに世界中を旅することができます。|

## 使用技術

- **Swift 5.10**
- **UIKit**
- **AutoLayout（コードのみ）**
- **RxSwift ~> 6.5.0（MVVM）**
- **RxCocoa ~> 6.5.0（MVVM）**
- **RxKeyboard**

### GoogleMap

- **GoogleMaps ~> 9.1.1**
- **Google-Maps-iOS-Utils 6.0.0**

### Firebase

- **Firebase ~> 11.2.0**
- **Firebase/Analytics**
- **Firebase/Auth ~> 11.2.0**
- **FirebaseFirestore 11.2.0**
- **Firebase/Storage ~> 11.2.0**
- **FirebaseUI ~> 14.2.0**
- **FirebaseUI/Auth ~> 14.2.0**
- **FirebaseUI/Google ~> 14.2.0**
- **FirebaseUI/Facebook ~> 14.2.0**
- **FirebaseUI/OAuth ~> 14.2.0**

### 画像管理

- **Kingfisher ~> 8.0**
- **SVGKit 3.0.0**

### その他

- **KRProgressHUD ~> 3.4.8**
- **SnapKit ~> 5.7.0**
- **Then 3.0.0**
- **CLImageEditor/AllTools 0.2.4**

### ローカルデータベース

- **RealmSwift ~> 10**

### **バージョン管理**

- **Git**
- **GitHub**
- **SourceTree**

### **パッケージ管理**

- **CocoaPods**

## 🎯 改善・アップデート予定

### 1. 仕様の大幅変更
- **現状**  
  - 「自習すれば、コインがもらえて、貯まったコインで旅行して、その旅先でまた自習してまたコインを稼ぐ」という仕様
- **課題**
  - 「保有コインがなければ、旅行できない」 == 「その旅先にいるたくさんのユーザーと一緒に自習できない」
  - 「もし、世界中を旅するような感覚で他の人と一緒に自習ができたら、勉強がもっとワクワクするものになるのではないか」というアプリの本筋に沿っていない
- **目標**  
  - ユーザーは、無制限で世界中を旅できるようにする

- **🛠 対応方針**  
  - 「コインを貯める」という仕様自体を削除する
  - 削除した分、不要となるUIもいくつか出てくるため、代わりに、合計自習時間ランキングや週間合計自習時間ランキング、旅行数ランキングなど、実績をランキング形式で表示して、ユーザーの自習のモチベーションに繋げられるような機能を検討中

### 2. ウォークスルー画面の改善
- **現状・課題**
  - 1ページにつき、説明文を詰め込みすぎている

- **🛠 対応方針**  
  - パワーポイントのアニメーション機能のように、タップするたびに、順次説明文が表示されるような仕組みを導入する
    - ユーザーの視線を誘導し、どこに注目すべきかを明確にする
    - 説明文の詰め込み過ぎを防ぎ、コンテンツの可読性を向上させる

### 3. バックグラウンド中も自習時間を計測する
- **現状・課題**  
  - バックグラウンド状態では、自習時間を計測していない 
  - スマホで調べごとをしながら自習する場合もある

- **🛠 対応方針**  
  - 差分を計算する →「アプリ画面へ復帰した時の時刻」 - 「バックグラウンドへ移行時の時刻」
  - 参考記事「https://qiita.com/NEKOKICHI2/items/e40954814dcde98d43dd」

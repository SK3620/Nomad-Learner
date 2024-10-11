//
//  ProfileTableViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifer: String = "ProfileTableViewCell"
        
    let countryAndOccupationLabel: ProfileLabel = ProfileLabel(text: "Country / Occupation", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let countryAndOccupationInputLabel: ProfileLabel = ProfileLabel(text: "America / Senior in college", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
    let studyContentLabel: ProfileLabel = ProfileLabel(text: "Study Content", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let studyContentInputLabel: ProfileLabel = ProfileLabel(text: "TOEIC Listenign And Reading Section 5 Getting TOEIC900 by September / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful. / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
    let goalLabel: ProfileLabel = ProfileLabel(text: "Goal", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let goalInputLabel: ProfileLabel = ProfileLabel.init(text: "Getting TOEIC900 by September / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful. / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
                
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupUI() {

        contentView.addSubview(countryAndOccupationLabel)
        contentView.addSubview(countryAndOccupationInputLabel)
        contentView.addSubview(studyContentLabel)
        contentView.addSubview(studyContentInputLabel)
        contentView.addSubview(goalLabel)
        contentView.addSubview(goalInputLabel)
        
        countryAndOccupationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }

        countryAndOccupationInputLabel.numberOfLines = 0
        countryAndOccupationInputLabel.snp.makeConstraints {
            $0.top.equalTo(countryAndOccupationLabel.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }

        studyContentLabel.snp.makeConstraints {
            $0.top.equalTo(countryAndOccupationInputLabel.snp.bottom).offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }

        studyContentInputLabel.numberOfLines = 0
        studyContentInputLabel.snp.makeConstraints {
            $0.top.equalTo(studyContentLabel.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }

        goalLabel.snp.makeConstraints {
            $0.top.equalTo(studyContentInputLabel.snp.bottom).offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }

        goalInputLabel.numberOfLines = 0
        goalInputLabel.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview()
        }
    }
}


/*
class ProfileTableViewCell: UITableViewCell {
    
    static let identifer: String = "ProfileTableViewCell"
    
    // TextViewの可変な高さを保持
    private var countryAndOccupationTextViewHeightConstraint: NSLayoutConstraint!
    private var studyContentTextViewHeightConstraint: NSLayoutConstraint!
    private var goalTextViewHeightConstraint: NSLayoutConstraint!
    
    // 国と
    let countryAndOccupationLabel: ProfileLabel = ProfileLabel(text: "Country / Occupation", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let countryAndOccupationTextView = ProfileTextView(text: "America / Senior in college")
    
    let studyContentLabel: ProfileLabel = ProfileLabel(text: "Study Content", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let studyContentTextView = ProfileTextView(text: "TOEIC Listening and Reading Section...TOEIC Listening and Reading Section...TOEIC Listening and Reading Section...")
    
    let goalLabel: ProfileLabel = ProfileLabel(text: "Goal", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let goalTextView = ProfileTextView(text: "Getting TOEIC900 by September")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        
        countryAndOccupationTextView.delegate = self
        studyContentTextView.delegate = self
        goalTextView.delegate = self
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        
        contentView.addSubview(countryAndOccupationLabel)
        contentView.addSubview(countryAndOccupationTextView)
        contentView.addSubview(studyContentLabel)
        contentView.addSubview(studyContentTextView)
//        contentView.addSubview(goalLabel)
//        contentView.addSubview(goalTextView)
        
        countryAndOccupationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
            
            $0.bottom.equalTo(countryAndOccupationTextView.snp.top)
        }
        
        countryAndOccupationTextView.snp.makeConstraints {
            // $0.top.equalTo(countryAndOccupationLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            
            $0.bottom.equalTo(studyContentLabel.snp.top)
        }
                
        studyContentLabel.snp.makeConstraints {
            // $0.top.equalTo(countryAndOccupationTextView.snp.bottom).offset(UIConstants.Layout.smallPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
            
            $0.bottom.equalTo(studyContentTextView.snp.top)
        }
        
        studyContentTextView.snp.makeConstraints {
            // $0.top.equalTo(studyContentLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview()
//            $0.height.equalTo(50)
        }
        
        /*
        goalLabel.snp.makeConstraints {
            $0.top.equalTo(studyContentTextView.snp.bottom).offset(UIConstants.Layout.smallPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }
        
        goalTextView.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview()
//            $0.height.equalTo(50)
        }
         */
    }
}

extension ProfileTableViewCell: UITextViewDelegate {
    
    // テキストが変更された際に高さを再計算
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight(textView)
    }
    
    // TextViewの高さをテキストに応じて調整
    private func adjustTextViewHeight(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        print(size)
        textView.snp.remakeConstraints {
            $0.bottom.equalTo(studyContentLabel.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.height.equalTo(size.height)
        }
        
        /*
         countryAndOccupationTextView.snp.makeConstraints {
             $0.top.equalTo(countryAndOccupationLabel.snp.bottom)
             $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
             // $0.height.equalTo(50)
         }
         */
        
        self.layoutIfNeeded()
        // レイアウトを更新
    }
}
*/

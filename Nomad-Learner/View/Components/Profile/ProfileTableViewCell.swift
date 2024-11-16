//
//  ProfileTableViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifer: String = "ProfileTableViewCell"
    
    let livingPlaceAndWorkTitle: ProfileLabel = ProfileLabel(text: "Country / Occupation", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let livingPlaceAndWork: ProfileLabel = ProfileLabel(text: "America / Senior in college", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
    let studyContentTitle: ProfileLabel = ProfileLabel(text: "Study Content", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let studyContent: ProfileLabel = ProfileLabel(text: "TOEIC Listenign And Reading Section 5 Getting TOEIC900 by September / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful. / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
    let goalTitle: ProfileLabel = ProfileLabel(text: "Goal", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let goal: ProfileLabel = ProfileLabel.init(text: "Getting TOEIC900 by September / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful. / The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.", fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    
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
        
        contentView.addSubview(livingPlaceAndWorkTitle)
        contentView.addSubview(livingPlaceAndWork)
        contentView.addSubview(studyContentTitle)
        contentView.addSubview(studyContent)
        contentView.addSubview(goalTitle)
        contentView.addSubview(goal)
        
        livingPlaceAndWorkTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }
        
        livingPlaceAndWork.numberOfLines = 0
        livingPlaceAndWork.snp.makeConstraints {
            $0.top.equalTo(livingPlaceAndWorkTitle.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.mediumPadding)
        }
        
        studyContentTitle.snp.makeConstraints {
            $0.top.equalTo(livingPlaceAndWork.snp.bottom).offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }
        
        studyContent.numberOfLines = 0
        studyContent.snp.makeConstraints {
            $0.top.equalTo(studyContentTitle.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.mediumPadding)
        }
        
        goalTitle.snp.makeConstraints {
            $0.top.equalTo(studyContent.snp.bottom).offset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().offset(UIConstants.Layout.standardPadding)
        }
        
        goal.numberOfLines = 0
        goal.snp.makeConstraints {
            $0.top.equalTo(goalTitle.snp.bottom).offset(UIConstants.Layout.semiSmallPadding)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.mediumPadding)
            $0.bottom.equalToSuperview()
        }
    }
}

//
//  ProfileTableViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifer = "ProfileTableViewCell"
    
    /*
    let livingPlaceAndWorkTitle: ProfileLabel = ProfileLabel(text: "Country / Occupation", fontSize: UIConstants.TextSize.semiMedium, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let livingPlaceAndWork: ProfileLabel = ProfileLabel(fontSize: UIConstants.TextSize.medium, textColor: .darkGray)
    */
    
    let studyContentTitle: ProfileLabel = ProfileLabel(text: "勉強内容", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let studyContent: ProfileLabel = ProfileLabel(fontSize: 16, textColor: .black)
    
    let goalTitle: ProfileLabel = ProfileLabel(text: "目標", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let goal: ProfileLabel = ProfileLabel(fontSize: 16, textColor: .black)
    
    let othersTitle: ProfileLabel = ProfileLabel(text: "その他", fontSize: 16, textColor: .white, isRounded: true).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    let others: ProfileLabel = ProfileLabel(fontSize: 16, textColor: .black)
    
    
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
        contentView.addSubview(studyContentTitle)
        contentView.addSubview(studyContent)
        contentView.addSubview(goalTitle)
        contentView.addSubview(goal)
        contentView.addSubview(othersTitle)
        contentView.addSubview(others)
        
        studyContentTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
        }
        
        studyContent.numberOfLines = 0
        studyContent.snp.makeConstraints {
            $0.top.equalTo(studyContentTitle.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        goalTitle.snp.makeConstraints {
            $0.top.equalTo(studyContent.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(16)
        }
        
        goal.numberOfLines = 0
        goal.snp.makeConstraints {
            $0.top.equalTo(goalTitle.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        othersTitle.snp.makeConstraints {
            $0.top.equalTo(goal.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(16)
        }
        
        others.numberOfLines = 0
        others.snp.makeConstraints {
            $0.top.equalTo(othersTitle.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

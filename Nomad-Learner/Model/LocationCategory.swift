//
//  LocationCategory.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation

struct LocationCategoryItem {
    let title: String
    let systemImageName: String
    
    static let categories: [LocationCategoryItem] = [
        LocationCategoryItem(title: "Mountain", systemImageName: "mountain.2"),
        LocationCategoryItem(title: "Book", systemImageName: "book"),
        LocationCategoryItem(title: "Leaf", systemImageName: "leaf"),
        LocationCategoryItem(title: "Person", systemImageName: "person"),
        LocationCategoryItem(title: "Airplane", systemImageName: "airplane"),
        LocationCategoryItem(title: "Tennis Ball", systemImageName: "tennisball")
    ]
}

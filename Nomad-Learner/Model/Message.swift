//
//  ProfileDetail.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/14.
//

import Foundation

struct Message {
    let id: String
    let senderID: String
    let senderName: String
    let content: String
    
    static let messages: [Message] = [
        Message(id: "1", senderID: "user1", senderName: "Nomad-Learner", content: "こちらは開発中の機能です。"),
        Message(id: "2", senderID: "user2", senderName: "Nomad-Learner", content: "乞うご期待を！")
        /*
        Message(id: "3", senderID: "user1", senderName: "Alice", content: "Great to hear! What are you up to?"),
        Message(id: "4", senderID: "user3", senderName: "Charlie", content: "Hey everyone, what's going on?"),
        Message(id: "5", senderID: "user2", senderName: "Bob", content: "Just chatting with Alice."),
        Message(id: "6", senderID: "user1", senderName: "Alice", content: "Yeah, we're catching up!"),
        Message(id: "7", senderID: "user4", senderName: "David", content: "Hi guys, can I join the conversation?"),
        Message(id: "8", senderID: "user2", senderName: "Bob", content: "Of course, David! How have you been?"),
        Message(id: "9", senderID: "user4", senderName: "David", content: "I've been good! Just busy with work."),
        Message(id: "10", senderID: "user3", senderName: "Charlie", content: "Same here, work has been hectic."),
        Message(id: "11", senderID: "user1", senderName: "Alice", content: "Tell me about it!"),
        Message(id: "12", senderID: "user5", senderName: "Eve", content: "Hello everyone! What's the topic?"),
        Message(id: "13", senderID: "user2", senderName: "Bob", content: "Hey Eve! We're talking about work.Hey Eve! We're talking about work.Hey Eve! We're talking about work."),
        Message(id: "14", senderID: "user5", senderName: "Eve", content: "Ah, always a fun topic."),
        Message(id: "15", senderID: "user3", senderName: "Charlie", content: "Haha, definitely bbbbbbbbbbbbbbbbbbbbbbb.")
         */
    ]
}

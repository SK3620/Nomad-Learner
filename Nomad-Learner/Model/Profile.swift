//
//  User.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/14.
//

import Foundation

struct Profile {
    let id: String
    let username: String
    let content: String
    let profileImageURL: String
    let nationalImageURL: String
    
    static let profiles: [Profile] = [
        Profile(id: "1", username: "user1 UIViewAlertForUnsatisfiableConstraints UIConstraintBasedLayoutDebugging", content: "Senior Certified Public Accountant with over 10 years of experience in international finance. Expert in financial audits, tax law, and compliance. TOEFL®: Test of English as a Foreign Language and IELTS certified.", profileImageURL: "https://example.com/user1.jpg", nationalImageURL: "https://example.com/flag1.jpg"),
           Profile(id: "2", username: "user2", content: "Marketing specialist with a focus on digital marketing strategies. Extensive knowledge in social media campaigns, content marketing, and brand management. Adept at increasing brand visibility and customer engagement through innovative approaches.", profileImageURL: "https://example.com/user2.jpg", nationalImageURL: "https://example.com/flag2.jpg"),
           Profile(id: "3", username: "user3", content: "Software engineer specializing in backend development with proficiency in cloud architecture, microservices, and data engineering. Built scalable systems for e-commerce platforms handling millions of users.", profileImageURL: "https://example.com/user3.jpg", nationalImageURL: "https://example.com/flag3.jpg"),
           Profile(id: "4", username: "user4", content: "Content writer with expertise in SEO optimization and creative storytelling. Published articles in various tech and lifestyle magazines. Passionate about creating engaging content that resonates with readers.", profileImageURL: "https://example.com/user4.jpg", nationalImageURL: "https://example.com/flag4.jpg"),
           Profile(id: "5", username: "user5", content: "Entrepreneur and business strategist with experience launching multiple startups. Skilled in market analysis, growth hacking, and venture capital fundraising. Strong advocate for innovation in the tech industry.", profileImageURL: "https://example.com/user5.jpg", nationalImageURL: "https://example.com/flag5.jpg"),
           Profile(id: "6", username: "user6", content: "Experienced graphic designer with a portfolio that includes branding, UI/UX design, and print media. Expert in Adobe Creative Suite, Figma, and Sketch. Passionate about visual storytelling and creating user-centered designs.", profileImageURL: "https://example.com/user6.jpg", nationalImageURL: "https://example.com/flag6.jpg"),
           Profile(id: "7", username: "user7", content: "Researcher in environmental science focusing on sustainable development and climate change mitigation. Published papers on renewable energy, green technologies, and ecological conservation.", profileImageURL: "https://example.com/user7.jpg", nationalImageURL: "https://example.com/flag7.jpg"),
           Profile(id: "8", username: "user8", content: "Project manager with a track record of delivering complex software projects on time and within budget. Proficient in Agile and Scrum methodologies, team leadership, and client communication.", profileImageURL: "https://example.com/user8.jpg", nationalImageURL: "https://example.com/flag8.jpg"),
           Profile(id: "9", username: "user9", content: "Cybersecurity expert specializing in network security, encryption, and data privacy. Worked on security protocols for financial institutions and governments to ensure the safety of sensitive information.", profileImageURL: "https://example.com/user9.jpg", nationalImageURL: "https://example.com/flag9.jpg"),
           Profile(id: "10", username: "user10", content: "Full-stack developer with experience in both frontend and backend technologies. Fluent in JavaScript, Python, and Node.js. Built responsive, mobile-first web applications with seamless user experiences.", profileImageURL: "https://example.com/user10.jpg", nationalImageURL: "https://example.com/flag10.jpg"),
        Profile(id: "11", username: "user11", content: "Content for user11", profileImageURL: "https://example.com/user11.jpg", nationalImageURL: "https://example.com/flag11.jpg"),
        Profile(id: "12", username: "user12", content: "Content for user12", profileImageURL: "https://example.com/user12.jpg", nationalImageURL: "https://example.com/flag12.jpg"),
        Profile(id: "13", username: "user13", content: "Content for user13", profileImageURL: "https://example.com/user13.jpg", nationalImageURL: "https://example.com/flag13.jpg"),
        Profile(id: "14", username: "user14", content: "Content for user14", profileImageURL: "https://example.com/user14.jpg", nationalImageURL: "https://example.com/flag14.jpg"),
        Profile(id: "15", username: "user15", content: "Content for user15", profileImageURL: "https://example.com/user15.jpg", nationalImageURL: "https://example.com/flag15.jpg"),
        Profile(id: "16", username: "user16", content: "Content for user16", profileImageURL: "https://example.com/user16.jpg", nationalImageURL: "https://example.com/flag16.jpg"),
        Profile(id: "17", username: "user17", content: "Content for user17", profileImageURL: "https://example.com/user17.jpg", nationalImageURL: "https://example.com/flag17.jpg"),
        Profile(id: "18", username: "user18", content: "Content for user18", profileImageURL: "https://example.com/user18.jpg", nationalImageURL: "https://example.com/flag18.jpg"),
        Profile(id: "19", username: "user19", content: "Content for user19", profileImageURL: "https://example.com/user19.jpg", nationalImageURL: "https://example.com/flag19.jpg"),
        Profile(id: "20", username: "user20", content: "Content for user20", profileImageURL: "https://example.com/user20.jpg", nationalImageURL: "https://example.com/flag20.jpg"),
        Profile(id: "21", username: "user21", content: "Content for user21", profileImageURL: "https://example.com/user21.jpg", nationalImageURL: "https://example.com/flag21.jpg"),
        Profile(id: "22", username: "user22", content: "Content for user22", profileImageURL: "https://example.com/user22.jpg", nationalImageURL: "https://example.com/flag22.jpg"),
        Profile(id: "23", username: "user23", content: "Content for user23", profileImageURL: "https://example.com/user23.jpg", nationalImageURL: "https://example.com/flag23.jpg"),
        Profile(id: "24", username: "user24", content: "Content for user24", profileImageURL: "https://example.com/user24.jpg", nationalImageURL: "https://example.com/flag24.jpg"),
        Profile(id: "25", username: "user25", content: "Content for user25", profileImageURL: "https://example.com/user25.jpg", nationalImageURL: "https://example.com/flag25.jpg"),
        Profile(id: "26", username: "user26", content: "Content for user26", profileImageURL: "https://example.com/user26.jpg", nationalImageURL: "https://example.com/flag26.jpg")
        ]
}

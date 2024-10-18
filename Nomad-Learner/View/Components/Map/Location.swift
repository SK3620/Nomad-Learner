//
//  Location.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/17.
//

import Foundation

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let region: String

    // 必要に応じてLocationを手動で追加していく
    static let all: [Location] = [
        Location(name: "Sydney Opera House", latitude: -33.857, longitude: 151.215, country: "Australia", region: "New South Wales"),
        Location(name: "Eiffel Tower", latitude: 48.859, longitude: 2.294, country: "France", region: "Île-de-France"),
        Location(name: "Great Egyptian Museum", latitude: 30.048, longitude: 31.234, country: "Egypt", region: "Cairo"),
        Location(name: "Great Wall", latitude: 40.432, longitude: 116.570, country: "China", region: "Beijing"),
        Location(name: "Machu Picchu", latitude: -13.163, longitude: -72.548, country: "Peru", region: "Cusco"),
        Location(name: "Taj Mahal", latitude: 27.174, longitude: 78.042, country: "India", region: "Uttar Pradesh"),
        Location(name: "The Colosseum", latitude: 41.890, longitude: 12.492, country: "Italy", region: "Lazio"),
        Location(name: "Petra", latitude: 30.324, longitude: 35.445, country: "Jordan", region: "Ma'an"),
        Location(name: "Acropolis of Athens", latitude: 37.972, longitude: 23.727, country: "Greece", region: "Attica"),
        Location(name: "The Great Barrier Reef", latitude: -16.413, longitude: 145.975, country: "Australia", region: "Queensland"),
        Location(name: "Mount Everest", latitude: 27.988, longitude: 86.925, country: "Nepal", region: "Sagarmatha"),
        Location(name: "Angkor Wat", latitude: 13.412, longitude: 103.867, country: "Cambodia", region: "Siem Reap"),
        Location(name: "Chichen Itza", latitude: 20.683, longitude: -88.570, country: "Mexico", region: "Yucatán"),
        Location(name: "Mesa Verde National Park", latitude: 37.235, longitude: -108.462, country: "USA", region: "Colorado"),
        Location(name: "Christ the Redeemer", latitude: -22.952, longitude: -43.211, country: "Brazil", region: "Rio de Janeiro"),
        Location(name: "Stonehenge", latitude: 51.179, longitude: -1.826, country: "United Kingdom", region: "South West England"),
        Location(name: "The Pyramids of Giza", latitude: 29.979, longitude: 31.134, country: "Egypt", region: "Giza"),
        Location(name: "Grand Canyon", latitude: 36.107, longitude: -112.113, country: "USA", region: "Arizona"),
        Location(name: "Mount Fuji", latitude: 35.361, longitude: 138.727, country: "Japan", region: "Shizuoka"),
        Location(name: "Victoria Falls", latitude: -17.924, longitude: 25.857, country: "Zimbabwe", region: "Matabeleland North"),
        Location(name: "Antelope Canyon", latitude: 36.862, longitude: -111.375, country: "USA", region: "Arizona"),
        Location(name: "Easter Island", latitude: -27.113, longitude: -109.350, country: "Chile", region: "Valparaíso"),
        Location(name: "Santorini", latitude: 36.393, longitude: 25.462, country: "Greece", region: "South Aegean"),
        Location(name: "Marrakech", latitude: 31.630, longitude: -7.981, country: "Morocco", region: "Marrakesh-Safi"),
        Location(name: "Mount Kilimanjaro", latitude: -3.0674, longitude: 37.3556, country: "Tanzania", region: "Kilimanjaro"),
        Location(name: "Niagara Falls", latitude: 43.0962, longitude: -79.0377, country: "Canada/USA", region: "Ontario/New York"),
        Location(name: "Statue of Liberty", latitude: 40.6892, longitude: -74.0445, country: "USA", region: "New York"),
        Location(name: "Alhambra", latitude: 37.176, longitude: -3.588, country: "Spain", region: "Andalusia"),
        Location(name: "Burj Khalifa", latitude: 25.1972, longitude: 55.2744, country: "United Arab Emirates", region: "Dubai"),
        Location(name: "Table Mountain", latitude: -33.9628, longitude: 18.4098, country: "South Africa", region: "Western Cape"),
        Location(name: "Banff National Park", latitude: 51.4968, longitude: -115.9281, country: "Canada", region: "Alberta"),
        Location(name: "Salar de Uyuni", latitude: -20.1338, longitude: -67.4891, country: "Bolivia", region: "Potosí"),
        Location(name: "Venice Canals", latitude: 45.434, longitude: 12.338, country: "Italy", region: "Veneto"),
        Location(name: "Prague Castle", latitude: 50.090, longitude: 14.399, country: "Czech Republic", region: "Prague"),
        Location(name: "Blue Lagoon", latitude: 63.880, longitude: -22.449, country: "Iceland", region: "Grindavik"),
        Location(name: "Hagia Sophia", latitude: 41.0085, longitude: 28.9802, country: "Turkey", region: "Istanbul"),
        Location(name: "Golden Gate Bridge", latitude: 37.8199, longitude: -122.4783, country: "USA", region: "California"),
        Location(name: "Neuschwanstein Castle", latitude: 47.5576, longitude: 10.7498, country: "Germany", region: "Bavaria"),
        Location(name: "Louvre Museum", latitude: 48.8606, longitude: 2.3376, country: "France", region: "Île-de-France"),
        Location(name: "Iguazu Falls", latitude: -25.6867, longitude: -54.4447, country: "Argentina/Brazil", region: "Misiones/Paraná"),
        Location(name: "Galápagos Islands", latitude: -0.9538, longitude: -90.9656, country: "Ecuador", region: "Galápagos"),
        Location(name: "Red Square", latitude: 55.7549, longitude: 37.6208, country: "Russia", region: "Moscow"),
        Location(name: "Palace of Versailles", latitude: 48.8049, longitude: 2.1203, country: "France", region: "Île-de-France"),
        Location(name: "Yosemite National Park", latitude: 37.8651, longitude: -119.5383, country: "USA", region: "California"),
        Location(name: "Mount Rushmore", latitude: 43.8791, longitude: -103.4591, country: "USA", region: "South Dakota")
    ]
}

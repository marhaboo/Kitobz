import Foundation

enum ReviewMood {
    case happy
    case neutral
    case sad
}

struct ReviewItem {
    let userName: String
    let date: String
    let bookCoverImageName: String
    let bookTitle: String
    let rating: Int
    let reviewText: String
    let mood: ReviewMood
}

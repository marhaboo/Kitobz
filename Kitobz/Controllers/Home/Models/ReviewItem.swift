//
//  Quote.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 04/12/25.
//

import Foundation

struct ReviewItem {
    let bookId: String
    let userName: String
    let date: String
    let bookCoverImageName: String
    let bookTitle: String
    let rating: Int
    let reviewText: String
    
    init(bookId: String, userName: String, date: String, bookCoverImageName: String, bookTitle: String, rating: Int, reviewText: String) {
        self.bookId = bookId
        self.userName = userName
        self.date = date
        self.bookCoverImageName = bookCoverImageName
        self.bookTitle = bookTitle
        self.rating = rating
        self.reviewText = reviewText
    }
}

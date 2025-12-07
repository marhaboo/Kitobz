//
//  Book.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 03/12/25.
//

import Foundation

struct Book {
    let coverImageName: String
    let title: String
    let author: String
    let price: String
    let oldPrice: String?
    let discountText: String?
    let id: String
    let bookDescription: String
    let rating: Double
    
    let ageRating: String
    let language: String
    let coverType: String
    let pageCount: Int
    let publishYear: Int
    let reviews: [ReviewItem]
    let quotes: [String]
    let otherBooksByAuthor: [Book]
    
    init(coverImageName: String,
         title: String,
         author: String,
         price: String,
         oldPrice: String? = nil,
         discountText: String? = nil,
         id: String = UUID().uuidString,
         bookDescription: String = "",
         rating: Double = 0.0,
         ageRating: String = "0+",
         language: String = "Русский",
         coverType: String = "Твёрдый",
         pageCount: Int = 0,
         publishYear: Int = 2020,
         reviews: [ReviewItem] = [],
         quotes: [String] = [],
         otherBooksByAuthor: [Book] = []) {
        
        self.coverImageName = coverImageName
        self.title = title
        self.author = author
        self.price = price
        self.oldPrice = oldPrice
        self.discountText = discountText
        self.id = id
        self.bookDescription = bookDescription
        self.rating = rating
        self.ageRating = ageRating
        self.language = language
        self.coverType = coverType
        self.pageCount = pageCount
        self.publishYear = publishYear
        self.reviews = reviews
        self.quotes = quotes
        self.otherBooksByAuthor = otherBooksByAuthor
        
    }
}

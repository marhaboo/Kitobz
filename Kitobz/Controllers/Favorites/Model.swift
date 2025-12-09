//
//  Model.swift
//  Kitobz
//
//  Created by Madina on 09/12/25.
//

import UIKit

struct Book: Codable, Equatable {
    let id: String
    let title: String
    let author: String
    let price: Int
    let imageName: String?

    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}

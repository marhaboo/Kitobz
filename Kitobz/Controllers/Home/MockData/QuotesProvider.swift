//
//  QuotesProvider.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct QuotesProvider {
    static func loadQuotes() -> [Quote] {
        return [
            .init(authorName: "АГАТА КРИСТИ", authorImageName: "author1",
                  text: "Нет ничего более увлекательного, чем тайна, которую предстоит разгадать"),
            .init(authorName: "СЕРГЕЙ ЕСЕНИН", authorImageName: "author2",
                  text: "Если тронуть страсти в человеке, то, конечно, правды не найдешь"),
            .init(authorName: "ФЁДОР ДОСТОЕВСКИЙ", authorImageName: "author3",
                  text: "Перестать читать книги — значит перестать мыслить")
        ]
    }
}


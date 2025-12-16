//
//  ReviewsProvider.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct ReviewsProvider {

    static func loadReviews(for books: [Book]) -> [ReviewItem] {
        var idsByTitle: [String: String] = [:]
        for b in books {
            idsByTitle[b.title] = b.id
        }

        func id(_ title: String) -> String {
            idsByTitle[title] ?? UUID().uuidString
        }

        var result: [ReviewItem] = []

        result += [
            .init(bookId: id("Война и мир"), userName: "Анна", date: "01.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Война и мир» — это не просто роман, а целый мир человеческих судеб, эмоций и размышлений о жизни. Читая эту книгу, постепенно начинаешь ощущать себя частью истории, наблюдателем и участником одновременно. Герои Толстого живые и многогранные: у них есть сомнения, страхи, слабости и моменты внутреннего роста, которые делают их удивительно близкими даже современному читателю."),
            .init(bookId: id("Война и мир"), userName: "Иван", date: "12.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 4,
                  reviewText: "Местами тяжело, но очень мощно."),
            .init(bookId: id("Война и мир"), userName: "Мария", date: "20.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Классика, к которой хочется возвращаться."),
            .init(bookId: id("Война и мир"), userName: "Руслан", date: "25.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Герои живые, сюжет глубокий."),
            .init(bookId: id("Война и мир"), userName: "Екатерина", date: "28.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 4,
                  reviewText: "Объёмно, но оно того стоит."),
            .init(bookId: id("Война и мир"), userName: "Олег", date: "30.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Шедевр, без вопросов.")
        ]

        result += [
            .init(bookId: id("Преступление и наказание"), userName: "Наталья", date: "05.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Потрясающая глубина, заставляет задуматься."),
            .init(bookId: id("Преступление и наказание"), userName: "Сергей", date: "10.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 4,
                  reviewText: "Сложный язык, но идея сильная."),
            .init(bookId: id("Преступление и наказание"), userName: "Алексей", date: "18.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Одна из лучших книг, что читал."),
            .init(bookId: id("Преступление и наказание"), userName: "Диана", date: "26.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 4,
                  reviewText: "Тяжёлая, но нужная книга.")
        ]

        result += [
            .init(bookId: id("Анна Каренина"), userName: "Михаил", date: "03.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Про любовь и выбор — актуально всегда."),
            .init(bookId: id("Анна Каренина"), userName: "Софья", date: "11.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 4,
                  reviewText: "Красивый язык, немного затянуто."),
            .init(bookId: id("Анна Каренина"), userName: "Павел", date: "22.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Сильные эмоции после прочтения.")
        ]

        result += [
            .init(bookId: id("К себе нежно"), userName: "Ирина", date: "07.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Помогла спокойнее относиться к себе."),
            .init(bookId: id("К себе нежно"), userName: "Рустам", date: "16.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 4,
                  reviewText: "Полезные практики, читается легко.")
        ]

        result += [
            .init(bookId: id("Люби себя"), userName: "Ксения", date: "09.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 5,
                  reviewText: "Вдохновляет и поддерживает.")
        ]

        return result
    }
}

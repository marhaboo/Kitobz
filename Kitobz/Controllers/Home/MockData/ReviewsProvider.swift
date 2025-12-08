//
//  ReviewsProvider.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct ReviewsProvider {

    // Генерируем 16 отзывов с неравномерным распределением по книгам
    static func loadReviews(for books: [Book]) -> [ReviewItem] {
        // Создадим словарь по названию для удобства привязки
        var idsByTitle: [String: String] = [:]
        for b in books {
            idsByTitle[b.title] = b.id
        }

        func id(_ title: String) -> String {
            idsByTitle[title] ?? UUID().uuidString
        }

        var result: [ReviewItem] = []

        // warAndPeace — 6
        result += [
            .init(bookId: id("Война и мир"), userName: "Анна", date: "01.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Впечатляющее полотно, читается на одном дыхании.", mood: .happy),
            .init(bookId: id("Война и мир"), userName: "Иван", date: "12.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 4,
                  reviewText: "Местами тяжело, но очень мощно.", mood: .neutral),
            .init(bookId: id("Война и мир"), userName: "Мария", date: "20.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Классика, к которой хочется возвращаться.", mood: .happy),
            .init(bookId: id("Война и мир"), userName: "Руслан", date: "25.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Герои живые, сюжет глубокий.", mood: .happy),
            .init(bookId: id("Война и мир"), userName: "Екатерина", date: "28.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 4,
                  reviewText: "Объёмно, но оно того стоит.", mood: .neutral),
            .init(bookId: id("Война и мир"), userName: "Олег", date: "30.08.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Шедевр, без вопросов.", mood: .happy)
        ]

        // crimeAndPunishment — 4
        result += [
            .init(bookId: id("Преступление и наказание"), userName: "Наталья", date: "05.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Потрясающая глубина, заставляет задуматься.", mood: .happy),
            .init(bookId: id("Преступление и наказание"), userName: "Сергей", date: "10.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 4,
                  reviewText: "Сложный язык, но идея сильная.", mood: .neutral),
            .init(bookId: id("Преступление и наказание"), userName: "Алексей", date: "18.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Одна из лучших книг, что читал.", mood: .happy),
            .init(bookId: id("Преступление и наказание"), userName: "Диана", date: "26.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 4,
                  reviewText: "Тяжёлая, но нужная книга.", mood: .neutral)
        ]

        // annaKarenina — 3
        result += [
            .init(bookId: id("Анна Каренина"), userName: "Михаил", date: "03.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Про любовь и выбор — актуально всегда.", mood: .happy),
            .init(bookId: id("Анна Каренина"), userName: "Софья", date: "11.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 4,
                  reviewText: "Красивый язык, немного затянуто.", mood: .neutral),
            .init(bookId: id("Анна Каренина"), userName: "Павел", date: "22.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Сильные эмоции после прочтения.", mood: .happy)
        ]

        // gentleToYourself — 2
        result += [
            .init(bookId: id("К себе нежно"), userName: "Ирина", date: "07.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Помогла спокойнее относиться к себе.", mood: .happy),
            .init(bookId: id("К себе нежно"), userName: "Рустам", date: "16.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 4,
                  reviewText: "Полезные практики, читается легко.", mood: .happy)
        ]

        // loveYourself — 1
        result += [
            .init(bookId: id("Люби себя"), userName: "Ксения", date: "09.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 5,
                  reviewText: "Вдохновляет и поддерживает.", mood: .happy)
        ]

        return result
    }
}


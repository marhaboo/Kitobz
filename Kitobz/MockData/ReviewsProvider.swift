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
            .init(bookId: id("Война и мир"), userName: "Светлана", date: "02.09.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Каждая страница этой книги наполнена мудростью и философией. Толстой умеет передавать чувства и мысли персонажей так, что они остаются с тобой надолго."),
            .init(bookId: id("Война и мир"), userName: "Дмитрий", date: "05.09.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 4,
                  reviewText: "Сложно читать, но после каждой главы понимаешь, насколько великий писатель перед тобой. История западает в душу."),
            .init(bookId: id("Война и мир"), userName: "Наталья", date: "08.09.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Это книга о жизни, любви, войне и человеческой природе. Каждый герой оставляет глубокий след в сознании читателя."),
            .init(bookId: id("Война и мир"), userName: "Алексей", date: "10.09.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Невероятная эпопея, где переплетаются судьбы людей и исторические события. Читаешь и словно переживаешь вместе с героями."),
            .init(bookId: id("Война и мир"), userName: "Ирина", date: "12.09.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 4,
                  reviewText: "Много деталей, но именно они делают историю живой и настоящей. Читаешь, и книга будто оживает перед глазами."),
            .init(bookId: id("Война и мир"), userName: "Сергей", date: "15.09.2025",
                  bookCoverImageName: "book1", bookTitle: "Война и мир", rating: 5,
                  reviewText: "Не просто роман, а философское произведение о человеческой душе. После прочтения хочется пересматривать свои взгляды на жизнь.")

        ]

        result += [
            .init(bookId: id("Преступление и наказание"), userName: "Марина", date: "28.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Эта книга заставляет смотреть глубже в человеческую душу. Каждый персонаж проживает свои терзания очень реалистично."),
            .init(bookId: id("Преступление и наказание"), userName: "Игорь", date: "30.08.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 4,
                  reviewText: "Интригующий сюжет и психологическая глубина — читаешь и не можешь оторваться."),
            .init(bookId: id("Преступление и наказание"), userName: "Екатерина", date: "01.09.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Каждая страница пропитана моральными дилеммами. После прочтения хочется обсудить её с другими."),
            .init(bookId: id("Преступление и наказание"), userName: "Владимир", date: "03.09.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Роман о преступлении и внутренней борьбе с самим собой. Настоящее психологическое исследование."),
            .init(bookId: id("Преступление и наказание"), userName: "Ольга", date: "05.09.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 4,
                  reviewText: "Сначала тяжело вникнуть, но история стоит усилий. Понимаешь мотивы каждого героя."),
            .init(bookId: id("Преступление и наказание"), userName: "Дмитрий", date: "07.09.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Глубокая, философская книга. Читаешь и понимаешь, что моральные вопросы не имеют простых ответов."),
            .init(bookId: id("Преступление и наказание"), userName: "Людмила", date: "10.09.2025",
                  bookCoverImageName: "book2", bookTitle: "Преступление и наказание", rating: 5,
                  reviewText: "Толстой? Нет, Достоевский! Психология и эмоции персонажей настолько реалистичны, что захватывает дух.")

        ]

        result += [
            .init(bookId: id("Анна Каренина"), userName: "Елена", date: "25.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "История любви и трагедии, которая заставляет задуматься о смысле жизни и правильности решений."),
            .init(bookId: id("Анна Каренина"), userName: "Андрей", date: "28.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 4,
                  reviewText: "Читается сложно, но каждый персонаж настолько живой, что невозможно оторваться."),
            .init(bookId: id("Анна Каренина"), userName: "Мария", date: "30.08.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Толстой мастерски показывает внутренние переживания героев. Чувствуешь их боль и радость."),
            .init(bookId: id("Анна Каренина"), userName: "Виктор", date: "02.09.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Эпическая история о любви, страсти и судьбе. После прочтения долго остаётся в мыслях."),
            .init(bookId: id("Анна Каренина"), userName: "Ольга", date: "05.09.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 4,
                  reviewText: "Много философских размышлений, немного тяжеловато, но впечатление сильное."),
            .init(bookId: id("Анна Каренина"), userName: "Сергей", date: "08.09.2025",
                  bookCoverImageName: "book3", bookTitle: "Анна Каренина", rating: 5,
                  reviewText: "Любовь и общество, моральные дилеммы и эмоции — всё здесь. Книга заставляет переживать вместе с героями.")
        ]

        result += [
            .init(bookId: id("К себе нежно"), userName: "Светлана", date: "20.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Очень вдохновляющая книга. После прочтения появляется желание быть добрее к себе и окружающим."),
            .init(bookId: id("К себе нежно"), userName: "Алексей", date: "23.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 4,
                  reviewText: "Простые советы, но очень эффективные. Помогает лучше понять свои эмоции."),
            .init(bookId: id("К себе нежно"), userName: "Марина", date: "25.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Каждая страница как маленькая поддержка. Книга помогает принимать себя такой, какая есть."),
            .init(bookId: id("К себе нежно"), userName: "Владимир", date: "28.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Очень легкий и понятный стиль, но при этом глубокие мысли о себе и отношениях с окружающими."),
            .init(bookId: id("К себе нежно"), userName: "Ольга", date: "30.08.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 4,
                  reviewText: "После прочтения хочется чаще останавливаться и заботиться о себе. Полезно для всех."),
            .init(bookId: id("К себе нежно"), userName: "Дмитрий", date: "02.09.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Очень теплая и мотивирующая книга. Помогает находить баланс и спокойствие в жизни."),
            .init(bookId: id("К себе нежно"), userName: "Наталья", date: "05.09.2025",
                  bookCoverImageName: "book5", bookTitle: "К себе нежно", rating: 5,
                  reviewText: "Рекомендую всем, кто хочет лучше понимать себя и научиться относиться к себе с любовью.")
        ]

        result += [
            .init(bookId: id("Люби себя"), userName: "Александр", date: "12.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 4,
                  reviewText: "Очень полезные советы, помогает лучше понимать свои чувства и потребности."),
            .init(bookId: id("Люби себя"), userName: "Марина", date: "15.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 5,
                  reviewText: "Читаешь и ощущаешь поддержку на каждом шагу. Книга мотивирует заботиться о себе."),
            .init(bookId: id("Люби себя"), userName: "Игорь", date: "18.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 5,
                  reviewText: "Простые, но глубокие мысли о любви к себе. После прочтения хочется действовать."),
            .init(bookId: id("Люби себя"), userName: "Елена", date: "21.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 4,
                  reviewText: "Книга помогает взглянуть на себя иначе и научиться ценить свои достижения."),
            .init(bookId: id("Люби себя"), userName: "Сергей", date: "25.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 5,
                  reviewText: "Очень вдохновляющее чтение, после которого появляется желание быть добрее к себе."),
            .init(bookId: id("Люби себя"), userName: "Ольга", date: "28.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 5,
                  reviewText: "Тёплая и мотивирующая книга. Полезно для всех, кто хочет развивать любовь к себе."),
            .init(bookId: id("Люби себя"), userName: "Дмитрий", date: "30.08.2025",
                  bookCoverImageName: "book4", bookTitle: "Люби себя", rating: 4,
                  reviewText: "Книга легко читается и помогает находить внутреннюю гармонию.")

        ]
        return result
    }
}

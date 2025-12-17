//
//  BooksProvoder.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct BooksProvider {

    static func baseBooks() -> [Book] {
        let warAndPeace = Book(
            coverImageName: "book1",
            title: "Война и мир",
            author: "Лев Толстой",
            price: "75 TJS",
            oldPrice: nil,
            discountText: nil,
            id: "book.war.and.peace",
            bookDescription:
            """
            «Война и мир» — эпическое произведение о судьбах людей на фоне масштабных исторических событий. Толстой мастерски переплетает жизнь дворянских семей, философские размышления и реалистичные картины войны. 
            Здесь нет однозначных героев — все живые, противоречивые, ошибающиеся и растущие. 
            Автор показывает, как великие события влияют на внутренний мир человека, а человек — на ход истории. 
            Книга заставляет задуматься о смысле жизни, любви, чести и ответственности. 
            Это произведение, к которому хочется возвращаться, открывая в нём новые смыслы на каждом этапе жизни.
            """,
            rating: 4.8,
            ageRating: "12+",
            language: "Русский",
            coverType: "Твёрдый",
            pageCount: 1225,
            publishYear: 1869,
            reviews: [],
            quotes: [],
            otherBooksByAuthor: [],
            isFavorite: true
        )

        let crimeAndPunishment = Book(
            coverImageName: "book2",
            title: "Преступление и наказание",
            author: "Фёдор Достоевский",
            price: "45 TJS",
            oldPrice: "63 TJS",
            discountText: "-30%",
            id: "book.crime.and.punishment",
            bookDescription:
            """
            Роман о преступлении не только как поступке, но и как состоянии души. 
            В центре — внутренний мир Раскольникова, его попытка оправдать зло «высшей идеей», и путь к осознанию собственной ответственности. 
            Достоевский исследует мораль, свободу воли, совесть и искупление, заставляя читателя пережить сложнейшие душевные коллизии. 
            Язык насыщен психологическими деталями, а атмосфера Петербурга усиливает тревожность и напряжение. 
            Книга остаётся актуальной, потому что ставит вечные вопросы, на которые каждый отвечает по‑своему.
            """,
            rating: 4.7,
            ageRating: "16+",
            language: "Русский",
            coverType: "Мягкий",
            pageCount: 671,
            publishYear: 1866,
            isFavorite: true
        )

        let annaKarenina = Book(
            coverImageName: "book3",
            title: "Анна Каренина",
            author: "Лев Толстой",
            price: "40 TJS",
            oldPrice: "52 TJS",
            discountText: "-25%",
            id: "book.anna.karenina",
            bookDescription:
            """
            История любви, свободы и ответственности. 
            Анна — яркая и сильная женщина, которая пытается найти своё счастье, нарушая правила общества. 
            Рядом — линия Левина: поиски смысла, труда и гармонии с собой. 
            Толстой показывает тончайшую психологию героев, столкновение личного и общественного, внешнего и внутреннего. 
            Роман заставляет сопереживать и переосмысливать собственные ценности и выборы.
            """,
            rating: 4.6,
            ageRating: "14+",
            language: "Русский",
            coverType: "Твёрдый",
            pageCount: 864,
            publishYear: 1878
        )

        let loveYourself = Book(
            coverImageName: "book4",
            title: "Люби себя",
            author: "Мария Иванова",
            price: "48 TJS",
            oldPrice: nil,
            discountText: nil,
            id: "book.love.yourself",
            bookDescription:
            """
            Практическое руководство по бережному отношению к себе. 
            Книга помогает лучше понимать свои эмоции, выстраивать границы и заботиться о внутреннем ресурсе. 
            Упражнения и простые практики делают процесс мягким и поддерживающим. 
            Подходит тем, кто хочет снизить тревожность, укрепить уверенность и научиться быть на своей стороне. 
            Чтение вдохновляет на небольшие, но важные изменения в повседневной жизни.
            """,
            rating: 4.9,
            ageRating: "12+",
            language: "Русский",
            coverType: "Мягкий",
            pageCount: 320,
            publishYear: 2022
        )

        let gentleToYourself = Book(
            coverImageName: "book5",
            title: "К себе нежно",
            author: "Екатерина Петрова",
            price: "50 TJS",
            oldPrice: nil,
            discountText: nil,
            id: "book.gentle.to.yourself",
            bookDescription:
            """
            Книга о внимательности к себе и уважении личных границ. 
            Автор делится способами снижать стресс, замечать свои потребности и говорить «нет» без чувства вины. 
            Здесь нет давления — только поддержка и пространство для бережных перемен. 
            Подходит тем, кто устал жить на износ и хочет восстановить контакт с собой. 
            Помогает почувствовать опору внутри и научиться заботиться о себе регулярно.
            """,
            rating: 4.8,
            ageRating: "12+",
            language: "Русский",
            coverType: "Твёрдый",
            pageCount: 298,
            publishYear: 2023
        )

        let books = [warAndPeace, crimeAndPunishment, annaKarenina, loveYourself, gentleToYourself]

        let seededKey = "kitobz_favorites_seeded_v1"
        if !UserDefaults.standard.bool(forKey: seededKey) {
            for book in books where book.isFavorite {
                FavoritesManager.shared.setFavoriteSilently(bookID: book.id, isFavorite: true)
            }
            UserDefaults.standard.set(true, forKey: seededKey)
        }

        return books
    }

    // New: returns books with merged reviews, recalculated ratings, and favorites applied
    static func updatedBooks() -> [Book] {
        let base = baseBooks()
        let reviews = ReviewsProvider.loadReviews(for: base)
        let reviewsByBookId = Dictionary(grouping: reviews, by: { $0.bookId })

        let merged: [Book] = base.map { book in
            let bookReviews = reviewsByBookId[book.id] ?? []
            let newRating: Double
            if !bookReviews.isEmpty {
                let sum = bookReviews.reduce(0) { $0 + $1.rating }
                newRating = Double(sum) / Double(bookReviews.count)
            } else {
                newRating = book.rating
            }
            return Book(
                coverImageName: book.coverImageName,
                title: book.title,
                author: book.author,
                price: book.price,
                oldPrice: book.oldPrice,
                discountText: book.discountText,
                id: book.id,
                bookDescription: book.bookDescription,
                rating: newRating,
                ageRating: book.ageRating,
                language: book.language,
                coverType: book.coverType,
                pageCount: book.pageCount,
                publishYear: book.publishYear,
                reviews: bookReviews,
                quotes: book.quotes,
                otherBooksByAuthor: book.otherBooksByAuthor,
                isFavorite: FavoritesManager.shared.isFavorite(bookID: book.id) || book.isFavorite
            )
        }
        return merged
    }
}


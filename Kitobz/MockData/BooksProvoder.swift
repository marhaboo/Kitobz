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
            price: "249 TJS",
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
            price: "169 TJS",
            oldPrice: nil,
            discountText: nil,
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
            price: "199 TJS",
            oldPrice: nil,
            discountText: nil,
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
            price: "149 TJS",
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
            price: "159 TJS",
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
        
        let catMask = Book(
                    coverImageName: "book6",
                    title: "Кошачья маска",
                    author: "Влад Райбер",
                    price: "179 TJS",
                    oldPrice: nil,
                    discountText: nil,
                    id: "book.cat.mask",
                    bookDescription:
                    """
                    Мистический триллер, в котором реальность переплетается с кошмаром. Влад Райбер погружает читателя в атмосферу саспенса, где обычные вещи обретают пугающий смысл. 
                    Главный герой сталкивается с тайной «кошачьей маски», которая меняет судьбы тех, кто осмелится её надеть. 
                    Это история о скрытых сторонах человеческой души, страхах и расплате за любопытство. Идеально для любителей современной хоррор-прозы и психологических загадок.
                    """,
                    rating: 4.7,
                    ageRating: "18+",
                    language: "Русский",
                    coverType: "Твёрдый",
                    pageCount: 350,
                    publishYear: 2023
                )

                let chekhovStories = Book(
                    coverImageName: "book7",
                    title: "Большое собрание юмористических рассказов",
                    author: "Антон Чехов",
                    price: "219 TJS",
                    oldPrice: "229 TJS",
                    discountText: "-27%",
                    id: "book.chekhov.stories",
                    bookDescription:
                    """
                    Полное собрание раннего творчества великого классика. В этот том вошли самые яркие юмористические рассказы Чехова, в которых он с неподражаемой иронией высмеивает человеческие пороки, чинопочитание и глупость. 
                    От «Смерти чиновника» до «Толстого и тонкого» — эти истории остаются невероятно актуальными и сегодня. 
                    Мастерство краткости и точность деталей делают чтение этой книги истинным удовольствием для ценителей классической русской литературы.
                    """,
                    rating: 4.9,
                    ageRating: "12+",
                    language: "Русский",
                    coverType: "Твёрдый",
                    pageCount: 720,
                    publishYear: 2021
                )

                let stationLikho = Book(
                    coverImageName: "book8",
                    title: "Станция Лихо (Ладный мир)",
                    author: "Надя Сова",
                    price: "189 TJS",
                    oldPrice: "249 TJS",
                    discountText: "-24%",
                    id: "book.station.likho",
                    bookDescription:
                    """
                    Захватывающее славянское фэнтези о грани между нашим миром и пугающим «Ладным миром». 
                    Надя Сова создает уникальную мифологию, где привычные городские локации соседствуют с обителью древних существ. 
                    Главная героиня оказывается втянута в опасное путешествие на станцию Лихо, из которой нет простого пути назад. 
                    Книга наполнена фольклорными мотивами, мрачной атмосферой и поисками ответов на вопросы о семье и предназначении.
                    """,
                    rating: 4.8,
                    ageRating: "16+",
                    language: "Русский",
                    coverType: "Твёрдый",
                    pageCount: 416,
                    publishYear: 2022
                )

                let manWithoutQualities = Book(
                    coverImageName: "book9",
                    title: "Человек без свойств. Том 1",
                    author: "Роберт Музиль",
                    price: "269 TJS",
                    oldPrice: "349 TJS",
                    discountText: "-23%",
                    id: "book.man.without.qualities",
                    bookDescription:
                    """
                    Один из самых значимых романов XX века, изменивший мировую литературу. Это глубокое философское исследование жизни в преддверии Первой мировой войны. 
                    Музиль анализирует кризис личности и общества через призму главного героя Ульриха, который отказывается принимать готовые социальные роли. 
                    Сложный, интеллектуальный и многослойный текст, объединяющий поколения читателей, ищущих ответы на фундаментальные вопросы бытия.
                    """,
                    rating: 4.5,
                    ageRating: "18+",
                    language: "Русский",
                    coverType: "Твёрдый",
                    pageCount: 840,
                    publishYear: 1930
                )

                let ceruleanSea = Book(
                    coverImageName: "book10",
                    title: "Дом в лазурном море",
                    author: "Ти Джей Клун",
                    price: "179 TJS",
                    oldPrice: "229 TJS",
                    discountText: "-22%",
                    id: "book.cerulean.sea",
                    bookDescription:
                    """
                    Невероятно теплая и жизнеутверждающая история о том, что семья — это не всегда кровное родство. 
                    Линус Бейкер, скромный инспектор по делам магической молодежи, отправляется на остров, где живут «опасные» дети. 
                    Эта поездка меняет его представление о мире, добре и праве быть собой. 
                    Ти Джей Клун создал настоящий литературный «антидепрессант», полный юмора, доброты и магии, который учит принимать тех, кто на нас не похож.
                    """,
                    rating: 4.9,
                    ageRating: "16+",
                    language: "Русский",
                    coverType: "Мягкий",
                    pageCount: 448,
                    publishYear: 2020
                )

        let books = [warAndPeace, crimeAndPunishment, annaKarenina, loveYourself, gentleToYourself, catMask, chekhovStories, stationLikho, manWithoutQualities, ceruleanSea ]

        let seededKey = "kitobz_favorites_seeded_v1"
        if !UserDefaults.standard.bool(forKey: seededKey) {
            for book in books where book.isFavorite {
                FavoritesManager.shared.setFavoriteSilently(bookID: book.id, isFavorite: true)
            }
            UserDefaults.standard.set(true, forKey: seededKey)
        }

        return books
    }

    
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


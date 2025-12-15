//
//  RoundCardsProvider.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct RoundCardsProvider {
    static func loadItems() -> [RoundCardItem] {
        [
            .init(title: "Доставка", imageName: "Delivery"),
            .init(title: "Рассрочка", imageName: "Installment"),
            .init(title: "Соц. сети", imageName: "SocialMedia"),
            .init(title: "Гифт карты", imageName: "GiftCards"),
            .init(title: "Отзывы", imageName: "Reviews"),
            .init(title: "О нас", imageName: "AboutUs"),
            .init(title: "Аккаунт", imageName: "Account")
        ]
    }
}

struct StoriesProvider {
    static func loadStories() -> [Story] {
        [
            Story(
                id: "delivery",
                title: "Доставка",
                coverImageName: "Delivery",
                images: ["Delivery", "story_delivery_2"],
                link: URL(string: "https://kitobz.example.com/delivery"),
                isSeen: false
            ),
            Story(
                id: "installment",
                title: "Рассрочка",
                coverImageName: "Installment",
                images: ["Installment", "story_installment_2"],
                link: URL(string: "https://kitobz.example.com/installment"),
                isSeen: false
            ),
            Story(
                id: "social",
                title: "Соц. сети",
                coverImageName: "SocialMedia",
                images: ["SocialMedia", "story_social_2", "story_social_3", "story_social_4"],
                link: URL(string: "https://instagram.com/yourpage"),
                isSeen: false
            ),
            Story(
                id: "giftcards",
                title: "Гифт карты",
                coverImageName: "GiftCards",
                images: ["GiftCards"],
                link: URL(string: "https://kitobz.example.com/giftcards"),
                isSeen: false
            ),
            Story(
                id: "reviews",
                title: "Отзывы",
                coverImageName: "Reviews",
                images: ["Reviews"],
                link: URL(string: "https://kitobz.example.com/reviews"),
                isSeen: false
            ),
            Story(
                id: "about",
                title: "О нас",
                coverImageName: "AboutUs",
                images: ["AboutUs"],
                link: URL(string: "https://kitobz.example.com/about"),
                isSeen: false
            ),
            Story(
                id: "account",
                title: "Аккаунт",
                coverImageName: "Account",
                images: ["Account"],
                link: URL(string: "https://kitobz.example.com/account"),
                isSeen: false
            )
        ]
    }
}

//
//  SocialMediaProvider.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct SocialMediaProvider {
    static func loadItems() -> [SocialMediaItem] {
        return [
            .init(iconName: "InstagramIcon", link: URL(string: "https://instagram.com/kitobz.tj")!),
            .init(iconName: "FacebookIcon", link: URL(string: "https://facebook.com/kitobz")!),
            .init(iconName: "TelegramIcon", link: URL(string: "https://t.me/kitobz")!),
            .init(iconName: "PhoneIcon", link: URL(string: "tel:+992903022298")!)
        ]
    }
}


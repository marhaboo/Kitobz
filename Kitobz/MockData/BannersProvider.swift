//
//  BannersProvider.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 08/12/25.
//

import Foundation

struct BannersProvider {
    static func loadBanners() -> [Banner] {
        return [
            Banner(imageName: "banner"),
            Banner(imageName: "banner2"),
            Banner(imageName: "banner")
        ]
    }
}


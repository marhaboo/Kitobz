//
//  RoundCard.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 03/12/25.
//

import Foundation

struct RoundCardItem {
    let title: String
    let imageName: String
}

struct Story: Identifiable, Equatable {
    let id: String
    let title: String
    let coverImageName: String
    let images: [String]
    let link: URL?
    var isSeen: Bool
}

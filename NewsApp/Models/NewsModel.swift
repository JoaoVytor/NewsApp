//
//  NewsModel.swift
//  NewsApp
//
//  Created by João Vitor Sousa on 26/01/24.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}

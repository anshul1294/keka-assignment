//
// Response.swift
// Cityflo
//
// Created by Anshul Gupta on 19/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation

struct MainResponse: Codable {
    let status: String?
    let copyright: String?
    let response: Response?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case copyright = "copyright"
        case response = "response"
    }
}


struct Response: Codable {
    let docs: [Doc]?
    enum CodingKeys: String, CodingKey {
        case docs = "docs"
    }
}

struct Doc: Codable {
    let abstract: String?
    let multimedia: [MultiMedia]?
    let headline: Headline?
    let actualPublicationDate: String?
    var publicationDate: Date? {
        guard let actualPubDate = actualPublicationDate else {
            return nil
        }
        return DateConverter.convertDate(dateString: actualPubDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case abstract = "abstract"
        case multimedia = "multimedia"
        case headline = "headline"
        case actualPublicationDate = "pub_date"
    }
}

struct MultiMedia: Codable {
    let imageUrl: String?
    enum CodingKeys: String, CodingKey {
        case imageUrl = "url"
    }
}

struct Headline: Codable {
    let main: String?
    enum CodingKeys: String, CodingKey {
        case main = "main"
    }
}

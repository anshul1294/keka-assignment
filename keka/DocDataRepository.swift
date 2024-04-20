//
// DocDataRepository.swift
// Cityflo
//
// Created by Anshul Gupta on 20/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation
import CoreData

class DBRepository {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchDocsFromDB() throws -> [Document] {
        return try context.fetch(Document.fetchRequest())
    }
    
    func saveDocsToDB(docs: [Doc]) throws {
        for doc in docs {
            let newDoc = Document(context: context)
            newDoc.publicationDate = doc.actualPublicationDate
            newDoc.documentDescription = doc.abstract
            newDoc.imageUrl = doc.multimedia?.first?.imageUrl
            newDoc.title = doc.headline?.main
        }
        try context.save()
    }
}

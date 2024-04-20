//
// Document+CoreDataProperties.swift
// Cityflo
//
// Created by Anshul Gupta on 20/04/24.
// Copyright © Cityflo. All rights reserved.
//

//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var publicationDate: String?
    @NSManaged public var documentDescription: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?

}

extension Document : Identifiable {

}

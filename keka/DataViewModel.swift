//
// DataViewModel.swift
// Cityflo
//
// Created by Anshul Gupta on 19/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class DocViewModel {
    var docs: [Doc] = [] {
        didSet {
            delegate?.itemsDidChange()
        }
    }
    
    weak var delegate: DocsViewModelDelegate?
    
    weak var errorDelegate: DocsViewModelErrorDelegate?
    
    //let context: NSManagedObjectContext
    
    let networkChecker: NetworkInternetConnectionChecker
    let dataRepository: DataRepository
    let dbRepo: DBRepository
    
    init(dbRepo: DBRepository, networkChecker: NetworkInternetConnectionChecker, dataRepository: DataRepository) {
        self.dbRepo = dbRepo
        self.networkChecker = networkChecker
        self.dataRepository = dataRepository
    }

    func fetchDocs() {
        if networkChecker.isNetworkReachable() {
            dataRepository.fetchDocs { result in
                switch result {
                case .success(let documents):
                    self.docs = documents.sorted(by: self.sortByPublicationDate)
                    self.saveOfflineData()
                case .failure(let failure):
                    self.errorDelegate?.showError(error: failure.localizedDescription)
                }
            }
        } else {
            self.fetchOfflineDocs()
        }
        
    }
    
    func fetchOfflineDocs() {
        do {
            let documents = try dbRepo.fetchDocsFromDB()
            let docs = documents.map { doc in
                return Doc(abstract: doc.documentDescription,
                           multimedia: [MultiMedia(imageUrl: doc.imageUrl)],
                           headline: Headline(main: doc.title),
                           actualPublicationDate: doc.publicationDate)
            }.sorted(by: self.sortByPublicationDate)
            self.docs.append(contentsOf: docs)
        } catch {
            errorDelegate?.showError(error: error.localizedDescription)
        }
    }
    
    func saveOfflineData() {
        do {
            try dbRepo.saveDocsToDB(docs: docs)
        } catch {
            errorDelegate?.showError(error: error.localizedDescription)
        }
    }
    
    func sortByPublicationDate(_ doc1: Doc, _ doc2: Doc) -> Bool {
        guard let date1 = doc1.publicationDate, let date2 = doc2.publicationDate else {
            return false
        }
        return date1 > date2
    }
}

protocol DocsViewModelDelegate: AnyObject {
    func itemsDidChange()
}

protocol DocsViewModelErrorDelegate: AnyObject {
    func showError(error: String)
}

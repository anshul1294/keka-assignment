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
    let dataRepository: DataRepository
    
    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }

    func fetchDocs() {
        dataRepository.fetchDocs { result in
            switch result {
            case .success(let docs):
                self.docs = docs.sorted(by: self.sortByPublicationDate)
            case .failure(let failure):
                self.errorDelegate?.showError(error: failure.localizedDescription)
            }
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

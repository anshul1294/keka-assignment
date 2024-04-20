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
        dataRepository.fetchDocs { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let docs):
                strongSelf.docs = docs.sorted(by: strongSelf.sortByPublicationDate)
            case .failure(let failure):
                strongSelf.errorDelegate?.showError(error: failure.localizedDescription)
            }
        }
    }
    
    private func sortByPublicationDate(_ doc1: Doc, _ doc2: Doc) -> Bool {
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

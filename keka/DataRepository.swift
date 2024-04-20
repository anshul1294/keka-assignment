//
// DataRepository.swift
// Cityflo
//
// Created by Anshul Gupta on 19/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation

protocol DataRepository {
    func fetchDocs(completion: @escaping (Result<[Doc], Error>) -> Void)
}

class DataRepositoryImplementation: DataRepository {
    private let dbRepo: DBRepo
    private let networkChecker: NetworkInternetConnectionChecker
    
    init(dbRepo: DBRepo, networkChecker: NetworkInternetConnectionChecker) {
        self.dbRepo = dbRepo
        self.networkChecker = networkChecker
    }
    
    func fetchDocs(completion: @escaping (Result<[Doc], Error>) -> Void) {
        if networkChecker.isNetworkReachable() {
            remoteFetchDocs { result in
                switch result {
                case .success(let documents):
                    completion(.success(documents))
                    do {
                        try self.dbRepo.saveDocsToDB(docs: documents)
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        } else {
            self.fetchOfflineDocs { result in
                switch result {
                case .success(let documents):
                    completion(.success(documents))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
    
    
    func fetchOfflineDocs(completion: @escaping (Result<[Doc], Error>) -> Void) {
        do {
            let documents = try dbRepo.fetchDocsFromDB()
            let docs = documents.map { doc in
                return Doc(abstract: doc.documentDescription,
                           multimedia: [MultiMedia(imageUrl: doc.imageUrl)],
                           headline: Headline(main: doc.title),
                           actualPublicationDate: doc.publicationDate)
            }
            completion(.success(docs))
        } catch {
            completion(.failure(error))
        }
    }
    
    func remoteFetchDocs(completion: @escaping (Result<[Doc], NetworkError>) -> Void)  {
        NetworkHelper.shared.fetchDocsFromNetwork(from: NetworkHelper.Endpoint.getDocData) { result in
            switch result {
            case .success(let docs):
                if let docsItem = docs.response?.docs {
                    completion(.success(docsItem))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

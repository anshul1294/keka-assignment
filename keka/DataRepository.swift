//
// DataRepository.swift
// Cityflo
//
// Created by Anshul Gupta on 19/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation

protocol DataRepository {
    func fetchDocs(completion: @escaping (Result<[Doc], NetworkError>) -> Void)
}

class DataRepositoryImplementation: DataRepository {
    func fetchDocs(completion: @escaping (Result<[Doc], NetworkError>) -> Void)  {
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

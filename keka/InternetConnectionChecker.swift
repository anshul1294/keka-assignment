//
// InternetConnectionChecker.swift
// Cityflo
//
// Created by Anshul Gupta on 20/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation

protocol InternetConnectionChecker {
    func isNetworkReachable() -> Bool
}


class NetworkInternetConnectionChecker: InternetConnectionChecker {
    func isNetworkReachable() -> Bool {
        return NetworkHelper.shared.isNetworkReachable()
    }
}

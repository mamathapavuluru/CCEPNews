//
//  NetworkError.swift
//  CCEP


import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case invalidUrl
    case invalidRequest
    case invalidResponse
    case emptyResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}

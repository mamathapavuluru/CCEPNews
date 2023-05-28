//
//  NetworkHandler.swift
//  CCEP


import Foundation
import Combine

class NetworkHandler: NSObject {
    static let sharedInstance = NetworkHandler()
    
    private override init() { }
    
    func requestAPI<T: Decodable>(url: String, parameter: [String: AnyObject]? = nil, httpMethodType: HTTPMethodType = .getMethod) -> AnyPublisher<T, NetworkError> {
        if Reachability.isConnectedToNetwork() {
            guard let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                  let url = URL(string: escapedAddress) else {
                return Fail(error: NetworkError.invalidUrl).eraseToAnyPublisher()
            }
            var request = URLRequest(url: url)
            request.httpMethod = httpMethodType.rawValue
            if let requestBodyParams = parameter {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBodyParams, options: .prettyPrinted)
                } catch {
                    return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
                }
            }
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.0 }
                .decode(type: T.self, decoder: JSONDecoder())
                .catch { error in Fail(error: NetworkError.jsonDecodingError(error: error)).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.noInternetConnection).eraseToAnyPublisher()
        }
    }
}


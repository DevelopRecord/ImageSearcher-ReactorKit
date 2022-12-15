//
//  APIService.swift
//  ImageSearcher-ReactorKit
//
//  Created by 이재혁 on 2022/12/14.
//

import Foundation
import Alamofire
import RxSwift

enum URLAddress: String {
    case base = "https://api.giphy.com/v1/gifs/"
    case search = "search?api_key="
    case apiKey = "KZEGYsikekh16bUz5eISfk4w5Gghdays"
}

enum NetworkError: Error {
    case badUrl(message: String)
    case noData(message: String)
    case unknownErr(message: String)
    case error404(message: String)
    case decodingErr(message: String)
}

class APIService {
    static let shared = APIService()
    
    func fetchGifs(query: String) -> Single<GiphyResponse> {
        let urlString = URLAddress.base.rawValue + URLAddress.search.rawValue + URLAddress.apiKey.rawValue + getQuery(query: query)
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedUrlString) else { return Observable.error(NSError(domain: "Non URL ..", code: 404, userInfo: nil)).asSingle() }
        
        return self.fetchGiphy(url: url)
    }
}

extension APIService {
    private func getQuery(query: String) -> String {
        return "&q=\(query)"
    }
    
    private func fetchGiphy<T: Decodable>(url: URL) -> Single<T> {
        return Single<T>.create { single in
            let request = AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
                switch response.result {
                case .success(let jsonData):
                    do {
                        let giphy = try JSONDecoder().decode(T.self, from: jsonData)
                        single(.success(giphy))
                    } catch let error {
                        print(NetworkError.decodingErr(message: "\(error.localizedDescription)"))
                        single(.failure(error))
                    }
                case .failure(let error):
                    print(NetworkError.noData(message: "\(error)"))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

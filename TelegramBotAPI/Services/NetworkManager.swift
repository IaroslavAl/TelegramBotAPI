//
//  NetworkManager.swift
//  TelegramBotAPI
//
//  Created by Iaroslav Beldin on 12.05.2023.
//

import Foundation
import Alamofire

enum Link {
    case getMe
    case sendMessage
    
    var url: URL {
        let token = NetworkManager.shared.token
        
        switch self {
        case .getMe:
            return URL(string: "https://api.telegram.org/bot\(token ?? "")/getMe")!
        case .sendMessage:
            return URL(string: "https://api.telegram.org/bot\(token ?? "")/sendMessage")!
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    var token: String?
    
    private init() {}
    
    func fetchBotInfo(from url: URL, completion: @escaping(Result<Bot, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let bot = Bot.getBot(from: value)
                    completion(.success(bot))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func sendMessage(to url: URL, with data: Message, completion: @escaping(Result<Answer, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let answer = Answer.getAnswer(from: value)
                    completion(.success(answer))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

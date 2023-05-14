//
//  Message.swift
//  TelegramBotAPI
//
//  Created by Iaroslav Beldin on 12.05.2023.
//

import Foundation

struct Message: Encodable {
    let chatId: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
            case text
        }
}

struct Answer: Decodable {
    let result: AnswerInfo
    
    init(result: AnswerInfo) {
        self.result = result
    }
    
    init(from answerData: [String: Any]) {
        result = AnswerInfo(from: answerData["result"] as? [String: Any] ?? [:])
    }
    
    static func getAnswer(from value: Any) -> Answer {
        guard let answerData = value as? [String: Any],
              let resultData = answerData["result"] as? [String: Any] else {
            return Answer(result: AnswerInfo(date: 0))
        }
        
        let answer = Answer(result: AnswerInfo(from: resultData))
        
        return answer
    }
}

struct AnswerInfo: Decodable {
    let date: Int
    
    init(date: Int) {
        self.date = date
    }
    
    init(from resultData: [String: Any]) {
        date = resultData["date"] as? Int ?? 0
    }
}

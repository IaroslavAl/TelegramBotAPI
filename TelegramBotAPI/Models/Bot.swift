//
//  BotInfo.swift
//  TelegramBotAPI
//
//  Created by Iaroslav Beldin on 12.05.2023.
//

struct Bot {
    let result: BotInfo
    
    init(result: BotInfo) {
        self.result = result
    }
    
    init(from botData: [String: Any]) {
        result = BotInfo(from: botData["resalt"] as? [String: Any] ?? [:])
    }
    
    static func getBot(from value: Any) -> Bot {
        guard let botData = value as? [String: Any],
              let resultData = botData["result"] as? [String: Any] else {
            return Bot(result: BotInfo(firstName: "", lastName: nil, userName: nil))
        }
        
        let bot = Bot(result: BotInfo(from: resultData))
        
        return bot
    }
}

struct BotInfo {
    let firstName: String
    let lastName: String?
    let userName: String?
    
    var fullName: String {
        guard let lastName else { return firstName }
        return "\(firstName) \(lastName)"
    }
    
    var description: String {
        guard let userName else { return fullName }
        return "\(fullName)\n@\(userName)"
    }
    
    init(firstName: String, lastName: String?, userName: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
    }
    
    init(from resultData: [String: Any]) {
        firstName = resultData["first_name"] as? String ?? ""
        lastName = resultData["last_name"] as? String
        userName = resultData["username"] as? String
    }
}

struct Message: Encodable {
    let chatId: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
            case chatId = "chat_id"
            case text
        }
}

struct Answer {
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

struct AnswerInfo {
    let date: Int
    
    init(date: Int) {
        self.date = date
    }
    
    init(from resultData: [String: Any]) {
        date = resultData["date"] as? Int ?? 0
    }
}

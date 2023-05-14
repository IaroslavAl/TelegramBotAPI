//
//  MainViewController.swift
//  TelegramBotAPI
//
//  Created by Iaroslav Beldin on 12.05.2023.
//

import UIKit
import SafariServices

final class MainViewController: UIViewController {
    
    @IBOutlet var botInfoLabel: UILabel!
    @IBOutlet var tokenTF: UITextField!
    @IBOutlet var chatIdTF: UITextField!
    @IBOutlet var messageTF: UITextField!
    @IBOutlet var linkButton: UIButton!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenTF.delegate = self
        chatIdTF.delegate = self
        messageTF.delegate = self
        linkButton.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func sendPressed() {
        guard tokenTF.text != "",
              chatIdTF.text != "",
              messageTF.text != "" else {
            showAlert(title: "Данные не введены", message: "Заполните все поля")
            return
        }
        fetchBotInfo()
        sendMessage()
    }
    
    @IBAction func linkPressed() {
        openLink()
    }
    
    private func fetchBotInfo() {
        networkManager.token = tokenTF.text
        networkManager.fetchBotInfo(from: Link.getMe.url) { [weak self] result in
            switch result {
            case .success(let success):
                self?.botInfoLabel.text = success.result.description
            case .failure(let error):
                self?.botInfoLabel.text = ""
                self?.showAlert(title: "Неверные данные", message: "Токен введен не верно", textField: self?.tokenTF)
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendMessage() {
        networkManager.token = tokenTF.text
        networkManager.sendMessage(to: Link.sendMessage.url, with: Message(chatId: chatIdTF.text ?? "", text: messageTF.text ?? "")) { [weak self] result in
            switch result {
            case .success(let answer):
                let date = Date(timeIntervalSince1970: TimeInterval(answer.result.date))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let dateString = dateFormatter.string(from: date)
                
                self?.showAlert(title: "Успешно", message: "Сообщение отправлено в \(dateString)", textField: self?.messageTF)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            textField?.text = ""
            if textField == messageTF {
                linkButton.isHidden = false
            }
            textField?.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func openLink() {
        let url = URL(string: "https://www.t.me/\(chatIdTF.text?.dropFirst() ?? "")")!
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tokenTF {
            guard textField.text != "" else { return }
            fetchBotInfo()
        } else if textField == chatIdTF {
            linkButton.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}

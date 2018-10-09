//
//  LoginViewController.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 14.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    let vkService = VKAuthService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAuth()
    }

    private func showAuth() {
        do {
            let request = try vkService.createAuthRequest()
            webView.load(request)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }

}
extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error._code == -1009 {
            print("No Internet Connection")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
            else {
                //assertionFailure("Incorrect redirect url or no response parameters!")
                decisionHandler(.allow)
                return
        }
        let urlComponents = fragment.components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }
        let token = urlComponents.first {$0.first == "access_token"}?.last
        let userId = Int(urlComponents.first {$0.first == "user_id"}?.last ?? "0")
        guard let accessToken = token else {
            assertionFailure("No token received!")
            decisionHandler(.allow)
            return
        }
        guard let userIdInt = userId else {
            assertionFailure("No user_id!")
            decisionHandler(.allow)
            return
        }
        //Записываем id в FirebaseDatabase в соответствующую ветку
        let dbLink = Database.database().reference()
        dbLink.child("Users/id").setValue(userIdInt)
        
        UserDataKeyChain.saveData(token: accessToken, user_id: userIdInt)
        decisionHandler(.cancel)
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return false
    }
}

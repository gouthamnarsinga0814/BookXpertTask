//
//  ViewController.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import UIKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupGoogleButton()
    }

    private func setupGoogleButton() {
        let signInButton = GIDSignInButton()
        signInButton.center = view.center
        view.addSubview(signInButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(signInTapped))
        signInButton.addGestureRecognizer(tap)
    }
    
    @objc func signInTapped() {
      //  guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: Constants.clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                print("Authentication failed.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign in error: \(error.localizedDescription)")
                    return
                }
                
                print("Signed in successfully as \(authResult?.user.email ?? "Unknown Email")")
                
                guard let user = authResult?.user else { return }
                
                let name = user.displayName ?? ""
                let email = user.email ?? ""
                let photoURL = user.photoURL?.absoluteString ?? ""
                
                print("User signed in:", name, email)
                
                CoreDataManager.shared.saveUser(name: name, email: email, photoURL: photoURL)
                
                let home = HomeViewController()
                self.navigationController?.pushViewController(home, animated: true)
                
            }
        }
    }

}


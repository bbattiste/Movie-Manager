//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/26/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

// want to get request token, login with website, create session id, get user id, go to next view

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: BorderedButton!

    var tmdbClient: TMDBClient!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the TMDB client
        tmdbClient = TMDBClient.sharedInstance()
        
        configureBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        // MARK: Authentication (GET) Methods
        /*
            Steps for Authentication...
            https://www.themoviedb.org/documentation/api/sessions
            
            Step 1: Create a new request token
            Step 2a: Ask the user for permission via the website
            Step 3: Create a session ID
            Bonus Step: Go ahead and get the user id 😄!
        */
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (succes, errorString) in
            performUIUpdatesOnMain {
                if succes {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    // MARK: Login
    
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
}

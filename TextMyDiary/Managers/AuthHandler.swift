
import Foundation
import Firebase

enum AuthState{
    case login
    case signup
    case landing
    case done
    case security
    case securitySettings
}

class AuthHandler: ObservableObject {
    @Published var resultMsg: String = ""
    @Published var state: AuthState = .landing
    @Published var initialized = false
    
    private var email: String = ""
    private var password: String = ""
    private var username: String = ""
    private var securityHandler: SecurityHandler = SecurityHandler.instance
    private var profileHandler: ProfileHandler = ProfileHandler.instance
    let db = Firestore.firestore()
    static var instance = AuthHandler()
    
    private init() {
        startAuthListener()
    }
    	
    func startAuthListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.initialized = true
            
            //TODO: Burda her şeyi kapatıp yeniden açmak lazım
            self.securityHandler.stopSecuritySettingsListener()
            self.profileHandler.stopUsernameListener()
            self.securityHandler.startSecuritySettingsListener()
            self.profileHandler.startUsernameListener()
            if user == nil {
                if self.state == .landing {
                    
                    self.state = .signup
                }
                
                else {
                    self.state = .landing
                }
            }
            
            else if self.state == .signup {
                self.state = .securitySettings
            }
            
            else if self.state == .landing {
                //TODO: Check if should prompt for password
                self.securityHandler.stopSecuritySettingsListener()
                self.securityHandler.startSecuritySettingsListener(){ preference in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if preference != .neither && self.state != .done {
                            self.state = .security
                        }
                        else if self.state != .done {
                            self.state = .done
                        }                    }
                }
            }
        }
    }

    func logInUser(email: String, password: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
            if let e = error {
                completion?(error)
            }
            else if let result = authResult{
                AuthHandler.instance.state = .done
                completion?(nil)
            }
            else {
                // Handle else
                print("else")
                completion?(nil)
            }
        }
    }
    
    func forgotPassword(email: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let err = error {
                completion?(error)
            }
            else {
                completion?(nil)
            }
        }
    }
    
    func signUpUser(email: String, password: String, username: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                // Handle Error
                completion?(error)
            }
            else if let result = authResult{
                // Handle result
                let userID = result.user.uid
                self.db.collection("profiles").document(userID).setData([
                    "name": username,
                ])
                print("UserID: \(userID)")
                print("current user ID: \(Auth.auth().currentUser?.uid)")
                self.resultMsg = "success"
                completion?(nil)
            }
            else {
                // Handle else
                print("else")
                completion?(nil)
            }
        }
    }
    
    func signOut () -> Bool {
        do {
            self.state = .landing
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func changePasswordRequest(with newPassword: String, was oldPassword: String, completion: ((Error?) -> Void)? = nil) {
        let user = Auth.auth().currentUser
        let credentials = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: oldPassword)
        user?.reauthenticate(with: credentials, completion: { (result, error) in
          if error != nil {
            completion?(error)
          } else {
            // User re-authenticated.
            user?.updatePassword(to: newPassword) { (error) in
              if let error = error {
                completion?(error)
              } else {
                completion?(nil)
              }
            }
          }
        })
      }
}

import SwiftUI

struct AuthPageHeader: View {
    var image: Image
    var text: String
    var blackImage: Bool
    var body: some View {
        VStack(alignment: .leading) {
            
            if blackImage {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.width/4)
                    .padding(.leading)
                    .padding(.top, 30)
            }
            
            else {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.width/4)
                    .padding(.leading)
                    .padding(.top, 30)
            }
            
            Text(text)
                .font(.system(size: 40, design: .rounded))
                .fontWeight(.bold)
                .padding(.leading)
        }
    }
}

struct SignupPageGoodDesign: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @EnvironmentObject var authHandler: AuthHandler
    @State var error: Error? = nil
    @State var loading: Bool = false
    
    var vw: CGFloat = UIScreen.main.bounds.size.width / 100
    var vh: CGFloat = UIScreen.main.bounds.size.height / 100
    
    var body: some View {
        ZStack {
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: -40*vw, y: -40*vh)
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: 50*vw, y: 50*vh)
            VStack (alignment: .leading) {
                AuthPageHeader(image: Image("LogoFlat"), text: "Hi there!", blackImage: false)
                    .padding(.bottom, 8*vh)
                SignupLoginInputView(imageSystemName: "envelope.fill", headline: "Email adress", textFieldPrompt: "Email", secure: false, inputText: $email)
                    .padding(.horizontal)
                    .padding(.bottom, 7)
                
                SignupLoginInputView(imageSystemName: "person.fill", headline: "Name", textFieldPrompt: "Name", secure: false, inputText: $username)
                    .padding(.horizontal)
                    .padding(.bottom, 7)
                
                SignupLoginInputView(imageSystemName: "key.fill", headline: "Password", textFieldPrompt: "Password", secure: true, inputText: $password)
                    .padding(.horizontal)
                
                ErrorView(error: $error)
                Spacer()
                LoadingButton(text: "Sign Up", loading: $loading){
                    loading = true
                    email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    authHandler.signUpUser(email: email, password: password, username: username) { error in
                        self.error = error
                        loading = false
                    }
                }
                Spacer()
                TextButton(text: "Already have an account? Log in!"){
                    withAnimation { authHandler.state = .login }
                }
                Spacer()
            }.frame(maxWidth: 600)
        }.ignoresSafeArea(.keyboard)
    }
}

struct SignupPageGoodDesign_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignupPageGoodDesign()
            SignupPageGoodDesign()
                .previewDevice("iPhone 8")
            SignupPageGoodDesign()
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            SignupPageGoodDesign()
                .previewDevice("iPhone 8")
        }
    }
}

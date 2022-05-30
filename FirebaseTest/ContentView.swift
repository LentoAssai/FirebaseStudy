//
//  ContentView.swift
//  FirebaseTest
//
//  Created by 김승창 on 2022/05/30.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Success
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self]  result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Success
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
    
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                VStack {
                    Text("You are signed in")
                    
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .foregroundColor(.blue)
                            .padding()
                    })
                }
                
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        VStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 150, height: 150)
            
            VStack(alignment: .center) {
                TextField("email", text: $email)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color.secondary)
                
                SecureField("email", text: $password)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color.secondary)
                
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .cornerRadius(8)
                })
                
                
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
                
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Sign In")
    }
}



struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        VStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 150, height: 150)
            
            VStack(alignment: .center) {
                TextField("email", text: $email)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color.secondary)
                
                SecureField("email", text: $password)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.none)
                    .padding()
                    .background(Color.secondary)
                
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .cornerRadius(8)
                })
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Create Account")
    }
}

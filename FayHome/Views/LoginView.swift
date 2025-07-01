//
//  LoginView.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Combine
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 8) {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.58, blue: 1.0, alpha: 1.0)))
                Text("Fay")
                    .font(.manrope(.title))
            }
            
            Text("Log in")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email address")
                    .font(.manrope(.smallBodyBold))
                TextField("", text: $viewModel.email, prompt: Text("Enter email address").foregroundColor(.textSubtitle).font(.manrope(.captionMedium)))
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(8)
                    .fayLoginStroke()
                
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Password")
                        .font(.manrope(.smallBodyBold))
                    Spacer()
                }
                HStack {
                    if viewModel.isPasswordVisible {
                        TextField("", text: $viewModel.password, prompt: Text("Enter password ").foregroundColor(.textSubtitle).font(.manrope(.captionMedium)))
                            .autocapitalization(.none)
                    } else {
                        SecureField("", text: $viewModel.password, prompt: Text("Enter password ").foregroundColor(.textSubtitle).font(.manrope(.captionMedium)))
                            .autocapitalization(.none)
                    }
                    Button(action: {
                        viewModel.isPasswordVisible.toggle()
                    }) {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                    }
                }
                .padding(8)
                .fayLoginStroke()
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await AuthenticationService.shared.signin(username: viewModel.email, password: viewModel.password)
                }
            }) {
                Text("Log in")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.manrope(.smallBodyBold))
                    .fayPrimaryButton()
                    .disabled(viewModel.password.isEmpty && viewModel.email.isEmpty)
                    .opacity(viewModel.password.isEmpty && viewModel.email.isEmpty ? 0.5 : 1)
            }
        }
        .padding()
        .foregroundColor(.textBase)
    }
}

extension LoginView {
    class ViewModel: ObservableObject {
        @Published var email = ""
        @Published var password = ""
        @Published var isPasswordVisible = false
    }
}

#Preview {
    LoginView(viewModel: LoginView.ViewModel())
}

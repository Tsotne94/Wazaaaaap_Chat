//
//  Spalshview.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 23.12.24.
//

import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void 

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Wazaaaaaap")
                    .font(.custom("Pacifico-Regular", size: 48))
                    .foregroundStyle(.primaryPurple)
                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onFinish()
                }
            }
        }
    }
}



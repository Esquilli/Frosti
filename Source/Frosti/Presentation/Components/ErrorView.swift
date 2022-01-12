//
//  ErrorView.swift
//  Newsi
//
//  Created by Pedro Fernandez on 1/7/22.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .heavy))
                .padding(.bottom, 4)

            Text("Uh oh!")
                .foregroundColor(.primary)
                .font(.system(size: 30, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding(.bottom, 0)

            Text(error.localizedDescription)
                .foregroundColor(.gray)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding()

            Button(action: retryAction,
                   label: {
                        Text("Retry")
                   })
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NetworkError.unknown, retryAction: { })
    }
}

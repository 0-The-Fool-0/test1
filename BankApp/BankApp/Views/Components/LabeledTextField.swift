//
//  LabeledTextField.swift
//  BankApp
//

import SwiftUI
import Combine

struct LabeledTextField: View {
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var isSecure = false
    var accessibilityIdentifier: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .accessibilityIdentifier(accessibilityIdentifier ?? "")
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.bankFieldBorder, lineWidth: 1)
            )
        }
    }
}

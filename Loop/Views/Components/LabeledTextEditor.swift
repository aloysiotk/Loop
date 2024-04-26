//
//  LabeledTextEditor.swift
//  TrainingLogger
//
//  Created by Aloysio Tiscoski on 2/21/24.
//

import SwiftUI

struct LabeledTextEditor: View {
    var label: LocalizedStringKey
    var titleKey: LocalizedStringKey?
    var text: Binding<String>
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Text(label)
                .font(.callout)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: text)
                .placeholder(text: titleKey ?? label, visible: text.wrappedValue == "")
                .font(.subheadline)
                .frame(height: height)
                .foregroundStyle(.secondary)
        }
    }
}

struct Placeholder: ViewModifier {
    var text: LocalizedStringKey
    var visible: Bool
    

    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content
            if visible {
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 5)
                    .padding(.top, 8)
            }
        }
    }
}

extension TextEditor {
    func placeholder(text: LocalizedStringKey, visible: Bool) -> some View {
        modifier(Placeholder(text: text, visible: visible))
    }
}

#Preview {
    @State var t = ""
    return LabeledTextEditor(label: "Text", titleKey: "Placeholder", text: $t, height: 150)
}

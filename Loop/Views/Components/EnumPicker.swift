//
//  EnumPicker.swift
//  TrainingLogger
//
//  Created by Aloysio Tiscoski on 2/21/24.
//

import SwiftUI

struct EnumPicker<T: Hashable & CaseIterable & RawRepresentable>: View where T.AllCases : RandomAccessCollection, T.RawValue : StringProtocol {
    var label: String
    var selection: Binding<T>
    
    var body: some View {
        Picker(label, selection: selection) {
            ForEach(T.allCases, id: \.self) { option in
                Text(option.rawValue.capitalized).tag(option)
            }
        }
        .font(.callout)
        .fontWeight(.semibold)
        .listRowSeparator(.visible)
    }
}

#Preview {
    enum PreviewEnum: String, CaseIterable {
        case test1, test2, test3
    }
    
    @State var selection = PreviewEnum.test1
    
    return EnumPicker(label: "Preview", selection: $selection)
}

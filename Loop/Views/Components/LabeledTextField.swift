//
//  LabeledTextField.swift
//  TrainingLogger
//
//  Created by Aloysio Tiscoski on 2/21/24.
//

import SwiftUI

struct LabeledTextField<V>: View where V: LosslessStringConvertible {
    @FocusState var isFocused: Bool
    
    var label: LocalizedStringKey
    var titleKey: LocalizedStringKey?
    var value: Binding<V>
    let format: Format
    let keyboardType: UIKeyboardType?
    private var formatter: Formatter
    
    var body: some View {
        LabeledContent(label) {
            TextField(titleKey ?? label, value: value, formatter: formatter)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
                .toolbar {toolbarItemGroup()}
                .keyboardType(getKeyboardType())
                .focused($isFocused)
        }
        .font(.callout)
        .fontWeight(.semibold)
    }
    
    init(_ label: LocalizedStringKey, titleKey: LocalizedStringKey? = nil, value: Binding<V>, format: Format = .text, keyboardType: UIKeyboardType? = nil) {
        self.label = label
        self.titleKey = titleKey
        self.value = value
        self.format = format
        self.formatter = LabeledTextField.getFormatter(format: format)
        self.keyboardType = keyboardType
    }
    
    private func isEmpty() -> Bool {
        let strValue = formatter.string(for: value.wrappedValue) ?? "nil"
        
        switch format {
        case .number:
            return Double(strValue) == 0
        default:
            return strValue == ""
        }
    }
    
    private func getKeyboardType() -> UIKeyboardType {
        if let keyboardType {
            return keyboardType
        } else {
            switch format {
            case .number:
                return .decimalPad
            default:
                return .default
            }
        }
    }
    
    private func toolbarItemGroup() -> ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: .keyboard) {
            if isFocused && format == .number {
                Spacer()
                Button("Done") {isFocused = false}
                    .foregroundStyle(.blue)
            }
        }
    }
    
    private static func getFormatter(format: Format) -> Formatter {
        switch format {
        case .number:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        case .date:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        case .name:
            return PersonNameComponentsFormatter()
        case .measurement:
            return MeasurementFormatter()
        default:
            return TextFormatter()
        }
    }
    
    enum Format {
        case text
        case date
        case number
        case measurement
        case name
    }
}

class TextFormatter: Formatter {
    open override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
                return string
            }
        return nil
    }
    
    open override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject
        return true
    }
}

#Preview {
    @State var number = 0
    @State var text = ""
    return VStack {
        LabeledTextField("Number", value: $number, format: .number)
        LabeledTextField("Text", value: $text, format: .text)
    }
}

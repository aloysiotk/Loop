//
//  AlertHandler.swift
//  TicTacToe
//
//  Created by Aloysio Tiscoski on 3/14/24.
//

import Foundation
import SwiftUI


@Observable
class AlertHandler {
    private var alerts = [Alert]()
    private var responders = [AlertHandlerResponder]()
    private var firstResponder: AlertHandlerResponder? {responders.first}
    
    func showAlert(_ alert: Alert, after time: TimeInterval = 0) {
        alerts.append(alert)
        showFirstAlert(after: time)
    }
    
    @MainActor fileprivate func isShowingAlertDidChange() {
        guard let firstResponder = firstResponder else {return}
        
        if firstResponder.isShowingAlert {
            if alerts.isEmpty {
                firstResponder.isShowingAlert = false
            }
        } else {
            if alerts.count >= 1 {
                alerts.removeFirst()
                
                if !alerts.isEmpty {
                    showFirstAlert(after: 0.3)
                }
            }
        }
    }
    
    @MainActor fileprivate func alertToShow() -> Alert {
        if let alert = alerts.first {
            return alert
        } else {
            if let firstResponder {
                firstResponder.isShowingAlert = false
            }
            return Alert(title: Text(""))
        }
    }
    
    @MainActor fileprivate func addResponder(_ responder: AlertHandlerResponder) {
        removeResponder(id: responder.id)
        responders.insert(responder, at: 0)
        responder.isShowingAlert = !alerts.isEmpty
    }
    
    fileprivate func removeResponder(id: UUID) {
        responders.removeAll(where: {$0.id == id})
    }
    
    private func showFirstAlert(after time: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.firstResponder?.isShowingAlert = true
        }
    }
}

@MainActor
fileprivate class AlertHandlerResponder {
    let id: UUID
    private var _isShowingAlert: Binding<Bool>
    var isShowingAlert: Bool {
        get {_isShowingAlert.wrappedValue}
        set(newValue) {_isShowingAlert.wrappedValue = newValue}
    }
    
    init(id: UUID, isShowingAlert: Binding<Bool>) {
        self.id = id
        self._isShowingAlert = isShowingAlert
    }
}

struct Alertable: ViewModifier {
    @Environment(AlertHandler.self) private var alertHandler
    @State private var responder: AlertHandlerResponder?
    @State private var isShowingAlert = false
    
    @State var count = 0
    
    func body(content: Content) -> some View {
        content
            .onAppear {didAppear()}
            .onDisappear {didDisappear()}
            .alert(isPresented: $isShowingAlert) {alertHandler.alertToShow()}
            .onChange(of: isShowingAlert) {alertHandler.isShowingAlertDidChange()}
    }
    
    @MainActor private func didAppear() {
        responder = AlertHandlerResponder(id: UUID(), isShowingAlert: $isShowingAlert)
        alertHandler.addResponder(responder!)
    }
    
    @MainActor private func didDisappear() {
        if let responder = responder {
            alertHandler.removeResponder(id: responder.id)
        }
    }
}

extension View {
    func alertable() -> some View {
        modifier(Alertable())
    }
}

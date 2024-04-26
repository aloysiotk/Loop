//
//  NavigationPathHandler.swift
//  TrainingLogger
//
//  Created by Aloysio Tiscoski on 2/8/24.
//

import SwiftUI

@Observable
class NavigationPathHandler {
    var path: NavigationPath {didSet {save()}}
    let contextName: String?
    private let savePath: URL?
    
    init() {
        path = NavigationPath()
        contextName = nil
        savePath = nil
    }
    
    init(contextName: String) {
        self.contextName = contextName
        self.savePath = URL.documentsDirectory.appending(path: contextName + "SavedPath")
        
        if let savePath,
            let data = try? Data(contentsOf: savePath),
            let representation = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data)  {
                path = NavigationPath(representation)
        } else {
            print("Failed to retrieve navigation data")
            path = NavigationPath()
        }
    }
    
    func save() {
        guard let savePath, let representation = path.codable else { return }
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

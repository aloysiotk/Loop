//
//  GroupGridView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/17/24.
//

import SwiftUI
import SwiftData

struct GroupGridView: View {
    struct ViewConstants {
        static let gridSpacing = 20.0
    }
    
    @Binding var selection: Group?
    @Query var groups: [Group]
    
    private let columns = Array(repeating: GridItem(.flexible(minimum: 120), spacing: ViewConstants.gridSpacing), count: 2)
    
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: ViewConstants.gridSpacing) {
                ForEach(groups) { group in
                    NavigationLink(value: group) {
                        GroupView(group: group, selection: $selection)
                    }
                }
            }
            .padding(ViewConstants.gridSpacing)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .searchable(text: $searchText)
    }
    
    struct GroupView: View {
        var group: Group
        @Binding var selection: Group?
        
        private var isSelected: Bool {group.name == selection?.name}
        
        var body: some View {
            VStack {
                HStack {
                    iconView
                    Spacer()
                    taskCounterView
                }
                taskNameView
            }
            .padding()
            .frame(height: 80)
            .background(backgroundView)
            .onTapGesture {didTapGroupView()}
            .overlay {makeSwiftUIHappy}
        }
        
        private var iconView: some View {
            Circle()
                .overlay {
                    Image(systemName: group.icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(isSelected ? Color(group.color) : .white)
                        .frame(width: 20)
                    
                }
                .frame(height: 35)
                .foregroundStyle(isSelected ? .white : Color(group.color))
        }
        
        private var taskCounterView: some View {
            Text(group.tasks.count.description)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(isSelected ?  .white: Color(UIColor.label))
        }
        
        private var taskNameView: some View {
            Text(group.name)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(isSelected ? .white : Color(UIColor.secondaryLabel))
        }
        
        private var backgroundView: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color(group.color) : Color(UIColor.secondarySystemGroupedBackground))
        }
        
        //Adding a invisible list to make SwiftUI happy and handle the navigation
        private var makeSwiftUIHappy: some View {
            List(selection: $selection) {
                NavigationLink(value: group) {
                    EmptyView()
                }
            }
            .opacity(0)
        }
        
        private func didTapGroupView() {
            withAnimation {
                selection = group
            }
        }
    }
    
}



#Preview {
    @State var selection: Group? = nil
    
    return GroupGridView(selection: $selection)
        .modelContainer(MockData.previewContainer)
}

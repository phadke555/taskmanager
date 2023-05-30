//
//  ContentView.swift
//  taskmanager
//
//  Created by Rohan Phadke on 5/24/23.
//

import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    var task: String
    var isCompleted: Bool = false
}

class TodoListViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    
    func addItem(task: String) {
        let newItem = TodoItem(task: task)
        items.append(newItem)
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
    }
    
    func toggleCompletion(at index: Int) {
        items[index].isCompleted.toggle()
    }
}

struct TodoListView: View {
    @ObservedObject var viewModel = TodoListViewModel()
    @State private var newTask: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.items) { item in
                        Button(action: {
                            viewModel.toggleCompletion(at: viewModel.items.firstIndex(of: item)!)
                        }) {
                            HStack {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .primary)
                                Text(item.task)
                                    .strikethrough(item.isCompleted)
                                Spacer()
                                                            
                                Button(action: {
                                            viewModel.deleteItem(at: viewModel.items.firstIndex(of: item)!)
                                                            }) {
                                                                Image(systemName: "xmark.circle.fill")
                                                                    .foregroundColor(.red)
                                                            }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteItem(at: indexSet.first!)
                    }
                }
                .listStyle(PlainListStyle())
                
                HStack {
                    TextField("Enter task", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        viewModel.addItem(task: newTask)
                        newTask = ""
                    }) {
                        Text("Add")
                    }
                }
                .padding()
            }
            .background(Color.init(red: 0.2, green: 0.5, blue: 0.5, opacity: 0.5))
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}


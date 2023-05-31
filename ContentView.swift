//
//  ContentView.swift
//  taskmanagerplus
//
//  Created by Rohan Phadke on 5/31/23.
//


import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    var task: String
    var isCompleted: Bool = false
    var listName: String
}

class TodoListViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    var taskLists: [String] = []

    func addItem(task: String, listName: String) {
        let newItem = TodoItem(task: task, listName: listName)
        items.append(newItem)
        
        if !taskLists.contains(listName) {
            taskLists.append(listName)
        }
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
    }
    
    func toggleCompletion(at index: Int) {
        items[index].isCompleted.toggle()
    }
}

struct TaskListView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var newTask: String = ""
    let listName: String

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.items.filter({ $0.listName == listName })) { item in
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
                    viewModel.addItem(task: newTask, listName: listName)
                    newTask = ""
                }) {
                    Text("Add")
                }
            }
            .padding()
        }
        .navigationBarTitle(listName)
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var newListName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.taskLists, id: \.self) { listName in
                    NavigationLink(destination: TaskListView(viewModel: viewModel, listName: listName)) {
                        Text(listName)
                    }
                }
                
                HStack {
                    TextField("Enter new list name", text: $newListName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        viewModel.taskLists.append(newListName)
                        newListName = ""
                    }) {
                        Text("Create List")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Task Lists")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = TodoListViewModel()
    
    var body: some View {
        HomeView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

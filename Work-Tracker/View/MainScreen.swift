//
//  MainScreen.swift
//  Work-Tracker
//
//  Created by Omar Leal on 2/3/23.
//

import SwiftUI

struct MainScreen: View {
	@FetchRequest(entity: Work.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Work.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut)
	var taskes: FetchedResults<Work>
	@StateObject var taskModel: TaskerViewModel = .init()
	
	
    var body: some View {
		VStack(spacing: 0) {
			Text("Habits")
				.font(.title2)
				.frame(maxWidth: .infinity)
				.overlay(alignment: .trailing) {
					Button {
						
					} label: {
						Image(systemName: "gearshape")
							.font(.title3)
							
							
					}
				}
			
			
			//MARKIN ADD BUTTON WHEN HABITS ARE EMPTY
			ScrollView(taskes.isEmpty ? .init() : .vertical, showsIndicators: false) {
				VStack(spacing: 15) {
					// HABIT BUTTON
					Button {
						taskModel.addNewTask.toggle()
					} label: {
						Label {
							Text("Add task")
						} icon: {
							Image(systemName: "plus.circle")
						}.font(.callout.bold())
							.foregroundColor(Color("myTextColor"))
							
						
					}.padding(.top, 15)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
				}
				.padding(.vertical)
			}
		}.frame(maxHeight: .infinity, alignment: .top)
			.padding()
			.sheet(isPresented: $taskModel.addNewTask) {
				
			} content: {
				
			}
		
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}

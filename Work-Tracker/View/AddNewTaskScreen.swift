//
//  AddNewTaskView.swift
//  Work-Tracker
//
//  Created by Omar Leal on 2/4/23.
//

import SwiftUI

struct AddNewTaskView: View {
	@EnvironmentObject var taskModel: TaskerViewModel
	//MARK: Enviroment values Zone
	
    var body: some View {
		NavigationView {
			VStack(spacing: 15) {
				TextField("Task name", text: $taskModel.title)
					.padding(.horizontal)
					.padding(.vertical, 10)
					.background(Color("grayAccent").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
				
				//Task Color Picker Zone
				
				HStack(spacing: 0) {
					ForEach(taskColorPickerCollection, id: \.self) { index in
						Circle()
							.fill(Color(index))
							.frame(width: 26, height: 26)
							.overlay(content:{
								if index == taskModel.taskColor {
									Image(systemName: "circle.fill")
										.font(.callout.bold())
										.opacity(0.8)
								}
							}).onTapGesture {
								withAnimation {
									taskModel.taskColor = index
								}
							}
							.frame(maxWidth: .infinity)
						
					}
				}
				
				
			}
			.frame(maxHeight: .infinity, alignment: .top)
			.padding()
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle("Add a task")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						
					} label: {
						Image(systemName: "xmark.circle")
					}.tint(Color("myTextColor"))
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						
					} .tint(Color("myTextColor"))
				}
			}
		}
    }
}

struct AddNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskView()
			.environmentObject(TaskerViewModel())
		    .preferredColorScheme(.dark)
    }
}

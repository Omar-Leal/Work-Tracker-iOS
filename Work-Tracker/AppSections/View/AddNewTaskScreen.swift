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
							.frame(width: 32, height: 32)
							.overlay(content:{
								if index == taskModel.taskColor {
									Image(systemName: "circle.fill")
										.font(.callout.bold())
										.opacity(0.7)
								}
							}).onTapGesture {
								withAnimation {
									taskModel.taskColor = index
								}
							}
							.frame(maxWidth: .infinity)
						
					}
				}
				.padding(.vertical)
				Divider()
				
				// MARK: Frequentyl selected
				VStack(alignment: .leading, spacing: 6) {
					Text("Pick a day")
						.fontWeight(.bold)
						.frame(maxWidth: .infinity)
					let weeDays = Calendar.current.weekdaySymbols
					HStack(spacing: 10) {
						ForEach(weeDays, id: \.self) { day in
							let indexDay = taskModel.weekDays.firstIndex { getValue in
								return getValue == day
							} ?? -1
							Text(day.prefix(2))
								.font(.callout)
								.fontWeight(.heavy)
								.frame(maxWidth: .infinity)
								.padding(.vertical)
								.background {
									RoundedRectangle(cornerRadius: 25, style: .continuous)
										.fill(indexDay != -1 ? Color("tealAccent") : Color("grayAccent").opacity(0.4))
										.frame(width: 50,height: 50)
								}
								.onTapGesture {
									withAnimation(){
										if indexDay != -1 {
											taskModel.weekDays.remove(at: indexDay)
										} else {
											taskModel.weekDays.append(day)
										}
									}
								}
						}
						
						
					}
					.padding(.top, 16)
				}
				
				Divider()
					.padding(.vertical, 10)
				
				HStack {
					VStack {
						Text("Reminder")
							.fontWeight(.bold)
							.foregroundColor(Color("myTextColor"))
						
						Text("Just Notification")
							.font(.caption)
							.foregroundColor(Color("myTextColor"))
					}
					.frame(maxWidth: .infinity)
					Toggle(isOn: $taskModel.isReminderOn) {}
						.labelsHidden()
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

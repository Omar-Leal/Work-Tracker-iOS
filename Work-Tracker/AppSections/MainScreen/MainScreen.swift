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
			Text("My tasks")
				.font(.title2)
				.frame(maxWidth: .infinity)
				.overlay(alignment: .trailing) {
					Button {
						
					} label: {
						Image(systemName: "gearshape")
							.font(.title3)
							
							
					}
				}
			//@MARK ADD BUTTON WHEN HABITS ARE EMPTY
			AddHabbitButton
			
			
		}.frame(maxHeight: .infinity, alignment: .top)
			.padding()
			.sheet(isPresented: $taskModel.addNewTask) {
				//Erasing All Existing content
				taskModel.resetData()
			} content: {
				AddNewTaskView()
					.environmentObject(taskModel)
			}
		
    }
}

extension MainScreen {
	var AddHabbitButton: some View {
		ScrollView(taskes.isEmpty ? .init() : .vertical, showsIndicators: false) {
			VStack(spacing: 15) {
				// HABIT BUTTON
				
				ForEach(taskes) { task in
					TaskDetail(task: task)
				}
				
				
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
	}
}

extension MainScreen {
	@ViewBuilder
	func TaskDetail(task: Work) -> some View {
		VStack() {
			HStack() {
				Text(task.title ?? "hello omar")
					.font(.callout)
					.fontWeight(.semibold)
					.lineLimit(1)
					.padding(.top, 24)
				
				Image(systemName: "bell.badge.fill")
					.font(.callout)
					.foregroundColor(Color(task.color ?? "grayAccent"))
					.scaleEffect(0.9)
					.opacity(task.isReminderOn ? 1 : 0)
					.padding(.top, 24)
				Spacer()
				
				let count = (task.weeksDays?.count ?? 0)
				Text(count == 7 ? "Everday" : "\(count) times a week")
					.font(.caption)
					.foregroundColor(.gray)
				
			}.padding(.horizontal, 10)
				.padding(.bottom, 24)
			
			// MARK: Show current week
			// marking actived dates of task
			
			let calendar = Calendar.current
			let current = calendar.dateInterval(of: .weekOfMonth, for: Date())
			let symbol = calendar.weekdaySymbols
			let startDate = current?.start ?? Date()
			let activeWeekdays = task.weeksDays ?? []
			let activePlot = symbol.indices.compactMap { index -> (String, Date) in
				let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
			    return (symbol[index], currentDate!)
			}
			
			HStack(spacing: 0) {
				ForEach(activePlot.indices, id: \.self) { index in
					let item = activePlot[index]
					
					VStack(spacing: 6) {
						// @MARK limiting to first 3 letter
						
						Text(item.0.prefix(3))
							.font(.caption)
							.foregroundColor(.gray)
						
						
						let status = activeWeekdays.contains { day in
							return day == item.0
						}
						Text(getDate(date: item.1))
							.font(.system(size: 14))
							.fontWeight(.semibold)
							.padding(8)
							.background{
								Circle().fill(Color(task.color ?? "grayAccent"))
									.opacity(status ? 1 : 0)
							}
					}
					.frame(maxWidth: .infinity)
				}
				
				
			}
			.padding(.bottom, 24)
			
		}.background {
			RoundedRectangle(cornerRadius: 25, style: .continuous)
				.fill(Color(task.color ??
						   ""))
		}
		.onTapGesture {
			taskModel.editTask = task
			taskModel.editingTask()
			taskModel.addNewTask.toggle()
		}
	}
	
	//@MARK Formating date
	func getDate(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd"
		
		return formatter.string(from: date)
	}
	
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			
    }
}

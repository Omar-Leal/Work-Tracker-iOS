//
//  TaskerViewModel.swift
//  Work-Tracker
//
//  Created by Omar Leal on 2/4/23.
//

import SwiftUI
import CoreData
import UserNotifications

class TaskerViewModel: ObservableObject {
	//MARK: New tasks property
	@Published var addNewTask: Bool = false
	 
	@Published var title: String = ""
	@Published var taskColor: String = "orangeAccent"
	@Published var weekDays: [String] = []
	@Published var isReminderOn: Bool = false
	@Published var remainderText: String = ""
	@Published var remainderDate: Date = Date()
	@Published var editTask: Work?
	
	// MARK reminder time picker
	@Published var showTimePicker: Bool = false
	
	// @MARK: Notification access status
	@Published var notificationAccess: Bool = false
	
	func requestNotificationAccess() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
			DispatchQueue
				.main
				.async {
					self.notificationAccess = status
				}
		}
	}
	
	//@MARK:
	init() {
		requestNotificationAccess()
	}
	
	
	//@MARK: RESET TASK
	func resetData() {
		title = ""
		taskColor = "myTextColor"
		weekDays = []
		isReminderOn = false
		remainderDate = Date()
		remainderText = ""
		editTask = nil
	}
	
	
	
	// Delete task from database
	func deleteTask(context: NSManagedObjectContext) -> Bool {
		if let editTask = editTask {
			context.delete(editTask)
			if let _ = try? context.save() {
				return true
			}
		}
		
		return false
	}
	
	//@MARK : editing task
	func editingTask() {
		if let editTask = editTask {
			title = editTask.title ?? ""
			taskColor = editTask.color ?? "myTextColor"
			weekDays = editTask.weeksDays ?? []
			isReminderOn = editTask.isReminderOn 
			remainderDate = editTask.notificationData ?? Date()
			remainderText = editTask.reminderText ?? ""
			
		}
	}
	
	// @MARK: Adding task to database
	func addTask(context: NSManagedObjectContext) async -> Bool {
		let task = Work(context: context)
		task.title = title
		task.color = taskColor
		task.weeksDays = weekDays
		task.isReminderOn = isReminderOn
		task.reminderText = remainderText
		task.notificationData = remainderDate
		task.notificationID = []
		
		if isReminderOn {
			// @MARK: Scheduling Notifications
			if let ids = try? await scheduleNotification(){
				task.notificationID = ids
				if let _ = try? context.save() {
					return true
				}
			}
		} else {
			// @MARK: adding data
			if let _ = try? context.save() {
				return true
			}
		}
		
		return false
	}
	
	//@MARK: Adding notification
	func scheduleNotification() async throws -> [String] {
		let content = UNMutableNotificationContent()
		content.title = "Task Reminder"
		content.subtitle = remainderText
		content.sound = UNNotificationSound.defaultCritical
		
		//@MARK: When the notification are going to be triggered (Scheduling)
		// Schedule ID
		var notificationID: [String] = [ ]
		let calendar = Calendar.current
		let weekDaySymbol: [String] = calendar.weekdaySymbols
		
		
		for weekDay in weekDays {
			// Creating a unique ID for every single notification
			let uniqueID = UUID().uuidString
			let hours = calendar.component(.hour, from: remainderDate)
			let minutes = calendar.component(.minute, from: remainderDate)
			let day = weekDaySymbol.firstIndex { currentDay in
				return currentDay == weekDay
			} ?? -1
			
			// @MARK: Since week starts from 1 - 7
			// This add +1 to index
			if day != -1 {
				var components = DateComponents()
				components.hour = hours
				components.minute = minutes
				components.day = day + 1
				
				// @MARK: This code is triggering notification on each selected day
				let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
				
				//@MARK: Notification request
				let requestANotification = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
				
				try await UNUserNotificationCenter.current().add(requestANotification)
				notificationID.append(uniqueID)
			}
			
			
		}
		
		return notificationID
	}
	
	
	func doneStatus() -> Bool {
		let reminderStatus = isReminderOn ? remainderText == ""  : false
		if title == "" || weekDays.isEmpty || reminderStatus {
			return false
		}
	    return true
	}
	
}
    


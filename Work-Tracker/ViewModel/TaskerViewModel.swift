//
//  TaskerViewModel.swift
//  Work-Tracker
//
//  Created by Omar Leal on 2/4/23.
//

import SwiftUI
import CoreData

class TaskerViewModel: ObservableObject {
	//MARK: New tasks property
	@Published var addNewTask: Bool = false
	 
	@Published var title: String = ""
	@Published var taskColor: String = "orangeAccent"
	@Published var weekDays: [String] = []
	@Published var isReminderOn: Bool = false
	@Published var remainderText: String = ""
	@Published var remainderDate: Date = Date()
}
    


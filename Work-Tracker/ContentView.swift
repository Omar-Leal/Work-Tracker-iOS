//
//  ContentView.swift
//  Work-Tracker
//
//  Created by Omar Leal on 2/2/23.
//

import SwiftUI


struct ContentView: View {
	var body: some View {
		MainScreen()
			.preferredColorScheme(.dark)
	}
}
  


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

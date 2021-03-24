//
//  ReportView.swift
//  weg-li
//
//  Created by Malte on 24.03.21.
//  Copyright © 2021 Martin Wilhelmi. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ReportForm: View {
    struct ViewState: Equatable {
        let isPhotosValid: Bool
        let isContactValid: Bool
        
        init(state: Report) {
            isPhotosValid = !state.storedPhotos.isEmpty
            isContactValid = state.contact.isValid
        }
    }
    
    private let store: Store<Report, ReportAction>
    @ObservedObject private var viewStore: ViewStore<ViewState, ReportAction>
    
    @State private var editDescription = false

    init(store: Store<Report, ReportAction>) {
        self.store = store
        viewStore = ViewStore(store.scope(state: ViewState.init))
    }
        
    var body: some View {
        ScrollView {
            VStack {
                Widget(
                    title: Text("Fotos"), // TODO: Replace with l18n
                    isCompleted: viewStore.isPhotosValid) {
                    Images(store: store)
                }
                //                Widget(
                //                    title: Text("Ort"),
                //                    isCompleted: store.state.location.location != .zero) {
                //                    Location()
                //                }
                //                Widget(
                //                    title: Text("Beschreibung"),
                //                    isCompleted: store.state.report.isDescriptionValid) {
                //                    DescriptionWidgetView().environmentObject(self.store)
                //                }
                Widget(
                    title: Text("Persönliche Daten"),
                    isCompleted: viewStore.isContactValid) {
                    ContactWidget(store: store.scope(state: { $0.contact } ))
                }
                MailContentView()
                    .padding([.top, .bottom], 16)
            }
        }
        .padding(.bottom)
        .navigationBarTitle("Anzeige", displayMode: .inline)
        .onDisappear {
            // set nav to false
        }
    }
}

struct ReportForm_Previews: PreviewProvider {
    static var previews: some View {
        ReportForm(
            store: .init(
                initialState: .init(contact: .empty),
                reducer: .empty,
                environment: ()
            )
        )
    }
}

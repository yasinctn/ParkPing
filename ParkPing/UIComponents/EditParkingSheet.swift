//
//  EditParkingSheet.swift
//  ParkPing
//
//  Created by Yasin Cetin on 19.09.2025.
//

import SwiftUI

struct EditParkingSheet: View {
    @Binding var title: String
    @Binding var address: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(Txt.EditParking.infoSection) {
                    TextField(Txt.EditParking.titleField, text: $title)
                    TextField(Txt.EditParking.addressField, text: $address)
                }
            }
            .navigationTitle(Txt.EditParking.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Txt.Common.cancel) {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Txt.Common.save) {
                        onSave()
                    }
                }
            }
        }
    }
}



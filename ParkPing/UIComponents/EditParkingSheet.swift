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
                Section("Bilgiler") {
                    TextField("Başlık", text: $title)
                    TextField("Adres", text: $address)
                }
            }
            .navigationTitle("Düzenle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        onSave()
                    }
                }
            }
        }
    }
}



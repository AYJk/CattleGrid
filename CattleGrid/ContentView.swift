//
//  ContentView.swift
//  CattleGrid
//
//  Created by Eric Betts on 4/10/20.
//  Copyright © 2020 Eric Betts. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tagStore: TagStore

    var body: some View {
        VStack(alignment: .center) {
            Text("CattleGate").font(.largeTitle)
            if self.tagStore.lastPageWritten > 0 {
                Text(String(format: "%.2f%", progress())).font(.subheadline)
            }
            if self.tagStore.error != "" {
                Text(self.tagStore.error)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            //File selector
            NavigationView {
                List(tagStore.amiibos) { amiibo in
                    Text(amiibo.filename).onTapGesture {
                        self.tagStore.load(amiibo)
                    }
                    .foregroundColor((amiibo.path == self.tagStore.selected?.path) ? .primary : .secondary)
                }
            }
            //button to say 'go'
            Button(action: self.tagStore.scan) {
                 Image(systemName: "square.and.pencil")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .disabled(self.tagStore.selected == nil)
                .padding()
            }
            .disabled(self.tagStore.selected == nil)
        }
        .padding()
        .onAppear(perform: self.tagStore.start)
    }

    func progress() -> Float {
        return Float(tagStore.lastPageWritten) / Float(NTAG215Pages.total.rawValue) * 100
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TagStore.shared)
    }
}

//
//  StopDetailView.swift
//  TranviaZGZ
//
//  Created by Marcos on 12/12/21.
//

import SwiftUI

struct StopDetailView: View {
    let stopID : String
    
    var body: some View {
        Text(stopID)
    }
}

struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailView(stopID: "")
    }
}

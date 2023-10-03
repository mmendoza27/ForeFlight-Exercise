//
//  SwiftUIViewController.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import ComposableArchitecture
import SwiftUI
import UIKit

class SwiftUIViewController: UIHostingController<LocationsView> {
    required init?(coder aDecoder: NSCoder) {
        let appStore = Store(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        super.init(coder: aDecoder, rootView: LocationsView(store: appStore))
    }
}

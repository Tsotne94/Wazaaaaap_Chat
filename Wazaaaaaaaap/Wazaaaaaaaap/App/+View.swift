//
//  +View.swift
//  Wazaaaaaaaap
//
//  Created by nino on 12/22/24.
//

import SwiftUI

import UIKit

func getRootViewController() -> UIViewController {
    
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let root = screen.windows.first?.rootViewController else {
        fatalError("Unable to retrieve the root view controller.")
    }
    
    return root
}


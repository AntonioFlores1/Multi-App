//
//  UiView Extensions .swift
//  Multiplication App
//
//  Created by antonio  on 7/4/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

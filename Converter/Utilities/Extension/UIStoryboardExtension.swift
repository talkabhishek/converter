//
//  UIStoryboardExtension.swift
//  Converter
//
//  Created by abhisheksingh03 on 26/04/22.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
}


extension UIStoryboard {

    convenience init(_ name: Storyboard) {
        self.init(name: name.rawValue, bundle: nil)
    }

    func inflateVC<T: UIViewController>() -> T {
        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last,
            let vc = instantiateViewController(withIdentifier: name) as? T {
            return vc
        }
        fatalError("Could not find " + String(describing: T.self) + ". Perhaps you need to add the class name to the StoryboardID for that UIViewController in IB?")
    }

    func inflateVC<T: UIViewController & Injectable>(with dependencies: T.Dependencies) -> T {
        var vc: T = self.inflateVC()
        vc.dependencies = dependencies
        return vc
    }
}

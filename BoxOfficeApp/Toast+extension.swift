//
//  Toast+extension.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/8/24.
//

import UIKit
import Toast

extension UIViewController {
    func showToast() {
        var style = ToastStyle.init()
        style.backgroundColor = .systemPink
        style.titleColor = .black
        view.makeToast(nil, duration: 2, position: .top, title: "오류 발생⚠️", style: style)
    }
}

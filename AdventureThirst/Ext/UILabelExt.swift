//
//  UILabelExt.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 22.12.2024.
//

import UIKit

extension UILabel {
    func setCustomFontSize(forSubstring substring: String, toSize size: CGFloat, defaultSize: CGFloat, toWeight weigth: UIFont.Weight, defaultWeight: UIFont.Weight) {
        guard let text = text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let fullRange = NSRange(location: 0, length: text.count)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: defaultSize, weight: defaultWeight), range: fullRange)
        
        if let range = text.range(of: substring) {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: size, weight: weigth), range: nsRange)
        }
        
        self.attributedText = attributedString
    }
}

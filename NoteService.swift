//
//  NoteService.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import UIKit
import SwiftUI

class NoteService {
    
    /// Strategy: Share Sheet
    /// Presents the standard iOS Share Sheet with the text content, allowing the user to tap "Notes".
    func shareToNotes(input: TaskInput, from viewController: UIViewController) {
        let textToShare = formatNoteContent(input: input)
        
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        // iPad popover support
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityVC, animated: true, completion: nil)
    }
    
    /// Strategy: Clipboard + URL Scheme (Optional alternative)
    /// Copies text to clipboard and opens Notes app.
    func copyAndOpenNotes(input: TaskInput) {
        let text = formatNoteContent(input: input)
        UIPasteboard.general.string = text
        
        if let url = URL(string: "mobilenotes://") {
            UIApplication.shared.open(url)
        }
    }
    
    private func formatNoteContent(input: TaskInput) -> String {
        var content = "\(input.title)\n"
        content += "Category: \(input.category.rawValue)\n"
        if input.hasDueDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            content += "Due: \(formatter.string(from: input.date))\n"
        }
        content += "\n\(input.notes)"
        return content
    }
}

// Helper to find top VC for sharing
struct ShareSheetApi {
    static func share(items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Find the top-most view controller to present from
        var topController = rootVC
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = topController.view
            popoverController.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        topController.present(activityVC, animated: true)
    }
}

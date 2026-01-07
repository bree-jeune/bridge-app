//
//  HistoryView.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyManager: HistoryManager
    
    // Date formatter for display
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        List {
            if historyManager.history.isEmpty {
                Text("No recent captures.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(historyManager.history) { item in
                    HStack {
                        // Category Indicator
                        Circle()
                            .fill(Color(hex: item.categoryColorHex) ?? .gray)
                            .frame(width: 12, height: 12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.body)
                                .fontWeight(.medium)
                            
                            HStack {
                                Text(item.categoryName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("•")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(dateFormatter.string(from: item.dateCreated))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    historyManager.clearHistory()
                }) {
                    Image(systemName: "trash")
                }
                .disabled(historyManager.history.isEmpty)
            }
        }
    }
}

//
//  JudoSheets.swift
//  SwiftExampleApp
//
//  Copyright (c) 2026 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

private let cardBackground = Color(UIColor.tertiarySystemFill)

// MARK: - InfoRow

struct InfoRow: View {
    let label: String
    let value: String
    var lineLimit: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            Text(value)
                .font(.system(.body, design: .monospaced))
                .lineLimit(lineLimit)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - ErrorSheetView

struct ErrorSheetView: View {
    let message: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.12))
                            .frame(width: 120, height: 120)
                        Image(systemName: "exclamationmark.octagon.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.red)
                    }
                    .padding(.top, 8)

                    Text("JPError")
                        .font(.title2.bold())

                    Text(message)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(cardBackground))
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Done").fontWeight(.semibold)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

}

// MARK: - ResultSheetView

struct ResultSheetView: View {
    let result: Result
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.12))
                            .frame(width: 120, height: 120)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.top, 8)

                    Text(result.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    resultCards
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Done").fontWeight(.semibold)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    private var resultCards: some View {
        contentCards(for: result)
    }

    // AnyView is required here to allow recursion — the compiler cannot resolve
    // a self-referential `some View` opaque return type.
    private func contentCards(for result: Result) -> AnyView {
        let flat = result.items.filter { $0.subResult == nil && !$0.value.isEmpty }
        let nested = result.items.filter { $0.subResult != nil }

        return AnyView(VStack(spacing: 16) {
            if !flat.isEmpty {
                infoCard(flat)
            }
            ForEach(nested.indices, id: \.self) { idx in
                if let sub = nested[idx].subResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(nested[idx].title.uppercased())
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                            .padding(.horizontal, 4)
                        contentCards(for: sub)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        })
    }

    private func infoCard(_ items: [ResultItem]) -> some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { idx in
                if idx > 0 { Divider().padding(.leading, 16) }
                InfoRow(label: items[idx].title, value: items[idx].value)
            }
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(cardBackground))
    }
}

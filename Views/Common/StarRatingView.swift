import SwiftUI

struct StarRatingView: View {
    let rating: Double // 0...5 (supports halves)
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                let starValue = Double(index) + 1
                star(for: starValue)
                    .foregroundColor(.yellow)
            }
            Text(String(format: "%.1f", rating))
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
    }
    
    @ViewBuilder
    private func star(for value: Double) -> some View {
        if rating >= value {
            Image(systemName: "star.fill")
        } else if rating + 0.5 >= value {
            Image(systemName: "star.leadinghalf.filled")
        } else {
            Image(systemName: "star")
        }
    }
}



import SwiftUI

struct PatternTableView: View {
    let headers: (String, String, String)
    let rows: [PatternRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(headers.0).bold().frame(width: 220, alignment: .leading)
                Text(headers.1).bold().frame(maxWidth: .infinity, alignment: .leading)
                Text(headers.2).bold().frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.bottom, 8)

            Divider()

            ForEach(rows) { row in
                HStack(alignment: .top) {
                    Text(row.left).frame(width: 220, alignment: .leading)
                    Text(row.middle).frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.right).frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.callout)
                .padding(.vertical, 8)
                Divider()
            }
        }
        .padding(14)
        .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
    }
}

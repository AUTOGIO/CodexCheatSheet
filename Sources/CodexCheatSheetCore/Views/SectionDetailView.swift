import SwiftUI

struct SectionDetailView: View {
    let section: CheatSection

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: section.icon)
                        .font(.title2)
                    Text(section.title)
                        .font(.title2).bold()
                }
                Text(section.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)

                if let headers = section.tableHeaders, !section.rows.isEmpty {
                    PatternTableView(headers: headers, rows: section.rows)
                }

                if !section.bullets.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(section.bullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                Text(bullet)
                            }
                        }
                    }
                    .padding(14)
                    .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
                }

                ForEach(section.templates) { template in
                    TemplateCardView(template: template)
                }
            }
            .padding(24)
        }
    }
}

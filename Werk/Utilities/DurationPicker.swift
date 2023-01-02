import SwiftUI

struct DurationPicker<Tag: Hashable>: View  {
    let columns: [Column]
    var selections: [Binding<Tag>]
    
    init?(columns: [Column], selections: [Binding<Tag>]) {
        guard !columns.isEmpty && columns.count == selections.count else {
            return nil
        }
        
        self.columns = columns
        self.selections = selections
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0 ..< columns.count) { index in
                    let column = columns[index]
                    ZStack(alignment: Alignment.init(horizontal: .customCenter, vertical: .center)) {
                        if (!column.label.isEmpty && !column.options.isEmpty) {
                            HStack {
                                Text(verbatim: column.options.last!.text)
                                    .foregroundColor(.clear)
                                    .alignmentGuide(.customCenter) { $0[HorizontalAlignment.center] }
                                Text(column.label)
                            }
                        }
                        Picker(column.label, selection: selections[index]) {
                            ForEach(column.options, id: \.tag) { option in
                                Text(verbatim: option.text).tag(option.tag)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width / CGFloat(columns.count), height: geometry.size.height)
                        .clipped()
                    }
                    
                }
            }
        }
    }
}

extension DurationPicker {
    struct Column {
        struct Option {
            var text: String
            var tag: Tag
        }
        
        var label: String
        var options: [Option]
    }
}

private extension HorizontalAlignment {
    enum CustomCenter: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat { context[HorizontalAlignment.center] }
    }
    
    static let customCenter = Self(CustomCenter.self)
}

struct DurationPicker_Previews: PreviewProvider {
    static var columns = [
        DurationPicker.Column(label: "h", options: Array(0...23).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
        DurationPicker.Column(label: "min", options: Array(0...59).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
        DurationPicker.Column(label: "sec", options: Array(0...59).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
    ]
    
    static var selection1: Int = 23
    static var selection2: Int = 59
    static var selection3: Int = 59
    
    static var previews: some View {
        DurationPicker(columns: columns, selections: [.constant(selection1), .constant(selection2), .constant(selection3)]).frame(height: 300).previewLayout(.sizeThatFits)
    }
}


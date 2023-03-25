// ASCIITable+ResultBuilder.swift

import Foundation

@resultBuilder
public enum TerminalDisplayElementsBuilder {
    
    // MARK: - Public Properties
    
    public typealias Component = [TerminalRepresentable]
    public typealias Expression = TerminalRepresentable

    // MARK: - Public Methods
    
    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { (tds: [TerminalRepresentable]) -> [TerminalRepresentable] in
            tds.flatMap { td -> [TerminalRepresentable] in
                switch td {
                case let iterator as Contentiterator:
                    return iterator.content
                default:
                    return [td]
                }
            }
        }
    }

    public static func buildBlock(_ components: Expression...) -> Component {
        components.flatMap { td -> [TerminalRepresentable] in
            switch td {
            case let forEach as Contentiterator:
                return forEach.content
            default:
                return [td]
            }
        }
    }

    public static func buildBlock() -> Component {
        []
    }

    public static func buildExpression(_ expression: Expression) -> TerminalDisplayElementsBuilder.Component {
        [expression]
    }

    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }
    
}

public struct Contentiterator: TerminalRepresentable {
    var content: [TerminalRepresentable]

    public init<Source: Sequence>(_ source: Source, @ForEachBuilder content: (Source.Element) -> [TerminalRepresentable]) {
        self.content = source.flatMap(content)
    }

    public var stringValue: String { "" }
}

// MARK: - ForEachBuilder

@resultBuilder public enum ForEachBuilder {
    
    public static func buildBlock(_ components: TerminalRepresentable...) -> [TerminalRepresentable] {
        components
    }
    
}

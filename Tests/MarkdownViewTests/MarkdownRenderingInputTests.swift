import Markdown
import SwiftUI
import Testing

@testable import MarkdownView

@Suite("Markdown Rendering Input")
struct MarkdownRenderingInputTests {
    @Test("Bare URLs are parsed as autolinks")
    func parsesBareURLsAsAutolinks() throws {
        let document = Document(parsing: "Visit https://example.com today")
        let paragraph = try #require(document.child(at: 0) as? Paragraph)
        let link = try #require(paragraph.children.first { $0 is Markdown.Link } as? Markdown.Link)

        #expect(link.destination == "https://example.com")
    }

    @Test(
        "Configures block directive parsing from rendering inputs",
        .tags(.rendering, .blockDirectives),
        arguments: BlockDirectiveParsingCase.allCases
    )
    func configuresBlockDirectiveParsing(testCase: BlockDirectiveParsingCase) {
        let request = MarkdownParseRequest(
            sourceText: "@Note()",
            mathContext: testCase.mathContext,
            elementRenderers: testCase.elementRenderers
        )
        let parseResult = MarkdownDocumentParser.parse(request)

        #expect(
            request.parsingOptions.contains(.parsesBlockDirectives) == testCase.expectsBlockDirectiveParsing
        )
        let firstChild = Array(parseResult.document.children).first

        switch testCase {
        case .mathRenderingOnly:
            #expect(firstChild is Markdown.Paragraph)
        case .customBlockDirectiveRenderer:
            #expect(firstChild is Markdown.BlockDirective)
        }
    }

    enum BlockDirectiveParsingCase: CaseIterable {
        case mathRenderingOnly
        case customBlockDirectiveRenderer

        var mathContext: MarkdownMathContext? {
            switch self {
            case .mathRenderingOnly:
                MarkdownMathContext()
            case .customBlockDirectiveRenderer:
                nil
            }
        }

        var elementRenderers: [MarkdownElementRendererRegistration] {
            switch self {
            case .mathRenderingOnly:
                []
            case .customBlockDirectiveRenderer:
                [
                    .blockDirective(
                        MarkdownViewTestSupport.BlockDirectiveRendererStub(),
                        name: "Note"
                    )
                ]
            }
        }

        var expectsBlockDirectiveParsing: Bool {
            switch self {
            case .mathRenderingOnly:
                false
            case .customBlockDirectiveRenderer:
                true
            }
        }
    }
}

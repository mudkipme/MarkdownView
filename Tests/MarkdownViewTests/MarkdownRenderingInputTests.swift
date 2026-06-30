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

    @Test("Math rendering alone does not enable block directive parsing")
    func mathRenderingAloneDoesNotEnableBlockDirectiveParsing() {
        let request = MarkdownParseRequest(
            sourceText: "@Note()",
            mathContext: MarkdownMathContext(),
            elementRenderers: []
        )
        let parseResult = MarkdownDocumentParser.parse(request)

        #expect(request.parsingOptions.contains(.parsesBlockDirectives) == false)
        #expect(Array(parseResult.document.children).first is Markdown.Paragraph)
    }

    @Test("Custom block directive renderers enable block directive parsing")
    func customBlockDirectiveRenderersEnableBlockDirectiveParsing() {
        let request = MarkdownParseRequest(
            sourceText: "@Note()",
            mathContext: nil,
            elementRenderers: [
                .blockDirective(TestBlockDirectiveRenderer(), name: "Note")
            ]
        )
        let parseResult = MarkdownDocumentParser.parse(request)

        #expect(request.parsingOptions.contains(.parsesBlockDirectives))
        #expect(Array(parseResult.document.children).first is Markdown.BlockDirective)
    }
}

private struct TestBlockDirectiveRenderer: MarkdownBlockDirectiveRenderer {
    func makeBody(configuration: MarkdownBlockDirectiveRendererConfiguration) -> some View {
        EmptyView()
    }
}

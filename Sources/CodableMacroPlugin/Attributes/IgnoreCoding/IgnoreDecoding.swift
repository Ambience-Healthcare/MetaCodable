@_implementationOnly import SwiftDiagnostics
@_implementationOnly import SwiftSyntax
@_implementationOnly import SwiftSyntaxMacros

/// Attribute type for `IgnoreDecoding` macro-attribute.
///
/// This type can validate`IgnoreDecoding` macro-attribute
/// usage and extract data for `Codable` macro to
/// generate implementation.
struct IgnoreDecoding: PropertyAttribute {
    /// The node syntax provided
    /// during initialization.
    let node: AttributeSyntax

    /// Creates a new instance with the provided node.
    ///
    /// The initializer fails to create new instance if the name
    /// of the provided node is different than this attribute.
    ///
    /// - Parameter node: The attribute syntax to create with.
    /// - Returns: Newly created attribute instance.
    init?(from node: AttributeSyntax) {
        guard
            node.attributeName.as(IdentifierTypeSyntax.self)!
                .description == Self.name
        else { return nil }
        self.node = node
    }

    /// Builds diagnoser that can validate this macro attached declaration.
    ///
    /// The following conditions are checked by the built diagnoser:
    /// * Attached declaration is a variable or enum case declaration.
    /// * Attached variable declaration has default initialization or
    ///   variable is a computed property.
    /// * Additionally, warning generated if macro usage is duplicated
    ///   for the same declaration.
    /// * Additionally, warning also generated if this attribute is used
    ///   combined with `IgnoreCoding` attribute.
    ///
    /// - Returns: The built diagnoser instance.
    func diagnoser() -> DiagnosticProducer {
        return AggregatedDiagnosticProducer {
            shouldNotDuplicate()
            shouldNotBeCombined(with: IgnoreCoding.self)
            `if`(
                isVariable, attachedToInitializedVariable(),
                else: expect(syntaxes: EnumCaseDeclSyntax.self)
            )
        }
    }
}

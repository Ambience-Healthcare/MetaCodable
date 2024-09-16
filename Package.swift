// swift-tools-version: 5.10

import CompilerPluginSupport
import Foundation
import PackageDescription

let package = Package(
    name: "MetaCodable",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    products: [
        .library(name: "MetaCodable", targets: ["MetaCodable"]),
        .library(name: "HelperCoders", targets: ["HelperCoders"]),
        .plugin(name: "MetaProtocolCodable", targets: ["MetaProtocolCodable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.1.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
        .package(url: "https://github.com/apple/swift-format", from: "509.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // MARK: Core

        .target(
            name: "PluginCore",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                "MCOrderedCollections",
            ]
        ),
        .target(
            name: "MCOrderedCollections",
            dependencies: ["MCInternalCollectionsUtilities"],
            exclude: ["CMakeLists.txt"]
        ),
        .target(
            name: "MCInternalCollectionsUtilities",
            exclude: [
                "CMakeLists.txt",
                "Compatibility/UnsafeMutableBufferPointer+SE-0370.swift.gyb",
                "Compatibility/UnsafeMutablePointer+SE-0370.swift.gyb",
                "Compatibility/UnsafeRawPointer extensions.swift.gyb",
                "Debugging.swift.gyb",
                "Descriptions.swift.gyb",
                "IntegerTricks/FixedWidthInteger+roundUpToPowerOfTwo.swift.gyb",
                "IntegerTricks/Integer rank.swift.gyb",
                "IntegerTricks/UInt+first and last set bit.swift.gyb",
                "IntegerTricks/UInt+reversed.swift.gyb",
                "RandomAccessCollection+Offsets.swift.gyb",
                "Specialize.swift.gyb",
                "UnsafeBitSet/_UnsafeBitSet+Index.swift.gyb",
                "UnsafeBitSet/_UnsafeBitSet+_Word.swift.gyb",
                "UnsafeBitSet/_UnsafeBitSet.swift.gyb",
                "UnsafeBufferPointer+Extras.swift.gyb",
                "UnsafeMutableBufferPointer+Extras.swift.gyb",
            ]
        ),

        // MARK: Macro

        .macro(
            name: "MacroPlugin",
            dependencies: [
                "PluginCore",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "MetaCodable", dependencies: ["MacroPlugin"]),
        .target(name: "HelperCoders", dependencies: ["MetaCodable"]),

        // MARK: Build Tool

        .executableTarget(
            name: "ProtocolGen",
            dependencies: [
                "PluginCore", "MetaCodable",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
            ]
        ),
        .plugin(
            name: "MetaProtocolCodable", capability: .buildTool(),
            dependencies: ["ProtocolGen"]
        ),

        // MARK: Test

        .testTarget(
            name: "MetaCodableTests",
            dependencies: [
                "PluginCore", "MacroPlugin", "MetaCodable", "HelperCoders",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            plugins: ["MetaProtocolCodable"]
        ),
    ]
)

extension Package.Dependency.Kind {
    var repoName: String? {
        guard
            case let .sourceControl(
                name: _, location: location, requirement: _
            ) = self,
            let location = URL(string: location),
            let name = location.lastPathComponent.split(separator: ".").first
        else { return nil }
        return String(name)
    }
}

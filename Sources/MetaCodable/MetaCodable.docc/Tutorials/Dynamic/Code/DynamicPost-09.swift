import MetaCodable

@Codable
@CodedAt("type")
@ContentAt("content")
protocol Post {
    var id: UUID { get }
}

@IgnoreCoding
struct InvalidPost: Post {
    let id: UUID
    let invalid: Bool
}

@Codable
struct TextPost: Post, DynamicCodable {
    static var identifier:
        DynamicCodableIdentifier<String>
    {
        return "text"
    }

    let id: UUID
    let text: String
}

@Codable
struct PicturePost: Post, DynamicCodable {
    static var identifier:
        DynamicCodableIdentifier<String>
    {
        return ["picture", "photo"]
    }

    let id: UUID
    let url: URL
    let caption: String
}

@Codable
struct AudioPost: Post, DynamicCodable {
    static var identifier:
        DynamicCodableIdentifier<String>
    {
        return "audio"
    }

    let id: UUID
    let url: URL
    let duration: Int
}

@Codable
struct VideoPost: Post, DynamicCodable {
    static var identifier:
        DynamicCodableIdentifier<String>
    {
        return "video"
    }

    let id: UUID
    let url: URL
    let duration: Int
    let thumbnail: URL
}

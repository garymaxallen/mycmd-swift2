// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "MySwift",
  products: [
    .executable(name: "MySwift", targets: ["MySwift"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "1.0.1")),
  ],
  targets: [
    .executableTarget(
      name: "MySwift",
      dependencies: [
        .target(name: "MyC"),
        .product(name: "Crypto", package: "swift-crypto"),
      ]
    ),
    .target(
      name: "MyC"
    ),
  ]
)

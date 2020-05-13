// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftReduce",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "SwiftReduce",
      targets: ["SwiftReduce"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/wickwirew/Runtime.git", from: "2.1.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "SwiftReduce",
      dependencies: ["Runtime"]),
    .testTarget(
      name: "SwiftReduceTests",
      dependencies: ["SwiftReduce"]),
  ]
)

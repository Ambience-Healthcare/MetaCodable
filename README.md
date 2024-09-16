# MetaCodable

Forked from [SwiftyLab/MetaCodable](https://github.com/SwiftyLab/MetaCodable). Context at [swift-collections-archive-failure-mac-catalyst](https://github.com/adam-zethraeus/swift-collections-archive-failure-mac-catalyst).


> # swift-collections/MetaCodable MacCatalyst archive failure
> MetaCodable's import of swift-collections MacCatalyst archive build to fail with the following error on Xcode 16 RC1 and 16.1 beta, building in Swift 5 language mode.
> ```
> Showing All Errors Only
> Prepare build
> error: Multiple commands produce '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/InternalCollectionsUtilities.o'
>     note: Target 'InternalCollectionsUtilities' (project 'swift-collections') has a command with output '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/InternalCollectionsUtilities.o'
    >     note: Target 'InternalCollectionsUtilities' (project 'swift-collections') has a command with output '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/InternalCollectionsUtilities.o'
    > error: Multiple commands produce '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/OrderedCollections.o'
>     note: Target 'OrderedCollections' (project 'swift-collections') has a command with output '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/OrderedCollections.o'
    >     note: Target 'OrderedCollections' (project 'swift-collections') has a command with output '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/OrderedCollections.o'
    > Multiple commands produce '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/InternalCollectionsUtilities.o'
> Multiple commands produce '/Users/adamz/Developer/voidapp/void/DerivedData/Void/Build/Intermediates.noindex/ArchiveIntermediates/Void/IntermediateBuildFilesPath/UninstalledProducts/macosx/OrderedCollections.o'
> Build failed    9/16/24, 00:46    1.3 seconds
> ```
> ## Issues
> Root cause unknown. An Xcode build fails to deduplicate `MetaCodable`'s `swift-collections` symbols with those imported by other targets in the repo.
> ## Fix
> In this reproduction repo the archival failure is fixed by:
> * Copying `MetaCodable` into a dedicated local SPM package.
> * Copying the parts of `swift-collections` used by `MetaCodable` into its SPM package.
> * Renaming the copied `InternalCollectionsUtilities` and `OrderedCollections` targets with an `MC` prefix to prevent package graph conflicts.
> * Replacing occurrences of the renamed symbols with their updates.
> * Resolving warnings about the unsafe runtime use of `@_implementationOnly` in the copied `swift-collections` files (`OrderedCollections` when importing `InternalCollectionsUtilities`) by removing their use and using plain imports.
> The issue and fix can be reproduced by swapping from/to the local version of `MetaCodable` in this repo's `Package.swift`.

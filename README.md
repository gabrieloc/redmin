![redmin](banner.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Prototyping something and need realistic user generated content? Redmin is a really simple wrapper for accessing the main parts of Reddit which don't require authentication or an API token. For now, only the most basic parts of comments and posts are modelled but more will be added in the future.

Resources are accessed through `Endpoint` objects which contain model and networking info. For example, to pull down posts from a listing (hot, top, random, etc), use the `PostsEndpoint`:

```swift
PostsEndpoint.hot.request { response in
  switch (response) {
    case .success(let posts):
       // Do something with posts
    case .failure(let error):
      // handle error
  }
}
```

For requests or suggestions, you can find me at [@_gabrieloc](https://twitter.com/_gabrieloc).

![redmin](banner.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Prototyping something and need realistic user generated content? Redmin is a really simple wrapper for accessing the main parts of Reddit which don't require authentication or an API token. For now, only the most basic parts of comments and posts are modelled but more will be added in the future.

You can choose how granular to get with what's sent and received. For example, to pull down 50 posts from the `r/gifs` subreddit, you can use a convenience defined in `Conveniences.swift`:

```swift
50.postsFromSubreddit("gifs") { posts in 
  // do something with your posts
}
```

Or, if you want more control over when to make the request, or want it to be cancellable:
```swift
let endpoint = PostsEndpoint(subreddit: "gifs", category: .top, limit: 50)
let task: URLSessionDataTask = endpoint.request { posts in
 // do something with your posts
}
```

`Post` objects can be used to get images and comments. For example, given a `post`:
```swift
post.bestPreviewImage.request { image in 
  // send image (UIImage) to an UIImageView
}
50.comments(from: post) { comments in
  // populate a tableView with an array of comment objects
}
```


For requests or suggestions, you can find me at [@_gabrieloc](https://twitter.com/_gabrieloc).

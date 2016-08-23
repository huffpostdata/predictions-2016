'use strict'

function x_or_default(x, d) {
  return x === undefined ? d : x
}

// See `doc/google-docs-and-meta.md`
module.exports = class PageMetadata {
  constructor(slug, o) {
    this.slug = slug
    this.url_route = slug

    // required meta tags
    this.hed = x_or_default(o.hed, 'hed TK')
    this.dek = x_or_default(o.dek, 'dek TD')
    this.author_html = x_or_default(o.author_html, 'author TK')
    this.twitter_author = x_or_default(o.twitter_author, '@authorTK')
    this.date_published = x_or_default(o.date_published, 'Tk, Tk TK, TKTK')

    // suggested meta tags
    this.title = x_or_default(o.title, this.hed)
    this.header_image = x_or_default(o.header_image, `${slug}-header.jpg`)
    this.header_caption = x_or_default(o.header_caption, null)
    this.header_credit = x_or_default(o.header_credit, null)
    this.social_image = x_or_default(o.social_image, `${slug}-social.jpg`)
    this.social_title = x_or_default(o.social_title, this.title)
    this.description = x_or_default(o.description, this.dek)
    this.suggested_tweet = x_or_default(o.suggested_tweet, this.hed)
    this.date_updated = o.date_updated || null
    this.related_header = o.related_header || null

    // nitpicky meta tags
    this.facebook_description = x_or_default(o.facebook_description, this.description)
    this.facebook_image = x_or_default(o.facebook_image, this.social_image)
    this.facebook_title = x_or_default(o.facebook_title, this.social_title)
    this.twitter_description = x_or_default(o.twitter_description, this.description)
    this.twitter_image = x_or_default(o.twitter_image, this.social_image)
    this.twitter_title = x_or_default(o.twitter_title, this.social_title)
  }
}

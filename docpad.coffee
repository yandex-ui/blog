# DocPad Configuration File
# http://docpad.org/docs/config

docpadConfig = {
    plugins:
        stylus:
            stylusLibraries:
                nib: false
            stylusOptions:
                'include css': true

    events:
        renderBefore: () ->
            # Rewrite `pages/` to the root and `posts/` to the `blog/`.
            this.docpad.getCollection('html').forEach (page) ->
                newOutPath = page.get('outPath')
                newUrl = page.get('url')

                dateMatch = page.attributes.basename.match(/^([0-9]{4}-[0-9]{2}-[0-9]{2})-/);
                if dateMatch
                    newUrl = newUrl.replace(dateMatch[1] + '-', '')
                    newOutPath = newOutPath.replace(dateMatch[1] + '-', '')

                if newUrl.indexOf('index.html') == -1
                    newUrl = newUrl.replace('.html', '/')
                    newOutPath = newOutPath.replace('.html', '/index.html')

                page
                    .set('outPath', newOutPath)
                    .setUrl(newUrl)
                    .setMetaDefaults({
                        layout: page.attributes.layout || 'archive',
                        date: dateMatch && dateMatch[1]
                    })

}

# Export the DocPad Configuration
module.exports = docpadConfig
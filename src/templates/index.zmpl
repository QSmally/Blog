<article class="two-column">
    <section class="content">
        <a class="text-section" href="/home">Smally's blog</a>

        <p>
        This is my blog where I occasionally post interesting stuff, random
        thoughts, and projects that I make.
        </p>

        <p>
        This server hosted on the Internet also aims to mirror all the
        documentation that I reference within a blog post, such as
        datasheets. All rights are reserved to the original authors and all
        that stuff. For my original work, I'd appreciate that information taken
        from me will be cited to their respective blog post.
        </p>

        <p>
        I don't use LLMs/AI tools to produce my work.
        </p>

        <p>
        The repository of this blog is maintained on <a href="/mirror">GitHub</a>.
        </p>

        <p class="text-subsection">Posts</p>

        <ul>
            @zig {
                for (@TypeOf(context).posts) |post| {
                    if (post.visibility == .invisible)
                        continue;
                    <li>
                        <a href="/{{post.path}}"><code>{{post.created}} </code> {{post.title}}</a>
                    </li>
                }
            }
        </ul>
    </section>

    <div class="sidebar list">
        <div class="text-tiny-section">Featured</div>

        @zig {
            for (@TypeOf(context).posts) |post| {
                if (post.visibility != .featured)
                    continue;
                <div class="two-column">
                    <div class="context">
                        <a class="text-subsection" href="/{{post.path}}">{{post.name}}</a>
                        <div class="text-subtext">{{post.title}}</div>
                        <div class="text-subtext">{{post.created}}</div>
                        <p>{{post.description}}</p>
                    </div>
                    if (post.thumbnail.len > 0) {
                        <a href="/{{post.path}}"><img class="thumbnail" src="/{{post.thumbnail}}" alt="{{post.title}}"/></a>
                    }
                </div>
            }
        }
    </div>
</article>

<div class="two-column">
    <div class="content">
        <a class="text-section" href="/home">Smally's blog</a>

        <p>
            This is a blog stream page that I try to maintain. I'm using
            <a href="https://github.com/jetzig-framework/zmpl">Zmpl</a> for
            templating with Zig. Posts that I create are shown on the sidebar
            or below depending on the size of your viewport. For some posts,
            new things and updates will be added which is (probably) mentioned
            at the start of the post.
        </p>

        <p>
            This server also aims to include all the files I reference,
            such as datasheets, if licensing allows for distribution.
            In that case, all rights are reserved to the people and all
            that. I'd appreciate it that information or pictures from
            me will be cited to their respective hyperlinks.
        </p>

        <p>
            The repository of this blog is maintained on <a href="/mirror">Github</a>.
        </p>
    </div>

    <div class="sidebar list">
        <div class="text-tiny-section">Posts</div>

        @for ($.posts) |post| {
            <div class="two-column">
                <div class="context">
                    <a class="text-subsection" href="/{{post.path}}">{{post.name}}</a>
                    <div class="text-subtext">{{post.title}}</div>
                    <div class="text-subtext">{{post.last_change}}</div>
                    <p>{{post.description}}</p>
                </div>
                @if (post.get("thumbnail")) |thumbnail|
                    @if (thumbnail != "")
                        <img class="thumbnail" src="/{{thumbnail}}" alt="{{post.title}}"/>
                    @end
                @end
            </div>
        }
    </div>
</div>

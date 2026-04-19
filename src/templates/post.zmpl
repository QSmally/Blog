
<div class="spacer"></div>

<div class="text-section">{{context.title}}</div>

<div class="text-subsection"><small>&larr;</small> <a href="/">Home</a></div>

<div>
    <div class="text-subtext">created: {{context.created}}</div>
    @if (!std.mem.eql(u8, context.last_change, context.created))
        <div class="text-subtext">last change: {{context.last_change}}</div>
    @end
</div>

{{zmpl.fmt.raw(zmpl.get("content"))}}

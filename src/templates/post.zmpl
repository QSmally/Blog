
<div class="spacer"></div>

<div class="text-section">{{context.manifest.title}}</div>

<div class="text-subsection"><small>&larr;</small> <a href="/">Home</a></div>

<div>
    <div class="text-subtext">created: {{context.manifest.created}}</div>
    @if (context.manifest.last_change) |last_change|
        <div class="text-subtext">last change: {{last_change}}</div>
    @end
</div>

<!-- BEGIN SIGNED MESSAGE -->
{{zmpl.fmt.raw(zmpl.get("content"))}}
<!-- END SIGNED MESSAGE -->

@if (context.manifest.changelog.len > 0)
    <div class="content underlined">
        <hr/>

        <p class="text-subtext">Notable changes since publication</p>

        <ul>
            @zig {
                for (context.manifest.changelog) |change| {
                    <li><code>{{change.date}} </code> {{zmpl.fmt.raw(change.description)}}</li>
                }
            }
        </ul>
    </div>
@end

@if (zmpl.get("signature")) |signature|
    <div class="content underlined">
        <hr/>

        <p class="text-subtext">Signature of this blog post</p>

        <p>
        This text was written by Joey Smalen, signed with this <a href="/privacy">PGP public key</a>, and verified at start-up.
        </p>

        <pre>
        <code>
{{signature}}
        </code>
        </pre>
    </div>
@end

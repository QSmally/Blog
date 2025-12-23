
<!--
    © Joey Smalen. All rights reserved.
-->

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, viewport-fit=cover"/>

    <title>Blog - {{context.title}}</title>
    <link rel="icon" href="/favicon.ico" type="image/x-icon"/>
    <link rel="shortcut icon" href="/favicon.ico" type="img/x-icon"/>

    <link href="/styling.css" rel="stylesheet" type="text/css"/>

    <meta property="title"       content="Blog - {{context.title}}"/>
    <meta property="description" content="{{context.description}}"/>
    <meta name="keywords"        content="qsmally, joey, smalen"/>
    <meta name="author"          content="© Joey Smalen"/>
</head>
<body>

<!-- Page content -->
<main>
    <div class="container">
        {{zmpl.content}}
    </div>
</main>

<!-- Footer -->
<footer>
    <div class="entity-bold">
        <a href="/privacy">&copy; <span id="year"></span> Joey Smalen</a>
    </div>
</footer>

<!-- Dynamic year -->
<script>
    document.getElementById("year").innerText = new Date().getFullYear();
</script>

</body>
</html>

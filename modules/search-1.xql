xquery version "3.1";

declare option exist:serialize "method=xhtml media-type=text/html";
declare variable $page-title := "Search results with XQuery";
declare variable $search := request:get-parameter("search", ());


<html>
    <head>
        <meta HTTP-EQUIV="Content-Type" content="text/html; charset=UTF-8"/>
        <title>{$page-title}</title>
    </head>
    <body>
    <a href="movie-home.xqm">Home</a>
    <p>Search Phrase: "{$search}"</p>
    <ul>
        {
            for $movie in collection("/db/apps/movies/data")//movie/title[contains(., $search)] 
            return 
                <li>
                    {string($movie)}
                </li>
        }
        </ul>
    </body>
</html>
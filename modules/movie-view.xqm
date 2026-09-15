xquery version "3.1";



declare option exist:serialize "method=xhtml media-type=text/html";
declare variable $movie-uri := request:get-parameter("uri", ());


let $movie := doc($movie-uri) 
let $page-title := string($movie//title)
let $revenue := string($movie//revenue)
return 
    <html>
        <head>
            <meta HTTP-EQUIV="Content-Type" content="text/html; charset=UTF-8"/>
            <title>{$page-title}</title>
        </head>
        <body>
            <h1>{$page-title}</h1>
            <h3>Revenue: {$revenue}</h3>


            <ul>
            {
                for $actor in $movie//actor
                return 

                    <li>
                    {string($actor)}
                    </li>
            }
            </ul>

        </body>
    </html>
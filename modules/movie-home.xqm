
xquery version "3.1";

import module namespace x101log = "http://www.exist-db.org/book/namespaces/exist101" at "log.xqm";
declare option exist:serialize "method=xhtml media-type=text/html";
declare variable $page-title := "Movies";

x101log:add-log-message("Visted movie home"),
let $movies :=  
  <movies>
  {
  for $movie in collection("/db/apps/movies/data")//movie
    let $name := util:unescape-uri(replace(base-uri($movie), ".+/(.+)$", "$1"), "UTF-8")
    return
      <movie uri="{base-uri($movie)}" name="{$name}">
        {$movie/*}
      </movie>
  }
  </movies>
return 
  <html>
    <head>
      <meta HTTP-EQUIV="Content-Type" content="text/html; charset=UTF-8"/>
      <title>{$page-title}</title>
    </head>
    <body>
      <form method="POST" action="search-2.xql">
        <input type="text" name="search" size="40"/>
        <input type="submit" value="Search!!!"/>
      </form>

      
      <ul>
        {
          for $movie in $movies/movie
          return
            <li>
              <h3>{string($movie/title/text())}</h3>
              <ul>
              {
                for $actor in $movie/cast/actor
                return
                  <li>{string($actor/text())}</li>
              }
              </ul>
              <a href="movie-view.xqm?uri={$movie/@uri}">page</a>
            </li>
        }
      </ul>
    </body>
  </html>
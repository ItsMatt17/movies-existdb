xquery version "3.1";

declare option exist:serialize "method=xhtml media-type=text/html";
declare variable $page-title := "Search #4";

declare function local:search($query as xs:string? ){
  if (not($query)) then ()
  else 
    for $match in collection("/db/apps/movies/data")//movie/title[ft:query(., $query)]
    let $movie := $match/ancestor::movie
    return 
      <li>
        <h3>{$movie//title/text()}</h3>
        <p>{$movie//revenue}</p>
        <ul>
        { 
          for $actor in $movie//cast/*
          return
            <li>{$actor}</li>
        }
        </ul>
      </li>
};
let $query := request:get-parameter("query", ()) 
return 
  <html>
    <head>
      <meta HTTP-EQUIV="Content-Type" content="text/html; charset=UTF-8"/>
      <title>{$page-title}</title>
    </head>
    <body>
      <form action="search-3.xql" method="GET"> 
        <input type="text" name="query" size="40"/>
        <input type="submit" value="Search!!!"/>
      </form>
      <div>
        {local:search($query)}
      </div>
    </body>

  </html>

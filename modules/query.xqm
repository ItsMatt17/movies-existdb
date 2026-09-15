xquery version "3.1";

declare option exist:serialize "method=xhtml media-type=text/html";
declare variable $page-title := "Movies";

let $movies := 
  <movies>
  {
  for $movie in collection("/db/apps/movies/data")
    let $name := util:unescape-uri(replace(base-uri($movie), ".+/(.+)$", "$1"), "UTF-8")
    return 
      <movie uri="{base-uri($movie)}" name="{$name}">
        <title>{$movie//title/text()}</title>
        <cast>
        {
          for $actor in $movie//actor
          return 
            <actor>
              {$actor/text()}
            </actor>
              }
                  
        </cast>
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
      <h1>{$page-title}</h1>
    

      {
        for $movie in $movies/movie
        return
          <div>
            <ul>
                <li>{string($movie/title)} ({string($movie/@name)})</li>
            </ul>
            <ul>
              {
                for $actor in $movie/cast/actor
                return 
                  <li>{string($actor)}</li>
              }
            </ul> 
          </div>
    }
  </body>
</html>
xquery version "3.1";

module namespace movie="http://exist-db.org/apps/movies/movie";

declare option exist:serialize "method=xhtml media-type=text/html";
import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace lib="http://exist-db.org/xquery/html-templating/lib";
import module namespace config="http://exist-db.org/apps/movies/config" at "config.xqm";

declare %private function movie:movie-preview($uri as xs:string){
  if (not($uri)) then () 
  else 
    let $movie := doc($uri)
    return 
      <div class="flex p-4 bg-slate-50 gap-x-4">
        <div class="flex-col">
          <a href="movie">
            <h3 class="font-bold">{$movie//title/text()}</h3>
          </a>
          <div class="flex gap-x-4">
            <span>{$movie//release/year/text()}</span>
            <span>{$movie//duration/text()}m</span>
            <span>{$movie//age_rating/text()}</span>
          </div>
        </div>
      </div>
};

declare %private function movie:helper-query($node as node(), $model as map(*), $query as xs:string?) {
  if (not($query)) then movie:fetch-all-movies($node, $model)
  else 
    <ul>
      {
        for $movie in collection("/db/apps/movies/data")/movie/title[ngram:contains(., $query)]
          let $uri := base-uri($movie)
          return
              <li>{ movie:movie-preview($uri) }</li>
      }
    </ul>  
};

declare %templates:wrap function movie:query($node as node(), $model as map(*)){
  let $query := request:get-parameter("query", "")
  return movie:helper-query($node, $model, $query) 
};


declare %templates:wrap function movie:fetch-all-movies($node as node(), $model as map(*)){  
  <ul>
  {
    for $movie in collection("/db/apps/movies/data")
      let $uri := base-uri($movie)
      return
          <li>{ movie:movie-preview($uri) }</li>
  }
  </ul>
};

declare function movie:search-bar($node as node(), $model as map(*)){
  let $query := request:get-parameter("query", "") 
  return 
      <form action="" method="GET">
        <input type="text" placeholder="Search for a title..." value="{$query}" name="query"/>
        <div class="bg-slate-200">
          <input class="" type="submit" value="Search"/> 
        </div>
      </form>
};

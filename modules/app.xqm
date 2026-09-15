xquery version "3.1";

(:~ This is the default application library module of the movies2 app.
:
: @author Matthew Payne
: @version 1.0.0
: @see http://exist-db.org
:)

(: Module for app-specific template functions :)
module namespace app="http://exist-db.org/apps/movies/templates";
import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace lib="http://exist-db.org/xquery/html-templating/lib";
import module namespace config="http://exist-db.org/apps/movies/config" at "config.xqm";

(:~
: This is a sample templating function. It will be called by the templating module if
: it encounters an HTML element with an attribute: data-template="app:test" or class="app:test" (deprecated).
: The function has to take 2 default parameters. Additional parameters are automatically mapped to
: any matching request or function parameter.
:
: @param $node the HTML node with the attribute which triggered this call
: @param $model a map containing arbitrary data - used to pass information between template calls
:)


declare %templates:wrap function app:hello-world($node as node(), $model as map(*)){
  <p>Hello world meow</p>
  
};

declare %private function app:movie-preview($uri as xs:string){
  if (not($uri)) then () 
  else 
    let $movie := doc($uri)
    return 
      <div class="flex p-4 bg-slate-50 gap-x-4">
        <div class="flex-col">
          <h3 class="font-bold">{$movie//title/text()}</h3>
          <div class="flex gap-x-4">
            <span>{$movie//release/year/text()}</span>
            <span>{$movie//duration/text()}m</span>
            <span>{$movie//age_rating/text()}</span>
          </div>
        </div>

      </div>
  
};

declare %private function app:helper-query($node as node(), $model as map(*), $query as xs:string?) {
  if (not($query)) then app:fetch-all-movies($node, $model)
  else 
    <ul>
      {
        for $movie in collection("/db/apps/movies/data")/movie/title[ngram:contains(., $query)]
          let $uri := base-uri($movie)
          return
              <li>{ app:movie-preview($uri) }</li>
      }
    </ul>  
};

declare %templates:wrap function app:query($node as node(), $model as map(*)){
  let $query := request:get-parameter("query", "")
  return app:helper-query($node, $model, $query) 
};


declare %templates:wrap function app:fetch-all-movies($node as node(), $model as map(*)){  
  <ul>
  {
    for $movie in collection("/db/apps/movies/data")
      let $uri := base-uri($movie)
      return
          <li>{ app:movie-preview($uri) }</li>
  }
  </ul>
};


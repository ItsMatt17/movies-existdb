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
    let $href := concat("movie.html?uri=", xmldb:encode-uri($uri))
    return 
      <div class="flex p-4 bg-slate-50 gap-x-4">
        <div class="flex-col">
          <a href="{$href}">
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

declare function movie:full-view($node as node(), $model as map(*)){
  let $uri := request:get-parameter("uri", "")
  let $movie := doc($uri)//movie
  let $res := 
    if (not($uri)) 
      then <div class="flex-1">Not Found</div>
    else 
      let $release := concat($movie//month/text(), "-",  $movie//day/text(), "-", $movie//year/text())
      let $revenue := concat("$", $movie//revenue/text())
      return 
      <div class="bg-slate-50 p-4 rounded-md max-w-1/2">
        <a href="/exist/apps/movies/pages/movie/index.html">Home</a>
        <h2 class="text-2xl font-bold">{$movie//title/text()}</h2>
        <br/>
        <p class="text-pretty"><span class="underline">Description:</span>&#160;{$movie//description/text()}</p>
        <p class="text-pretty"><span class="underline">Release:</span>&#160;{$release}</p>
        <p class="text-pretty"><span class="underline">Revenue:</span>&#160;{$revenue}</p>
        <p class="text-pretty"><span class="underline">Duration:</span>&#160;{$movie//duration//text()}(mins)</p>
        <p class="text-pretty"><span class="underline">Age Rating:</span>&#160;{$movie//age_rating//text()}</p>
        <p class="text-pretty"><span class="underline">Rating:</span>&#160;{$movie//rating//text()}/10</p>
        <br/>
        <ul class="list-disc">
          <h3 class="text-lg font-semibold">Actors</h3>
          { for-each($movie//actor/text(), function($n){ <li>{$n}</li> }) }

        </ul>
        <br/>
        <ul class="list-disc">
          <h3 class="text-lg font-semibold">Genres</h3>
          { for-each( $movie//genre/text(), function($n) { <li>{$n}</li> }) }
        </ul>
        <br/>


      </div>
  return $res 

};

declare %private function movie:helper-query($node as node(), $model as map(*), $query as xs:string?, $on as xs:string?) {
    let $collection := collection("/db/apps/movies/data")
    (: need to use contains cannot use ft:query b/c smth weird with indexing idk :)
    let $movies := $collection/movie//*[local-name() = $on][contains(lower-case(string(.)), lower-case($query))]
    return 
      <ul>
        {
          for $movie in $movies
            let $uri := base-uri($movie)

            return
                <li> 
                { movie:movie-preview($uri) }
                </li>
        }
      </ul>  
};

declare %templates:wrap function movie:query($node as node(), $model as map(*)){
  let $query := request:get-parameter("query", "")
  let $on := request:get-parameter("on", "title")
  return movie:helper-query($node, $model, $query, $on) 
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
  let $on := request:get-parameter("on", "title") 
  return 
      <form class="p-4" action="" method="GET">
        <fieldset class="flex gap-4">
          <legend>Search based on: </legend>
          <div class="space-x-2">
            <input type="radio" id="title" name="on" value="title" >
              { if ($on = "title") then attribute checked { "checked" } else () }
            </input>
            <label for="title">title</label>

            <input type="radio" id="genre" name="on" value="genre">
              { if ($on = "genre") then attribute checked { "checked" } else () }
            </input>
            <label for="genre">genre</label>

            <input type="radio" id="actor" name="on" value="actor">
              { if ($on = "actor") then attribute checked { "checked" } else () }
            </input>
            <label for="actor">actor</label>
          </div>
        </fieldset>

        <div class="flex items-center">
          <div class="">
            <input type="text" placeholder="Search for a title..." value="{$query}" name="query"/>
          </div>
          <div class="flex-1 p-2 bg-slate-200">
            <input type="submit" value="Search"/> 
          </div>
        </div>
      </form>
};

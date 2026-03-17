local h5tk = require "h5tk"
-- local css = require "css"
local base_template = require "templates.base"
local building_blocks = require "lib.building_blocks"

local h = h5tk.init(true)

local a, p, div, header, section = h.a, h.p, h.div, h.header, h.section


local row = building_blocks.row

-- local class = building_blocks.class

local column = building_blocks.column

local medium = building_blocks.medium

local card = building_blocks.card

local tab = building_blocks.tab
local boxik = building_blocks.boxik
local translator = require "lib.translator"

local print_actual_index = building_blocks.print_actual_index
local provozni_doba = building_blocks.provozni_doba


local function obalky(filename, isbn)
  -- return h.div {a{target="_blank", href="https://ckis.cuni.cz/F?func=find-a&amp;local_base=CKS&amp;find_code=ISN&amp;request=".. isbn, h.img{style = "height:9rem;display:inline;",alt=isbn, src='/img/obalky/' .. filename }}}
  -- odkazovat do UKAŽ místo katalogu. v UKAŽ můžou být odkazy na Bookport :(
  return h.div {a{target="_blank", href="https://search.ebscohost.com/login.aspx?direct=true&amp;site=eds-live&amp;scope=site&amp;type=0&amp;custid=s1240919&amp;groupid=pedf&amp;profid=eds&amp;mode=bool&amp;lang=cs&amp;authtype=ip,guest&amp;bquery=IB+".. isbn, h.img{style = "height:9rem;display:inline;",alt=isbn, src='/img/obalky/' .. filename }}}
end

local function progress(percent)
  return h.progress{value = percent, max=1000}
end

local function print_obalky(obalky_tbl)
  local t = {}
  for _, obalka in ipairs(obalky_tbl or {}) do
    table.insert(t, obalky(obalka.file, obalka.isbn))
  end
  return t
  -- return {p{"obalek: " .. #obalky_tbl}}
end


local function data_links(T,data)
  local t = {}
  for i, v in ipairs(data) do
    local separator = ""
    if i < #data then separator = ", " end
    table.insert(t, "<a href='" ..T(v[2]).. "'>".. T(v[1]).."</a>"..separator)
  end
  return t
end

local function print_updates(T, data)
  local t = {}

  for i=1, 5 do
    local x = data[i] or {}
    t[#t+1] = string.format("<a href='%s'>%s</a>", x.relative_filepath, x.title)
  end
  return " (" ..data[1].date .."): " .. table.concat(t , ", ")
end

local function search_box(h, T)
  return div {class="top-searchbox",
  div{class="tabs searchbox", 
  tab("ukaz-sbox", T "UKAŽ", 
  h.form{ id="ebscohostCustomSearchBox",  action="https://cuni.primo.exlibrisgroup.com/discovery/search", onsubmit="searchPrimo()", method="get",enctype="application/x-www-form-urlencoded; charset=utf-8", target="_blank",
  h.input{ type="hidden", name="vid", value="420CKIS_INST:UKAZ"},
  h.input{ type="hidden", name="tab", value="Everything"},
  h.input{ type="hidden", name="search_scope", value="MyInst_and_CI"},
  h.input{ type="hidden", name="lang", value= T "cs"},
  h.input{ type="hidden", name="mode", value="basic"},
  h.input{ type="hidden", name="query", id="primoQuery"},
  h.input{ type="hidden", name="pcAvailabiltyMode", value="true"},
  -- tak nakonec fakt nechceme omezovat hledání jen na pedf
  -- h.input{ type="hidden", name="mfacet", value="library,include,6986–112118530006986,1"},
  h.input{type="search", id="primoQueryTemp", placeholder=T "Hledat knihy a články", style="max-width:12rem;width:95%;"},
  -- h.input{id="go", title=T "hledat", onclick="searchPrimo()", type="button", value= T "hledat" ,alt= T "hledat"},
  -- h.input{id="go", title=T "hledat", type="submit", class="small", value= T "?" ,alt= T "hledat"},
  h.input{id="go", title=T "hledat", type="image", class="small", src="/img/search.svg" ,alt= T "hledat"},
  -- h.div{class="bottom", T "<a href='https://knihovna.cuni.cz/rozcestnik/ukaz/'>Více informací</a> o vyhledávací službě Ukaž.", "<br />", T "<a href='eiz.htm#upozorneni'>Podmínky pro užití el. zdrojů</a>."},
},"checked"
      ),
      tab("web-knihovny-sbox", T "Web knihovny", 
      h.form{role="search", method="get", id="duckduckgo-search", action="https://duckduckgo.com/", target="_blank", 
      h.input{type="hidden", name="sites" , value="knihovna.pedf.cuni.cz"},
      h.input{type="hidden", name="k8" , value="#444444"},
      h.input{type="hidden", name="k9" , value="#D51920"},
      h.input{type="hidden", name="kt" , value="h"},
      h.input{type="search", name="q" , maxlength="255", style="max-width:12rem;width:95%;", placeholder=T "Hledat na tomto webu"},
      -- h.input{id="go", title=T "hledat", type="submit", class="small", value= T "?" ,alt= T "hledat"},
      h.input{id="go", title=T "hledat", type="image", class="small", src="/img/search.svg" ,alt= T "hledat"},
    }

    -- h.iframe{src="https://duckduckgo.com/search.html?site=knihovna.pedf.cuni.cz&prefill=Search DuckDuckGo&kl=cs-cz&kae=t&ks=s",
    -- style="overflow:hidden;margin:0;padding:0;width:408px;height:40px;"}
  )
}}
  end

local function quick_links(doc, T)
  local t = {}
  for _, link in ipairs(doc.quicklinks or {}) do
    t[#t+1] = h.div {
      class = "quicklink", 
        h.a{href=T(link.href), 
        h.img{src = link.img, alt = T(link.title)},
        T(link.title)
      }
    }
  end
  return t
end

-- function column
local function template(doc )
  local title = doc.title
  local strings = doc.strings
  local T = translator.get_translator(strings)
  -- handle closed days
  local today = os.date("%Y-%m-%d", os.time())
  local closing = doc.calendar
  local close_comment = closing[today]
  local close_element = div {class="closed", id="closed"}
  if close_comment then
    close_element = div{class="closed", id="closed", div{h.b {T "Dnes má knihovna zavřeno: "}}, div{T(close_comment)}}
    -- close_element = div{class="closed", h.strong {T "Dnes má knihovna zavřeno: "}, T(close_comment)}
  end
  local contents = {
    h.main {

      h.section {class="rollup", h.img {src = "img/aslop.jpg"}},
      h.aside {class="quick-links", quick_links(doc, T)},

      -- hledání musíme pořešit
      -- search_box(h, T),
      h.section{
        class="news",
        h.h2{class="news-head", T "Aktuality" },
        print_actual_index(doc.items, T), div {class="archive-link", T ' (<a href="archiv.html">Další aktuality zde</a>)' },
      },
      h.section{class="opening",
        h.h2{T "Provozní doba"},
        provozni_doba( doc.prov_doba, T),
        close_element,
        div{class="planned_closing",  a {href=T "provozni_doba.htm", T "Plánované uzavření knihovny"}}
      },
      h.section{ h.b {T "Nejnovější aktualizace"}, print_updates(T,doc.updates), "/",  h.a{href= T "aktualizace.html",  T "Starší"}},
    },

-- h.div{class="row", h.div {class="col-sm-12 col-md-10 col-md-offset-1",
-- h.div{class="card", h.section {class="section ",
-- (body)
-- }},
-- h.script{type="text/javascript", 'var nav = responsiveNav(".nav-collapse");'}
h.script{src="js/opening.js", type="text/javascript", defer="defer"},
h.script{ "window.onload = function(){ opening('".. T "/js/calendar.js" .."', '".. T("Dnes má knihovna zavřeno: ") .. "')};"},
  -- Hledání v UKAŽ
  -- [[<script src="https://cdnjs.cloudflare.com/ajax/libs/tiny-slider/2.5.0/min/tiny-slider.js"></script>
  -- <!--[if (lt IE 9)]><script src="https://cdnjs.cloudflare.com/ajax/libs/tiny-slider/2.5.0/min/tiny-slider.helper.ie8.js"></script><![endif]-->
  -- ]]
  -- ,h.script{type="text/javascript", [[
  -- var slider = tns({
  --   container: '.my-slider',
  --   items: 1,
  --   slideBy: 'page',
  --   controls:false,
  --   nav: false,
  --   speed: 7330,
  --   autoplay: true,
  --   autoplayHoverPause: true,
  --   autoplayTimeout: 1500,
  --   autoplayButtonOutput: false,
  --   mouseDrag: true,
  -- });
  -- ]]}
}
-- local doc = {}
doc.contents = contents
doc.title = title
print("menuitems", doc.menuitems)


return base_template(doc)

end


return {template = template}--("Úvodní stránka - Knihvna PedF UK", {
-- h.h1 {"Úvodní stránka"},
-- ipsum,ipsum, ipsum,ipsum,ipsum,ipsum,ipsum,
-- })

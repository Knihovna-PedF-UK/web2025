local h5tk = require "h5tk"
-- local css = require "css"
local base_template = require "templates.base"
local building_blocks = require "lib.building_blocks"

local h = h5tk.init(true)
local card = building_blocks.card
local row = building_blocks.row
local medium = building_blocks.medium
local tab = building_blocks.tab
local div = h.div
local provozni_doba = building_blocks.provozni_doba
local uzavreni = building_blocks.uzavreni

local translator = require "lib.translator"

local M = {}

local function print_updates(doc)
  local t = {}
  for _, item in ipairs(doc.items) do
    table.insert(t, h.tr {h.td {item.date}, h.td{h.a{href=item.relative_filepath, item.title}}})
  end
  return t
end


local function search(doc, T)
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


function M.template(doc)
  local strings = doc.strings
  local T = translator.get_translator(strings)
  doc.contents = {
    h.h1{ T "Vyhledávání"},
    search(doc, T)
  }
  -- add page image
  return base_template(doc)
end
return M

local h5tk = require "h5tk"
-- local css = require "css"
local base_template = require "templates.base"
local building_blocks = require "lib.building_blocks"

local h = h5tk.init(true)
local card = building_blocks.card
local row = building_blocks.row
local medium = building_blocks.medium
local provozni_doba = building_blocks.provozni_doba
local uzavreni = building_blocks.uzavreni

local translator = require "lib.translator"

local M = {}

function M.template(doc)
  local strings = doc.strings
  local T = translator.get_translator(strings)
  doc.contents = {
    h.h1{ T "Provozní doba"},
    h.section{class="opening", 
    provozni_doba(doc.prov_doba,T)
  }, h.h1 { T "Plánované uzavření knihovny"},
  h.section{class="closing",
      uzavreni(doc.closing, T)
    }
  }
  return base_template(doc)
end
return M

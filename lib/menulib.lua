-- konstruktor položky menu
local function MenuItem(title, href)
  local self = {
    title = title,
    href = href,
    children = {}
  }

  -- metoda pro přidání podmenu k položce
  function self:addchild(title, href)
    local child = MenuItem(title, href)
    table.insert(self.children, child)
    return child
  end

  return self
end

-- konstruktor hlavního menu
function Menu()
  local self = {
    items = {},
    last = nil
  }

  -- přidání položky
  function self:add(title, href)
    local item = MenuItem(title, href)
    table.insert(self.items, item)
    self.last = item
    return self
  end

  -- přidání podmenu k poslední přidané položce
  function self:addchild(title, href)
    if self.last then
      -- return ("Není kam přidat child – žádná hlavní položka zatím neexistuje")
      self.last:addchild(title, href)
    end
    return self
  end

   return setmetatable(self, {
    __index = self.items,   -- umožní přístup přes menu[1], menu[2] ...
    __len = function(t) return #t.items end,
    __ipairs = function(t)  -- pro Lua 5.2
      return ipairs(t.items)
    end,
    __pairs = function(t)   -- pro pairs()
      return pairs(t.items)
    end,
    __iter = function(t)    -- pro Lua 5.4: for x in menu:iter() do ...
      return ipairs(t.items)
    end,
  })
  -- return self
end

-- ------------------------
-- Příklad použití:
-- ------------------------

-- local menu = Menu()

-- local home = menu:add("Home", "/")

-- local about = menu:add("About", "/about")
-- local projects = menu:add("Projects", "/projects")

-- -- obě varianty fungují:
-- projects:addchild("Project A", "/projects/a")
-- menu:addchild("Project B", "/projects/b") -- přidá k "Projects"
-- menu:add("Grr", "ahojky")
-- menu:add("Contact", "/contact"):addchild("Email", "/contact/email")

-- -- výpis
-- for _, item in ipairs(menu) do
--   print(item.title .. " -> " .. item.href)
--   for _, child in ipairs(item.children) do
--     print("   " .. child.title .. " -> " .. child.href)
--   end
-- end

return Menu

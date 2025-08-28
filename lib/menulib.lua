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
    return item
  end

  -- přidání podmenu k poslední přidané položce
  function self:addchild(title, href)
    if not self.last then
      error("Není kam přidat child – žádná hlavní položka zatím neexistuje")
    end
    return self.last:addchild(title, href)
  end

  return self
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
-- for _, item in ipairs(menu.items) do
--   print(item.title .. " -> " .. item.href)
--   for _, child in ipairs(item.children) do
--     print("   " .. child.title .. " -> " .. child.href)
--   end
-- end

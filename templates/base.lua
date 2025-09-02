
local h5tk = require "h5tk"
-- local css = require "css"
local building_blocks = require "lib.building_blocks"
local translator = require "lib.translator"
local os = require "os"

local h = h5tk.init(true)

local a, p, div, header, section = h.a, h.p, h.div, h.header, h.section

local menuitem = function(title, href, children)
  -- return h.menuitem{class="button", h.a{src=href, title}}
  local button = {}
  if children then
    button = h.button{class="dropdown", h.img{src="/img/sipkadolu.svg"}}

  end
  return h.li{role="menuitem", h.a{href="/" .. href, class="button", title}, button, children}
end


local row = building_blocks.row

-- local class = building_blocks.class

-- local column = building_blocks.column

local medium = building_blocks.medium

local card = building_blocks.card

local tab = building_blocks.tab
-- local boxik = building_blocks.boxik


local function mainmenu(menuitems)
  local t = {}
  local menuitems = menuitems or {}
  for _, item in ipairs(menuitems) do
    if item.children and #item.children > 0 then
      local children = h.ul{class="submenu", role="menu",
      (function()
        local ct = {}
        for _, child in ipairs(item.children) do
          table.insert(ct, menuitem(child.title, child.href))
        end
        return ct
      end)()
      }
      table.insert(t, menuitem(item.title,  item.href, children))
    else
      table.insert(t, menuitem(item.title,  item.href))
    end
    -- table.insert(t, menuitem(item.title,  item.href, children))
  end
  return h.ul{class="menu", role="menubar", t}
end



local function boxik(title, href)
  -- return medium(3,card {h.h3 {title}, {content} })
  return medium(2, h.a {href=href, title})
end

local function metaifexitst(key, value, name)
  local property = name and "name" or "property"
  if value then return h.meta{[property] = key, content=value } end
end

local function make_url(doc)
  return doc.siteurl .. doc.relative_filepath
end

local function get_base_url(url)
  return url:match("(https?%://[^/]+)")
end

local function default_img(doc)
  local imgpath = doc.img or "/img/informace.jpg"
  local base_url = get_base_url(doc.siteurl)
  return base_url ..  imgpath
end

local function custom_styles(data)
  local styles = data.styles
  local t = {}
  if styles then
    for _, v in ipairs(styles) do
      t[#t+1] = h.link{rel="stylesheet", type="text/css", href=v}
    end
  end
  return t
end

local function obsolete(data)
  -- 
  if data.obsolete then
    return [[<div class="row"><div class="card fluid warning"><mark class="secondary">Upozornění</mark>Tato stránka není aktuální.
      Nachází se zde pouze proto, že mohou existovat stránky, které na ní odkazují.
      Použijte prosím navigaci v hlavním menu stránky k nalezení aktuálních
      informací.</div></div>]]
  end
end

local function meta_obsolete(data)
  if data.obsolete then
    return '<meta name="robots" content="noindex" />'
  end
end

local function meta_redirect(data)
  if data.redirect then
    local url = data.siteurl .. data.redirect
    return string.format('<meta http-equiv="Refresh" content="0; URL=%s">', url)
  end
end

-- function column
local function template(data)
  local strings = data.strings
  local T = translator.get_translator(strings)
  
  return "<!DOCTYPE html>\n" .. (h.emit(
  h.html{lang=T "cs", prefix="og: http://ogp.me/ns#",
    h.head{
      h.meta{charset="utf-8"},
      h.meta{name="viewport", content="width=device-width, initial-scale=1"},
      h.title{(T (data.title))},
      meta_obsolete(data),
      meta_redirect(data),
      metaifexitst("og:type", "website"),
      metaifexitst("og:title", data.title),
      metaifexitst("og:description", data.description),
      metaifexitst("og:url", make_url(data)),
      metaifexitst("og:site_name", "Knihovna PedF UK"),
      metaifexitst("og:image", default_img(data)),
      metaifexitst( "twitter:card", "summary_large_image" , "name"),
      -- tohle změnit, použít lokální verzi
      -- h.link{rel="stylesheet", type="text/css", href="https://gitcdn.link/repo/Chalarangelo/mini.css/master/dist/mini-default.min.css"},
      -- '<link rel="stylesheet" href="https://code.cdn.mozilla.net/fonts/fira.css">',
     h.link {rel="alternate",  type="application/rss+xml", href= T "feed.rss"},
      h.link{rel="stylesheet", type="text/css", href="/css/style.css"},
      h.link{rel="stylesheet", type="text/css", href="/media.css"},
      custom_styles(data),
      [[
      <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
      <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
      <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
      <link rel="manifest" href="/manifest.json">
      <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
      <script src="/js/header.js" defer></script>
      <meta name="theme-color" content="#ffffff">
      ]]
      -- <link rel="stylesheet" type="text/css" href="/css/fa-svg-with-js.css" />
      -- <script defer src="/js/fontawesome-all.min.js"></script>
      -- <script src="https://cdnjs.cloudflare.com/ajax/libs/webfont/1.6.28/webfontloader.js"></script>
      -- <script>
      --   WebFont.load({
      --     custom: {
      --       families: ['Fira Sans']
      --     }
      --   });
      --   </script>

      -- h.link{rel="stylesheet", type="text/css", href="src/responsive-nav.css"},
      -- h.script{type="text/javascript", src="responsive-nav.js",},
    },
    h.body{
      class="container",
      -- row {h.p {}},
      h.header {
        -- h.a{href="http://pedf.cuni.cz", h.img{src="img/logo_pedf_small.jpg"}},
        h.nav{["aria-label"]= T "doplňková navigace", class="topmenu", 
          h.div{class="nav-container", 
            h.span{a{href= T "https://pedf.cuni.cz/PEDF-871.html", T "Všechny katedry"}},
            h.span{ a{href=T "https://pedf.cuni.cz/", T "Pedagogická fakulta"}},
            -- h.span{class="langswitcher", h.img{src="/img/world.svg"}, a{href=(data.altlang or T "/index-en.html"),h.img{src=T "/img/gb.svg",  alt=T "Switch to English version"}}} -- odkaz na anglickou verzi stránek
            h.span{class="langswitcher", h.img{src="/img/world.svg",}, a{href=(data.altlang or T "/index-en.html"),  title=T "Switch to English version", T "EN"}}, -- odkaz na anglickou verzi stránek
            h.span{h.img{src="/img/search.svg"}}, -- ToDo: dodělat vyhledávání
          },
        },
        h.nav{["aria-label"]= T "hlavní menu", class="mainmenu",
          h.div{class="nav-container",
            h.a{ href= T "/index.html", h.img{role="banner", class="logo", alt=T "Zpět na hlavní stránku knihovny", src=T "/img/logo.svg"}},
            -- h.a{class="logo",h.div{"Ústřední knihovna PedF UK"}},
            -- h.menu{
            -- h.nav{class="nav-collapse",
            -- h.ul{
            -- class="row",
            h.span {class="logo", "&nbsp;"},
            mainmenu(data.menuitems),
          },
        -- }},
      },
  },
      -- row{
        h.main {class="main-content",
        obsolete(data), -- upozornění na zastaralé stránky
        data.contents,
      },
    -- },


    -- h.div{class="row", h.div {class="col-sm-12 col-md-10 col-md-offset-1",
    -- h.div{class="card", h.section {class="section ",
    -- (body)
    -- }},
    h.footer{role="contentinfo",
      row{
        medium(4, div{
          p{"Knihovna PedF UK, Magdaleny Rettigové 4, 116&#8239;39&nbsp;Praha&nbsp;1"},
          p{"Aktualizováno: " .. os.date("%Y-%m-%d")},
          p{"© Univerzita Karlova",},

        }),
        medium(4, div {
          div{a {href="https://www.facebook.com/knihovnapedfpraha", "Facebook"}}
          ,div{a {href="https://www.instagram.com/KnihovnaPedFPraha/", "Instagram"}}
          ,div{a {href=T "/feed.rss", "RSS"}}

        }),
        medium(4, div {
          p{"Jsme členy knihovnických organizací <a href='https://www.skipcr.cz/'>SKIP</a> a <a href='https://sdruk.cz/'>SDRUK z. s.</a>"},
          p{"Webmaster: <a href='mailto:michal.hoftich@pedf.cuni.cz'>michal.hoftich@pedf.cuni.cz</a>"}
          ,p{a {href="prohlaseni.html", "Prohlášení o přístupnosti stránek"}}
        })
        -- boxik("EIZ pro PedF", "eiz.htm"),
        -- boxik('Časopisy', "periodika.htm"),
        -- boxik("Studenti se speciálními potřebami", "handi.htm"),
        -- boxik("Návody", "navody.html"),
        -- boxik("O knihovně", "informace.htm"),
        -- -- boxik("Řády a ceníky", 
        -- boxik("Facebook", "http://www.facebook.com/pages/%C3%9Ast%C5%99edn%C3%AD-knihovna-Pedagogick%C3%A9-fakulty-Univerzity-Karlovy/119305204810664"),
        -- boxik("Pracoviště a zaměstnanci", "adresar.htm"),
        -- boxik("Formuláře", "e-formulare.htm")

    }
    },
    -- h.script{type="text/javascript", 'var nav = responsiveNav(".nav-collapse");'}
    -- h.script{src="https://support.ebsco.com/eit/scripts/ebscohostsearch.js", type="text/javascript", defer=true}
    h.script{['data-goatcounter']="https://knihovna.pedf.cuni.cz/counter/counter.php", async=true, type="text/javascript", src="/js/count.js"},
  [[<script type="text/javascript">
  function searchPrimoBase(id,temp) {
    document.getElementById(id).value = "any,contains," + document.getElementById(temp).value.replace(/[,]/g, " ");
    document.forms["searchForm"].submit();
  }
  function searchPrimo() {
    searchPrimoBase("primoQuery","primoQueryTemp");
  }
  function searchClanky(){
    searchPrimoBase("primoClanky","primoClankyTemp");
  }
  </script>
  ]],
  },
}
))
end

return template

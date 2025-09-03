document.addEventListener("DOMContentLoaded", () => {
  const hamburger = document.querySelector(".hamburger");
  const menu = document.querySelector(".menu");

  // otevře menu při focusu
  hamburger.addEventListener("focus", () => {
    openMenu();
  });

  // toggle při kliknutí (myš, dotyk)
  hamburger.addEventListener("click", () => {
    if (menu.classList.contains("open")) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  // zavření při ESC
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      closeMenu();
      // zavřeme i případná submenus
      closeAllSubmenus();
      hamburger.focus(); // vrátí fokus na hamburger
    }
  });

  // zavření při kliknutí mimo menu
  document.addEventListener("click", (e) => {
    if (!menu.contains(e.target) && !hamburger.contains(e.target)) {
      closeMenu();
      closeAllSubmenus();
    }
  });

  function openMenu() {
    menu.classList.add("open");
    hamburger.setAttribute("aria-expanded", "true");
  }

  function closeMenu() {
    menu.classList.remove("open");
    hamburger.setAttribute("aria-expanded", "false");
  }

  function closeAllSubmenus() {
    document.querySelectorAll(".menu li.open").forEach(li => {
      li.classList.remove("open");
      li.querySelector(".dropdown")?.setAttribute("aria-expanded", "false");
    });
  }

  // ovládání dropdown tlačítek
  document.querySelectorAll(".dropdown").forEach(btn => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const li = btn.closest("li");

      // toggle submenu
      if (li.classList.contains("open")) {
        li.classList.remove("open");
        btn.setAttribute("aria-expanded", "false");
      } else {
        // volitelně zavřít ostatní submenus
        closeAllSubmenus();
        li.classList.add("open");
        btn.setAttribute("aria-expanded", "true");
      }
    });

    // ovládání klávesnicí – Enter/mezerník
    btn.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        btn.click(); // spustí click handler
      }
    });
  });
});

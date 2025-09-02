
// měření výšky topmenu a uložení do CSS proměnné
function updateTopmenuHeight() {
  const topmenu = document.querySelector('.topmenu');
  if (topmenu) {
    document.documentElement.style.setProperty(
      '--topmenu-h',
      topmenu.offsetHeight + 'px'
    );
  }
}

window.addEventListener('resize', updateTopmenuHeight);
window.addEventListener('load', updateTopmenuHeight);

// schovávání topmenu při scrollu
let lastScroll = 0;
window.addEventListener('scroll', () => {
  const topmenu = document.querySelector('.topmenu');
  const currentScroll = window.pageYOffset;
  const mainmenu = document.querySelector('header');

  if (currentScroll > lastScroll && currentScroll > 50) {
    topmenu.classList.add('hidden'); // scroll dolů
    mainmenu.classList.add('top');

  } else {
    topmenu.classList.remove('hidden'); // scroll nahoru
    mainmenu.classList.remove('top');
  }

  lastScroll = currentScroll;
});

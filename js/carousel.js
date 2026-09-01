document.querySelectorAll('.carousel').forEach(carousel => {
  const slides = carousel.querySelectorAll('.carousel-slide');

  if (slides.length < 2) return;

  let current = 0;
  let timer = null;
  let paused = false;

  // Vytvoření ovládacích prvků
  const prev = document.createElement('button');
  prev.className = 'carousel-prev';
  prev.type = 'button';
  prev.setAttribute('aria-label', 'Předchozí obrázek');
  prev.textContent = '‹';

  const next = document.createElement('button');
  next.className = 'carousel-next';
  next.type = 'button';
  next.setAttribute('aria-label', 'Další obrázek');
  next.textContent = '›';

  carousel.querySelector('.carousel-slides').append(prev, next);

  const indicators = document.createElement('div');
  indicators.className = 'carousel-indicators';

  slides.forEach((slide, i) => {
    const button = document.createElement('button');

    button.type = 'button';
    button.setAttribute(
      'aria-label',
      `Zobrazit obrázek ${i + 1}`
    );

    button.addEventListener('click', () => {
      showSlide(i);
      restart();
    });

    indicators.append(button);
  });

  carousel.append(indicators);

  function showSlide(index) {
    current = (index + slides.length) % slides.length;

    slides.forEach((slide, i) => {
      slide.classList.toggle('is-active', i === current);
    });

    indicators.querySelectorAll('button').forEach((button, i) => {
      button.classList.toggle('is-active', i === current);

      if (i === current) {
        button.setAttribute('aria-current', 'true');
      } else {
        button.removeAttribute('aria-current');
      }
    });
  }

  function start() {
    if (paused) return;

    clearInterval(timer);

    timer = setInterval(() => {
      showSlide(current + 1);
    }, 5000);
  }

  function stop() {
    clearInterval(timer);
    timer = null;
  }

  function restart() {
    stop();
    start();
  }

  prev.addEventListener('click', () => {
    showSlide(current - 1);
    restart();
  });

  next.addEventListener('click', () => {
    showSlide(current + 1);
    restart();
  });

  carousel.addEventListener('mouseenter', () => {
    paused = true;
    stop();
  });

  carousel.addEventListener('mouseleave', () => {
    paused = false;
    restart();
  });

  carousel.addEventListener('focusin', () => {
    paused = true;
    stop();
  });

  carousel.addEventListener('focusout', event => {
    if (!carousel.contains(event.relatedTarget)) {
      paused = false;
      restart();
    }
  });

  showSlide(0);
  start();
});
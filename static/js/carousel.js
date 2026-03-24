// Carousel functionality for Browse by Category section
(function() {
  const prevBtn = document.getElementById('categoryPrev');
  const nextBtn = document.getElementById('categoryNext');
  const carousel = document.querySelector('.categories-carousel');
  
  if (!carousel || !prevBtn || !nextBtn) {
    return; // Exit if elements don't exist
  }
  
  function updateButtonStates() {
    const maxScroll = carousel.scrollWidth - carousel.offsetWidth;
    const currentScroll = carousel.scrollLeft;
    
    // Disable prev button at the start
    prevBtn.disabled = currentScroll <= 0;
    // Disable next button at the end (with small tolerance for rounding)
    nextBtn.disabled = currentScroll >= maxScroll - 5;
    
    // Adjust button opacity based on state
    prevBtn.style.opacity = prevBtn.disabled ? '0.5' : '1';
    nextBtn.style.opacity = nextBtn.disabled ? '0.5' : '1';
  }
  
  function scrollCarousel(direction) {
    const scrollAmount = 244; // Card width (220px) + gap (1.5rem/24px)
    
    if (direction === 'next') {
      carousel.scrollBy({
        left: scrollAmount,
        behavior: 'smooth'
      });
    } else {
      carousel.scrollBy({
        left: -scrollAmount,
        behavior: 'smooth'
      });
    }
  }
  
  prevBtn.addEventListener('click', () => {
    scrollCarousel('prev');
    setTimeout(updateButtonStates, 300);
  });
  
  nextBtn.addEventListener('click', () => {
    scrollCarousel('next');
    setTimeout(updateButtonStates, 300);
  });
  
  // Listen to scroll events for real-time button state updates
  carousel.addEventListener('scroll', updateButtonStates);
  
  // Update button states on load
  updateButtonStates();
  
  // Update on window resize
  window.addEventListener('resize', updateButtonStates);
})();

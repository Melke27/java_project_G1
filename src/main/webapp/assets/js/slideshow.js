const slides = document.querySelectorAll("#bg-section img");
let current = 0;

function showNextSlide() {
    const prev = current;
    current = (current + 1) % slides.length;
    slides[prev].classList.remove("active");
    slides[prev].classList.add("prev");
    slides[current].classList.add("active");
    setTimeout(() => slides[prev].classList.remove("prev"), 1000);
}

setInterval(showNextSlide, 3000);

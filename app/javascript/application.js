// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"



document.addEventListener("DOMContentLoaded", () => {
  const toasts = document.querySelectorAll(".toast");
  toasts.forEach((toast) => {
    setTimeout(() => {
      fadeOutToast(toast);
    }, 5000);

    const closeButton = toast.querySelector("button");
    if (closeButton) {
      closeButton.addEventListener("click", () => fadeOutToast(toast));
    }
  });
});

// Ensure fadeOutToast is available globally
window.fadeOutToast = function (toast) {
  toast.classList.remove("opacity-100");
  toast.classList.add("opacity-0", "translate-x-full");
  setTimeout(() => {
    toast.remove();
  }, 300); // Matches the duration in `transition-all`
};

// Ensure closeToast is available globally
window.closeToast = function (toast) {
  fadeOutToast(toast);
};

  

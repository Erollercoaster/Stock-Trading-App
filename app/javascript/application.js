// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"



document.addEventListener('DOMContentLoaded', () => {
    const toasts = document.querySelectorAll('.toast');
    toasts.forEach(toast => {
      setTimeout(() => {
        fadeOutToast(toast);
      }, 5000);
    });
  });

  function fadeOutToast(toast) {
    toast.classList.remove('opacity-100');
    toast.classList.add('opacity-0', 'translate-x-full');
    setTimeout(() => {
      toast.remove();
    }, 300);
  }

  function closeToast(toast) {
    fadeOutToast(toast);
  }


  const buyTab = document.getElementById('buy-tab');
  const sellTab = document.getElementById('sell-tab');
  const buyForm = document.getElementById('buy-form');
  const sellForm = document.getElementById('sell-form');

  buyTab.addEventListener('click', () => {
    buyTab.classList.add('border-blue-500', 'text-blue-600');
    buyTab.classList.remove('text-gray-500');
    sellTab.classList.remove('border-blue-500', 'text-blue-600');
    sellTab.classList.add('text-gray-500');
    buyForm.classList.remove('hidden');
    sellForm.classList.add('hidden');
  });

  sellTab.addEventListener('click', () => {
    sellTab.classList.add('border-blue-500', 'text-blue-600');
    sellTab.classList.remove('text-gray-500');
    buyTab.classList.remove('border-blue-500', 'text-blue-600');
    buyTab.classList.add('text-gray-500');
    sellForm.classList.remove('hidden');
    buyForm.classList.add('hidden');
  });

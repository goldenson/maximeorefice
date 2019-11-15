let currentPage = document.querySelector('nav a[href^="/' + location.pathname.split("/")[1] + '"]')

currentPage.classList.add('active')
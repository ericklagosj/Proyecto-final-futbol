document.addEventListener("DOMContentLoaded", (event) => {
  // Smooth Scroll to Top
  document
    .querySelector(".footer-top-link a")
    .addEventListener("click", function (event) {
      event.preventDefault();
      window.scrollTo({ top: 0, behavior: "smooth" });
    });

  // Toggle mobile menu
  document.getElementById("mobile-menu").addEventListener("click", function () {
    document.getElementById("navbar-links").classList.toggle("active");
    document.getElementById("navbar-actions").classList.toggle("active");
    document.getElementById("navbar-search").classList.toggle("active");
  });

  // Form Submission (Example)
  document
    .querySelector("#subscribe-form")
    .addEventListener("submit", function (event) {
      event.preventDefault();

      // Simulate form submission
      const email = document.querySelector("#subscribe-form input").value;
      if (email) {
        alert(`Suscripción exitosa con el email: ${email}`);
        // Here you would typically send the email to your server
        document.querySelector("#subscribe-form").reset();
      } else {
        alert("Por favor, ingrese un email válido.");
      }
    });
});

/* FIN SCRIPT NAVBAR */

document.addEventListener("DOMContentLoaded", function () {
  const navbarToggle = document.querySelector(".navbar-toggle");
  const navbarLinks = document.querySelector(".navbar-links");
  const navbarActions = document.querySelector(".navbar-actions");
  const navbarSearch = document.querySelector(".navbar-search");

  navbarToggle.addEventListener("click", function () {
    navbarLinks.classList.toggle("active");
    navbarActions.classList.toggle("active");
    navbarSearch.classList.toggle("active");
  });
});

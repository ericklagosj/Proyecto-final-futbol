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

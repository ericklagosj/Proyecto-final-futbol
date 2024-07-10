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

/* FILTRADO PARTIDOS  */

document.getElementById("reset-filters").addEventListener("click", function () {
  document.getElementById("competition-select").value = "all";
  document.getElementById("stadium-select").value = "all";
  filterMatches();
});

document
  .getElementById("competition-select")
  .addEventListener("change", function () {
    filterMatches();
  });

document
  .getElementById("stadium-select")
  .addEventListener("change", function () {
    filterMatches();
  });

function filterMatches() {
  const competition = document.getElementById("competition-select").value;
  const stadium = document.getElementById("stadium-select").value;
  const rows = document.querySelectorAll(".match-row");
  rows.forEach((row) => {
    const matchType = row
      .querySelector(".match-type")
      .textContent.toLowerCase();
    const matchStadium = row
      .querySelector(".match-stadium")
      .textContent.toLowerCase();
    if (
      (competition === "all" || matchType.includes(competition)) &&
      (stadium === "all" || matchStadium.includes(stadium))
    ) {
      row.style.display = "";
    } else {
      row.style.display = "none";
    }
  });
}

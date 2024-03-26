document.addEventListener("DOMContentLoaded", function () {
  const categorySelect = document.getElementById("category-select");
  const playerRows = document.querySelectorAll(".player-row");

  categorySelect.addEventListener("change", function () {
    const selectedCategory = categorySelect.value;

    playerRows.forEach(function (row) {
      const categoryCell = row.querySelector("td:nth-child(8)");
      if (selectedCategory === "all" || categoryCell.textContent === selectedCategory) {
        row.style.display = "table-row";
      } else {
        row.style.display = "none";
      }
    });
  });
});

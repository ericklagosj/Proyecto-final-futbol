document.addEventListener("DOMContentLoaded", function () {
  // Obtener todas las filas de partido
  const partidos = document.querySelectorAll(".partido");

  // Iterar sobre cada fila de partido y agregar un listener de clic
  partidos.forEach((partido) => {
      partido.addEventListener("click", function () {
          // Obtener el valor del atributo data-target
          const targetId = partido.getAttribute("data-target");

          // Obtener la fila de detalles asociada al data-target
          const detallePartido = document.getElementById(targetId);

          // Cambiar la visibilidad de la fila de detalles
          if (detallePartido) {
              if (detallePartido.style.display === "none") {
                  detallePartido.style.display = "table-row";
              } else {
                  detallePartido.style.display = "none";
              }
          } else {
              console.error(`No se encontró el detalle del partido con ID '${targetId}' dentro de la categoría.`);
          }
      });
  });
});

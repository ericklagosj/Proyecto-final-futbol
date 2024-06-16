document.addEventListener("DOMContentLoaded", function () {
  // Obtener todas las categorías de partidos
  const categorias = document.querySelectorAll(".categoria");

  // Iterar sobre cada categoría de partidos
  categorias.forEach((categoria) => {
      // Obtener todas las filas de partido dentro de la categoría
      const partidos = categoria.querySelectorAll(".partido");

      // Iterar sobre cada fila de partido y agregar un listener de clic
      partidos.forEach((partido) => {
          partido.addEventListener("click", function () {
              // Obtener el valor del atributo data-target
              const targetId = partido.getAttribute("data-target");

              // Obtener el contenedor de detalles asociado al data-target
              const detalleContainer = categoria.querySelector("#" + targetId + "-container");

              // Cambiar la visibilidad del contenedor de detalles
              if (detalleContainer) {
                  if (detalleContainer.style.display === "none") {
                      detalleContainer.style.display = "table-row";
                  } else {
                      detalleContainer.style.display = "none";
                  }
              } else {
                  console.error(`No se encontró el detalle del partido con ID '${targetId}' dentro de la categoría.`);
              }
          });
      });
  });
});

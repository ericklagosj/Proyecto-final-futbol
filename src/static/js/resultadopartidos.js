function cambiarJornada() {
    var jornada = document.getElementById("jornada").value;
    console.log("Jornada seleccionada:", jornada); // Añade este console.log
    // Redireccionar a la página de resultados de la jornada seleccionada
    window.location.href = "/partidos/" + jornada;
  }
  
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
        if (detallePartido.style.display === "none") {
          detallePartido.style.display = "table-row";
        } else {
          detallePartido.style.display = "none";
        }
      });
    });
  });
  
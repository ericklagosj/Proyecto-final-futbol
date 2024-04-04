// Seleccionar los elementos necesarios
const search = document.querySelector(".input-group input");
const tableRows = document.querySelectorAll("tbody tr");
const tableHeadings = document.querySelectorAll("thead th");

// Función para buscar en la tabla
function searchTable() {
  const searchValue = search.value.trim().toLowerCase();

  tableRows.forEach((row) => {
    const teamName = row
      .querySelector(".team-name")
      .textContent.trim()
      .toLowerCase();
    row.classList.toggle("hide", !teamName.includes(searchValue));
  });
}

// Función para ordenar la tabla
function sortTable(column, ascending) {
  const sortedRows = Array.from(tableRows).sort((rowA, rowB) => {
    const valueA = rowA
      .querySelectorAll("td")
      [column].textContent.trim()
      .toLowerCase();
    const valueB = rowB
      .querySelectorAll("td")
      [column].textContent.trim()
      .toLowerCase();

    return ascending
      ? valueA.localeCompare(valueB)
      : valueB.localeCompare(valueA);
  });

  sortedRows.forEach((row) => document.querySelector("tbody").appendChild(row));
}

// Agregar eventos a los encabezados de la tabla para ordenar
tableHeadings.forEach((head, i) => {
  head.addEventListener("click", () => {
    const ascending = !head.classList.contains("asc");
    tableHeadings.forEach((h) => h.classList.remove("asc", "desc"));
    head.classList.toggle("asc", ascending);
    head.classList.toggle("desc", !ascending);
    sortTable(i, ascending);
  });
});

// Agregar evento de entrada para buscar en la tabla
search.addEventListener("input", searchTable);

// Función para resaltar filas alternas y ocultar filas que no coinciden con la búsqueda
function updateTableDisplay() {
  tableRows.forEach((row, i) => {
    const tableData = row.textContent.toLowerCase();
    const searchData = search.value.toLowerCase();

    row.classList.toggle("hide", tableData.indexOf(searchData) < 0);
    row.style.setProperty("--delay", i / 25 + "s");
  });

  document.querySelectorAll("tbody tr:not(.hide)").forEach((visible_row, i) => {
    visible_row.style.backgroundColor =
      i % 2 == 0 ? "transparent" : "#0000000b";
  });
}

// Llamar a la función de actualización cuando se cambia el contenido de búsqueda
search.addEventListener("input", updateTableDisplay);

// Llamar a la función de actualización cuando se carga la página
window.addEventListener("DOMContentLoaded", updateTableDisplay);

// 3. Convirtiendo tabla HTML a PDF
const pdfBtn = document.querySelector("#toPDF");
const customersTable = document.querySelector("#customers_table");

const toPDF = function (table) {
  const htmlCode = `
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tabla de Posiciones</title>
        <link rel="stylesheet" type="text/css" href="../static/style.css">
    </head>
    <body>
        <main class="table" id="customers_table">${table.innerHTML}</main>
    </body>
    </html>`;

  const newWindow = window.open();
  newWindow.document.write(htmlCode);

  setTimeout(() => {
    newWindow.print();
    newWindow.close();
  }, 400);
};

pdfBtn.addEventListener("click", () => {
  toPDF(customersTable);
});

// 4. Convirtiendo tabla HTML a JSON
const jsonBtn = document.querySelector("#toJSON");

const toJSON = function (table) {
  let tableData = [],
    tableHeadings = [],
    tbodyRows = table.querySelectorAll("tbody tr");

  table.querySelectorAll("thead th").forEach((th) => {
    tableHeadings.push(th.textContent.trim().toLowerCase());
  });

  tbodyRows.forEach((row) => {
    const rowData = {};
    row.querySelectorAll("td").forEach((cell, index) => {
      rowData[tableHeadings[index]] = cell.textContent.trim();
    });
    tableData.push(rowData);
  });

  return JSON.stringify(tableData, null, 4);
};

jsonBtn.addEventListener("click", () => {
  const json = toJSON(customersTable);
  downloadFile(json, "json");
});

// 5. Convirtiendo tabla HTML a archivo CSV
const csvBtn = document.querySelector("#toCSV");

const toCSV = function (table) {
  const tableData = Array.from(table.querySelectorAll("tr")).map((row) =>
    Array.from(row.querySelectorAll("td, th")).map((cell) =>
      cell.textContent.trim()
    ).join(",")
  ).join("\n");

  return tableData;
};

csvBtn.addEventListener("click", () => {
  const csv = toCSV(customersTable);
  downloadFile(csv, "csv", "customer_orders");
});

// 6. Convirtiendo tabla HTML a archivo Excel
const excelBtn = document.querySelector("#toEXCEL");

const toExcel = function (table) {
  const tableData = Array.from(table.querySelectorAll("tr")).map((row) =>
    Array.from(row.querySelectorAll("td, th")).map((cell) =>
      cell.textContent.trim()
    ).join("\t")
  ).join("\n");

  return tableData;
};

excelBtn.addEventListener("click", () => {
  const excel = toExcel(customersTable);
  downloadFile(excel, "excel");
});

// Función para descargar el archivo
const downloadFile = function (data, fileType, fileName = "") {
  const a = document.createElement("a");
  a.download = fileName + "." + fileType;
  const mimeTypes = {
    json: "application/json",
    csv: "text/csv",
    excel: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  };
  a.href = "data:" + mimeTypes[fileType] + ";charset=utf-8," + encodeURIComponent(data);
  document.body.appendChild(a);
  a.click();
  a.remove();
};

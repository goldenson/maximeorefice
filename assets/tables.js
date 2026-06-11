// Wrap content tables in a horizontally scrollable container so wide tables
// scroll on mobile instead of crushing. Tables already wrapped (e.g. the
// health include) are skipped.
document.querySelectorAll(".page-content table").forEach((table) => {
  if (table.closest(".table-scroll")) return;
  const wrap = document.createElement("div");
  wrap.className = "table-scroll";
  table.parentNode.insertBefore(wrap, table);
  wrap.appendChild(table);
});

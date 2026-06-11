// Paginate the "Finis" book list client-side, since it's backed by a
// growing data file rather than a Jekyll collection.
const PAGE_SIZE = 10;

const list = document.getElementById("finished-books");
const controls = document.getElementById("finished-books-pagination");

if (list && controls) {
  const items = Array.from(list.children);
  const pageCount = Math.ceil(items.length / PAGE_SIZE);

  const showPage = (page) => {
    items.forEach((item, i) => {
      item.style.display = Math.floor(i / PAGE_SIZE) + 1 === page ? "" : "none";
    });
    renderControls(page);
  };

  const renderControls = (page) => {
    controls.innerHTML = "";

    const addButton = (label, targetPage, disabled, current) => {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "pagination-btn" + (current ? " active" : "");
      btn.textContent = label;
      btn.disabled = disabled;
      btn.addEventListener("click", () => showPage(targetPage));
      controls.appendChild(btn);
    };

    addButton("‹", page - 1, page === 1, false);
    for (let i = 1; i <= pageCount; i++) {
      addButton(i, i, false, i === page);
    }
    addButton("›", page + 1, page === pageCount, false);
  };

  if (pageCount > 1) {
    showPage(1);
  }
}

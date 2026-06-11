const root = document.documentElement;
const darkModeToggle = document.querySelector("#dark-mode-toggle");

const systemPrefersDark = () =>
  window.matchMedia("(prefers-color-scheme: dark)").matches;

// Effective theme: explicit choice wins, otherwise follow the OS.
const isDark = () => {
  if (root.classList.contains("darkmode")) return true;
  if (root.classList.contains("theme-light")) return false;
  return systemPrefersDark();
};

const applyTheme = (dark) => {
  root.classList.toggle("darkmode", dark);
  root.classList.toggle("theme-light", !dark);
  localStorage.setItem("theme", dark ? "dark" : "light");
};

// Restore a saved choice; with none, leave it to the OS preference.
const saved = localStorage.getItem("theme");
if (saved === "dark") applyTheme(true);
else if (saved === "light") applyTheme(false);

darkModeToggle.addEventListener("click", () => applyTheme(!isDark()));

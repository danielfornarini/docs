/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,ts}"],
  theme: {
    extend: {
      colors: {
        primary: "var(--color-primary)",
        "primary-dark": "var(--color-primary-dark)",
        secondary: "var(--color-secondary)",
        danger: "var(--color-danger)",
        warning: "var(--color-warning)",
      },
    },
  },
  plugins: [],
  safelist: ["bg-white", "border-danger"],
  purge: {
    content: ["./src/**/*.{tsx,ts,html,css,scss}"],
  },
};

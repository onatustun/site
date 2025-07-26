module.exports = {
  content: ["./content/**/*.md", "./templates/**/*.html"],
  theme: {
    extend: {
      colors: {
        foreground: "oklch(var(--foreground))",
        background: "oklch(var(--background))",
      },

      fontFamily: {
        sans: ["exo-2", "sans-serif"],
      },
    },
  },
  plugins: [],
};

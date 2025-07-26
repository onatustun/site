module.exports = {
  content: [
    './content/**/*.md',
    './templates/**/*.html',
  ],
  theme: {
    extend: {
      colors: {
       'foreground': 'oklch(var(--foreground))',
       'background': 'oklch(var(--background))',
      },
            
      fontFamily: {
        sans: ['Jost', 'sans-serif'],
      },      
    },
  },
  plugins: [],
}

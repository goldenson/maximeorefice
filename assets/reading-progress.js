const progressBar = document.getElementById('reading-progress-bar')

if (progressBar) {
  const updateProgress = () => {
    const scrollTop = document.documentElement.scrollTop
    const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight
    const progress = scrollHeight > 0 ? (scrollTop / scrollHeight) * 100 : 0

    progressBar.style.width = progress + '%'
  }

  document.addEventListener('scroll', updateProgress)
  updateProgress()
}

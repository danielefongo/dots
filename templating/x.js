const fs = require('fs')
const path = require('path')

function leggiFile (path, high) {
  try {
    const data = fs.readFileSync(path, 'utf-8')
    const righe = data.split('\n')

    const risultato = {
      background: '',
      foreground: '',
      red: '',
      orange: '',
      yellow: '',
      green: '',
      cyan: '',
      blue: '',
      magenta: ''
    }

    if (!high) {
      righe.forEach((riga) => {
        const [chiave, valore] = riga.split(' ')

        switch (chiave) {
          case 'background':
            risultato.background = valore
            break
          case 'foreground':
            risultato.foreground = valore
            break
          case 'color1':
            risultato.red = valore
            break
          case 'color3':
            risultato.orange = risultato.yellow = valore
            break
          case 'color2':
            risultato.green = valore
            break
          case 'color6':
            risultato.cyan = valore
            break
          case 'color4':
            risultato.blue = valore
            break
          case 'color5':
            risultato.magenta = valore
            break
          default:
            break
        }
      })
    } else {
      righe.forEach((riga) => {
        const [chiave, valore] = riga.split(' ')

        switch (chiave) {
          case 'background':
            risultato.background = valore
            break
          case 'foreground':
            risultato.foreground = valore
            break
          case 'color9':
            risultato.red = valore
            break
          case 'color11':
            risultato.orange = risultato.yellow = valore
            break
          case 'color10':
            risultato.green = valore
            break
          case 'color14':
            risultato.cyan = valore
            break
          case 'color12':
            risultato.blue = valore
            break
          case 'color13':
            risultato.magenta = valore
            break
          default:
            break
        }
      })
    }

    return risultato
  } catch (errore) {
    console.error('Errore nella lettura del file:', errore)
    return null
  }
}
// grayscale-dark
// black-metal-bathory
// github-dark-default
// monokai-dark
// seti-ui
// brewer
// tokyo-night
// rose-pine
// terminix-dark
module.exports = function (name) {
  return leggiFile(
    path.join('./templating/theme.sh/themes/', name),
    true
  )
}

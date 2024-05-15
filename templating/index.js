const fs = require('fs')
const path = require('path')
const { execSync } = require('child_process')

const templater = require('./template.js')
const DotBlock = require('./dotblock.js')

function getCommonPath (pattern) {
  const segments = pattern.split(/[\\/]/)
  let commonPath = ''
  for (let i = 0; i < segments.length; i++) {
    const segment = segments[i]
    if (segment.includes('*')) {
      break
    }
    commonPath += (i > 0 ? path.sep : '') + segment
  }
  return commonPath
}

function writeFile (file, to, filter) {
  const destinationFile = to
  const destinationFileFolder = path.dirname(destinationFile)

  if (!fs.existsSync(destinationFileFolder)) {
    fs.mkdirSync(destinationFileFolder, { recursive: true })
  }

  if (!filter(file)) {
    fs.copyFileSync(file, destinationFile)
    return null
  }

  const content = fs.readFileSync(path.resolve(file), 'utf8')
  const oldContent = fs.existsSync(destinationFile)
    ? fs.readFileSync(destinationFile, 'utf8')
    : {}

  delete require.cache[require.resolve('./theme.js')]
  const template = require('./theme.js')

  const newContent = templater(content, template)

  if (newContent != oldContent) {
    fs.writeFileSync(destinationFile, newContent)

    return destinationFile
  }
}

class Postponed {
  constructor (lambda, delay) {
    this.lambda = lambda
    this.delay = delay
    this.applyScheduler = undefined
  }

  run () {
    this.applyScheduler = setTimeout(() => {
      this.applyScheduler = undefined
      this.lambda()
    }, this.delay)
  }

  unschedule () {
    if (this.applyScheduler) {
      clearTimeout(this.applyScheduler)
    }
  }
}

const dotsMatch = '**/*.dots.js'
const themeFile = 'templating/theme.js'
const watching = process.argv[2] == 'watch'

const dotBlock = new DotBlock().on({
  match: dotsMatch,
  init: (dot) => {
    delete require.cache[require.resolve(path.resolve(dot))]
    const dotData = require(path.resolve(dot))

    let files = []
    const postponed = new Postponed(() => {
      try {
        console.log(`Applying: ${dot}`)
        dotData.apply(files)
      } catch (e) {
        console.log(`Failed to build ${dot}, reason: ${e}`)
      }
      files = []
    }, 200)

    const action = ({ file, match }) => {
      const filter = match.filter || (() => true)
      const to = path.join(
        'output',
        match.to
          ? file.replace(
            new RegExp(`^${getCommonPath(match.pattern)}/`),
              `${match.to}/`
          )
          : file
      )
      let output

      try {
        output = writeFile(file, to, filter)
      } catch (e) {
        execSync(`notify-send -t 5000 -a "Templating" -u critical "${file}"`)
        console.log(`Templating failed on file ${file}, reason: ${e}`)
      }

      if (!output || !dotData.apply) {
        return
      }

      console.log(`Updated changed: ${file}`)

      files.push(file)

      postponed.unschedule()
      postponed.run()
    }

    const dotBlock = new DotBlock()

    dotBlock.on({
      match: themeFile,
      ignore: dotsMatch,
      init: (file) => file,
      action: () => {
        for (const match of dotData.match) {
          dotBlock
            .files(match.pattern)
            .forEach((file) => action({ file, match }))
        }
      }
    })

    for (const match of dotData.match) {
      dotBlock.on({
        match: match.pattern,
        ignore: dotsMatch,
        init: (file) => ({ file, match }),
        ignore_unchanged: true,
        action
      })
    }

    return dotBlock
  },
  action: (context) => {
    if (watching) context.run().watch()
    else context.run()
  },
  reset: (context) => context.stopWatch()
})

if (watching) dotBlock.run().watch()
else dotBlock.run()

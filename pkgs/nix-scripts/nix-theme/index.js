#!/bin/env node

const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')

const templater = require('./template.js')
const DotBlock = require('./dotblock.js')

const watching = process.argv[2] == 'watch'
const baseThemeFile = path.resolve(process.argv[3])
const dotsPath = path.resolve(process.argv[4])
const outputPath = path.resolve(process.argv[5])
const dotsMatch = path.join(dotsPath, '**/*.dots.js')
const configPath = path.resolve(xdgConfigPath())

function xdgConfigPath () {
  if (process.env.XDG_CONFIG_HOME) {
    return path.join(process.env.XDG_CONFIG_HOME, 'nix-theme.json')
  }
  return path.join(process.env.HOME, '.config', 'nix-theme.json')
}

function currentThemeFile () {
  if (fs.existsSync(configPath)) {
    const configContent = fs.readFileSync(configPath, 'utf8')
    const config = JSON.parse(configContent)
    if (config.themeFile) {
      return path.resolve(config.themeFile)
    }
  }
  return baseThemeFile
}

function removeFile (toFile) {
  if (fs.existsSync(toFile)) {
    fs.unlinkSync(toFile)
  }
}

function writeFile (file, toFile, filter) {
  const destinationFile = toFile
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

  let themeFile = currentThemeFile()
  delete require.cache[require.resolve(themeFile)]
  const template = require(themeFile)

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

const dotBlock = new DotBlock().on({
  match: dotsMatch,
  path: dotsPath,
  init: (dot) => {
    const dotPath = path.dirname(path.resolve(dot))
    delete require.cache[require.resolve(path.resolve(dot))]
    const dotData = require(path.resolve(dot))

    let files = []
    const postponed = new Postponed(() => {
      try {
        console.log(`Applying: ${dot}`)
        dotData.apply(dotsPath, files)
      } catch (e) {
        console.log(`Failed to build ${dot}, reason: ${e}`)
      }
      files = []
    }, 100)

    const action = ({ file, match }, event) => {
      const filter = match.filter || (() => true)
      let relativeFile = file.replace(dotPath + '/', '')

      if (match.from) {
        relativeFile = relativeFile.replace(new RegExp('^' + match.from), '')
      }
      const to = path.join(match.to, relativeFile)
      let output

      if (event == 'remove') {
        removeFile(to)
        return
      }

      try {
        output = writeFile(file, to, filter)
      } catch (e) {
        console.log(`Templating failed on file ${file}, reason: ${e}`)
        exec(`notify-send -t 5000 -a "Templating" -u critical "${file}"`)
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

    for (const match of dotData.match) {
      if (!path.isAbsolute(match.pattern)) {
        match.pattern = path.join(dotPath, match.pattern)
      }
      if (!match.to) {
        match.to = outputPath
      } else if (!path.isAbsolute(match.to)) {
        match.to = path.join(outputPath, match.to)
      }
    }

    if (watching) {
      const resolvedThemeFile = currentThemeFile();
      dotBlock.on({
        match: resolvedThemeFile,
        path: path.dirname(resolvedThemeFile),
        init: (file) => file,
        action: () => {
          for (const match of dotData.match) {
            dotBlock
              .files(match.pattern)
              .forEach((file) => action({ file, match }))
          }
        }
      })
    }

    for (const match of dotData.match) {
      dotBlock.on({
        match: match.pattern,
        path: dotPath,
        ignore: [dotsMatch, '**/*nix'],
        init: (file) => ({ file, match }),
        ignore_unchanged: true,
        action
      })
    }

    return dotBlock
  },
  action: (context) => {
    if (watching) context.watch()
    else context.run()
  },
  reset: (context) => context.stopWatch()
})

if (watching) dotBlock.watch()
else dotBlock.run()

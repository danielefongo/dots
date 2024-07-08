#!/bin/env node

const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')

const templater = require('./template.js')
const DotBlock = require('./dotblock.js')

const watching = process.argv[2] == 'watch'
const themeFile = path.resolve(process.argv[3])
const dotsPath = path.resolve(process.argv[4])
const outputPath = path.resolve(process.argv[5])
const dotsMatch = path.join(dotsPath, '**/*.dots.js')

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

    const action = ({ file, match }) => {
      const filter = match.filter || (() => true)
      const relativeFile = file.replace(dotPath + '/', '')
      const to = path.join(match.to, relativeFile)
      let output

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

    for (let match of dotData.match) {
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
      dotBlock.on({
        match: themeFile,
        path: themeFile,
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
        ignore: [dotsMatch, "**/*nix"],
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

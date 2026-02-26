#!/bin/env node

const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')
const chokidar = require('chokidar')
const glob = require('glob')

const templater = require('./template.js')
const { Watcher, event } = require('./watcher.js')

const watching = process.argv[2] === 'watch'
const baseThemeFile = path.resolve(process.argv[3])
const dotsPath = path.resolve(process.argv[4])
const outputPath = path.resolve(process.argv[5])
const dotsMatch = path.join(dotsPath, '**/*.dots.js')
const configPath = resolveConfigPath()

function resolveConfigPath () {
  const configHome =
    process.env.XDG_CONFIG_HOME || path.join(process.env.HOME, '.config')
  return path.join(configHome, 'nix-theme.json')
}

function currentThemeFile () {
  try {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'))
    if (config.themeFile) return path.resolve(config.themeFile)
  } catch (_) {}
  return baseThemeFile
}

function loadTheme (themeFile) {
  const themeDir = path.dirname(themeFile) + path.sep
  Object.keys(require.cache)
    .filter((f) => f.startsWith(themeDir))
    .forEach((f) => delete require.cache[f])
  return require(themeFile)
}

function loadThemeDeps (themeFile) {
  const themeDir = path.dirname(themeFile) + path.sep
  loadTheme(themeFile)
  return Object.keys(require.cache).filter((f) => f.startsWith(themeDir))
}

function writeFile (file, toFile, filter) {
  const dir = path.dirname(toFile)
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true })

  if (!filter(file)) {
    removeFile(toFile)
    fs.copyFileSync(file, toFile)
    return false
  }

  const content = fs.readFileSync(file, 'utf8')
  const template = loadTheme(currentThemeFile())
  const rendered = templater(content, template)

  const oldContent = fs.existsSync(toFile)
    ? fs.readFileSync(toFile, 'utf8')
    : null
  if (rendered === oldContent) return false

  removeFile(toFile)
  fs.writeFileSync(toFile, rendered)
  return true
}

function removeFile (file) {
  if (fs.existsSync(file)) fs.unlinkSync(file)
}

function loadDot (dotFile) {
  const dotPath = path.dirname(path.resolve(dotFile))
  delete require.cache[require.resolve(path.resolve(dotFile))]
  const dotData = require(path.resolve(dotFile))

  const matches = dotData.match.map((m) => ({
    pattern: path.join(dotPath, m.pattern),
    to: m.to ? path.join(outputPath, m.to) : outputPath,
    from: m.from,
    filter: m.filter || (() => true),
  }))

  return { dotFile, dotPath, dotData, matches }
}

function loadDots () {
  const dotFiles = glob.globSync(dotsMatch, {
    dot: true,
    cwd: dotsPath,
    nodir: true,
  })
  return dotFiles.map(loadDot)
}

function resolveOutputPath (dot, match, file) {
  let relative = file.replace(dot.dotPath + '/', '')
  if (match.from) relative = relative.replace(new RegExp('^' + match.from), '')
  return path.join(match.to, relative)
}

function createApplier (dot) {
  if (!dot.dotData.apply) return () => {}

  let files = []
  let timer = null

  return function (file) {
    files.push(file)
    if (timer) clearTimeout(timer)
    timer = setTimeout(() => {
      const pending = files
      files = []
      timer = null
      try {
        console.log(`Applying: ${dot.dotFile}`)
        dot.dotData.apply(dotsPath, pending)
      } catch (e) {
        console.log(`Failed to apply ${dot.dotFile}: ${e}`)
      }
    }, 50)
  }
}

function action (dot, match, file, evt, applier) {
  const toFile = resolveOutputPath(dot, match, file)

  if (evt === event.REMOVE) {
    removeFile(toFile)
    return
  }

  try {
    const changed = writeFile(file, toFile, match.filter)
    if (changed) {
      console.log(`Updated: ${file}`)
      applier(file)
    }
  } catch (e) {
    console.log(`Templating failed on ${file}: ${e}`)
    exec(`notify-send -t 5000 -a "Templating" -u critical "${file}"`)
  }
}

function createWatcher (dot) {
  const applier = createApplier(dot)
  const watcher = new Watcher(dot.dotPath, [dotsMatch, '**/*nix'])
  dot.matches.forEach((match) => {
    watcher.on(match.pattern, (file, evt) =>
      action(dot, match, file, evt, applier),
    )
  })
  if (watching) watcher.watch()
  else watcher.run()
  return watcher
}

function run () {
  loadDots().forEach(createWatcher)
}

function watch () {
  const watchers = {}
  const dots = {}

  function startDot (dotFile) {
    const dot = loadDot(dotFile)
    dots[dotFile] = dot
    watchers[dotFile] = createWatcher(dot)
  }

  function stopDot (dotFile) {
    if (watchers[dotFile]) {
      watchers[dotFile].stop()
      delete watchers[dotFile]
    }
  }

  function removeDot (dotFile) {
    stopDot(dotFile)
    if (dots[dotFile]) {
      cleanupDot(dots[dotFile])
      delete dots[dotFile]
    }
  }

  function reloadDot (dotFile) {
    if (dots[dotFile]) {
      cleanupDot(dots[dotFile])
    }
    stopDot(dotFile)
    startDot(dotFile)
  }

  function cleanupDot (dot) {
    console.log(`Cleaning up outputs for: ${dot.dotFile}`)

    dot.matches.forEach((match) => {
      console.log(`  Pattern: ${match.pattern}`)
      console.log(`  To: ${match.to}`)

      const sourceFiles = glob.globSync(match.pattern, {
        dot: true,
        nodir: true,
      })

      console.log(`  Found ${sourceFiles.length} source files to clean up`)

      sourceFiles.forEach((file) => {
        const toFile = resolveOutputPath(dot, match, file)
        console.log(`    Checking: ${toFile}`)
        if (fs.existsSync(toFile)) {
          removeFile(toFile)
          console.log(`    Removed: ${toFile}`)
        }
      })
    })
  }

  const dotsWatcher = new Watcher(dotsPath, ['**/*nix', '.direnv/**', 'node_modules/**'])
  dotsWatcher
    .on(dotsMatch, (dotFile, evt) => {
      switch (evt) {
        case event.ADD:
          console.log(`New dot file: ${dotFile}`)
          startDot(dotFile)
          break
        case event.CHANGE:
          console.log(`Dot changed: ${dotFile}`)
          reloadDot(dotFile)
          break
        case event.REMOVE:
          console.log(`Dot removed: ${dotFile}`)
          removeDot(dotFile)
          break
      }
    })
    .watch()

  let themeWatcher = null

  function setupThemeWatcher () {
    if (themeWatcher) themeWatcher.close()

    const themeFile = currentThemeFile()
    const deps = loadThemeDeps(themeFile)
    const watched = [...deps, configPath]

    themeWatcher = chokidar
      .watch(watched, { ignoreInitial: true })
      .on('change', (changedFile) => {
        if (changedFile === configPath) {
          setupThemeWatcher()
        }
        console.log(`Theme changed: ${changedFile}`)
        Object.values(watchers).forEach((watcher) => watcher.run())
      })
  }

  setupThemeWatcher()
}

if (watching) watch()
else run()

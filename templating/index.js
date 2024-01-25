const glob = require('glob')
const path = require('path')
const pm = require('picomatch')
const watch = require('node-watch')

const templater = require('./template.js')

class DotBlock {
  constructor (dot, applyDelay) {
    this.dot = dot
    this.applyDelay = applyDelay

    return this.load()
  }

  load () {
    delete require.cache[require.resolve(path.resolve(this.dot))]
    const dotData = require(path.resolve(this.dot))

    this.match = dotData.match
    this.matchWatcher = null

    this.apply = dotData.apply
    this.applyScheduler = null
    this.applyFiles = []

    this.opts = { dot: true, ignore: '**/*.dots.js', nodir: true }

    return this
  }

  run () {
    glob.globSync(this.match, this.opts).forEach((file) => this.generate(file))

    return this
  }

  watch () {
    this.stopWatch()

    this.themeWatcher = watch('templating/theme.js', { recursive: true }, () =>
      this.run()
    )

    this.selfWatcher = watch(this.dot, { dot: true, recursive: true }, () => {
      this.themeWatcher.close()
      this.selfWatcher.close()
      this.stopWatch()
      this.unscheduleApply()
      this.load().run().watch()
    })

    this.matchWatcher = watch(
      './',
      { filter: pm(this.match, this.opts), recursive: true },
      (evt, file) => {
        if (evt == 'remove') {
          return
        }

        this.generate(file)
      }
    )

    return this
  }

  stopWatch () {
    if (this.matchWatcher) {
      this.matchWatcher.close()
    }

    if (this.themeWatcher) {
      this.themeWatcher.close()
    }

    if (this.selfWatcher) {
      this.selfWatcher.close()
    }

    return this
  }

  generate (file) {
    const output = templater(file)

    if (!output || !this.apply) {
      return
    }

    console.log(`Updated: ${file}`)

    this.applyFiles.push(output)
    this.scheduleApply()
  }

  unscheduleApply () {
    if (this.applyScheduler) {
      clearTimeout(this.applyScheduler)
    }
  }

  scheduleApply () {
    this.unscheduleApply()

    this.applyScheduler = setTimeout(() => {
      this.applyScheduler = undefined
      try {
        console.log(`Applying: ${this.dot}`)
        this.apply(this.applyFiles)
      } catch (e) {
        console.log(`Failed to build ${this.dot}, reason: ${e}`)
      }
      this.applyFiles = []
    }, this.applyDelay)
  }
}

if (process.argv[2] == 'watch') {
  glob
    .globSync('**/*.dots.js', { nodir: true, dot: true })
    .map((dot) => new DotBlock(dot, 100))
    .forEach((dotBlock) => dotBlock.run().watch())
} else {
  glob
    .globSync('**/*.dots.js', { nodir: true, dot: true })
    .map((dot) => new DotBlock(dot, 100))
    .forEach((dotBlock) => dotBlock.run())
}

const glob = require('glob')
const pm = require('picomatch')
const chokidar = require('chokidar')

const event = {
  ADD: 'add',
  REMOVE: 'unlink',
  CHANGE: 'change',
}

class Watcher {
  constructor (basePath, ignore) {
    this.basePath = basePath
    this.ignore = ignore || []
    this.rules = []
    this.watcher = null
  }

  on (pattern, action) {
    this.rules.push({ pattern, action })
    return this
  }

  files (pattern) {
    return glob.globSync(pattern, {
      dot: true,
      ignore: this.ignore,
      cwd: this.basePath,
      nodir: true,
    })
  }

  run () {
    for (const rule of this.rules) {
      for (const file of this.files(rule.pattern)) {
        rule.action(file, event.ADD)
      }
    }
    return this
  }

  watch () {
    const matchers = this.rules.map((rule) => ({
      match: pm(rule.pattern, { dot: true, ignore: this.ignore }),
      action: rule.action,
    }))

    this.watcher = chokidar
      .watch(this.basePath, { ignoreInitial: false, ignored: this.ignore })
      .on('all', (evt, file) => {
        if ([event.ADD, event.CHANGE, event.REMOVE].indexOf(evt) === -1) return

        for (const { match, action } of matchers) {
          if (match(file)) action(file, evt)
        }
      })

    return this
  }

  stop () {
    if (this.watcher) {
      this.watcher.close()
      this.watcher = null
    }
    return this
  }
}

module.exports = { Watcher, event }

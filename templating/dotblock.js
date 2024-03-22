const glob = require('glob')
const pm = require('picomatch')
const watch = require('node-watch')
const { createHash } = require('crypto')
const { readFileSync } = require('fs')

function md5 (file) {
  const buff = readFileSync(file)
  return createHash('md5').update(buff).digest('hex')
}

module.exports = class DotBlock {
  constructor () {
    this.matches = {}
    this.matchOpts = (data) => ({ dot: true, ignore: data.ignore, nodir: true })
  }

  on (matchAction) {
    this.matches[matchAction.match] = matchAction

    return this
  }

  files (match) {
    return Object.entries(this.matches)
      .filter(([it, _]) => it == match)
      .flatMap(([match, data]) => glob.globSync(match, this.matchOpts(data)))
  }

  run () {
    Object.entries(this.matches).forEach(([match, data]) => {
      glob.globSync(match, this.matchOpts(data)).forEach((file) => {
        this._fileReset(match, file)
        this._fileAction(match, file)
      })
    })

    return this
  }

  watch () {
    Object.entries(this.matches).forEach(([match, data]) => {
      this.matches[match].watcher = watch(
        './',
        { filter: pm(match, this.matchOpts(data)), recursive: true },
        (evt, file) => {
          this._fileReset(match, file)
          if (evt == 'remove') return
          this._fileAction(match, file)
        }
      )
    })

    return this
  }

  stopWatch () {
    Object.keys(this.matches).forEach((match) => {
      this._matchReset(match)
    })

    return this
  }

  _fileAction (match, file) {
    const data = this.matches[match]

    if (!this.matches[match].files) {
      this.matches[match].files = {}
    }

    if (!this.matches[match].files[file]) {
      this.matches[match].files[file] = {}
    }

    if (this.matches[match].files[file].md5 == md5(file)) {
      return
    }

    this.matches[match].files[file].md5 = md5(file)
    this.matches[match].files[file].context = data.init(file)
    data.action(this.matches[match].files[file].context)
  }

  _fileReset (match, file) {
    const data = this.matches[match]
    if (
      data.reset &&
      this.matches[match].files &&
      this.matches[match].files[file] &&
      this.matches[match].files[file].context
    ) {
      data.reset(this.matches[match].files[file].context)
      this.matches[match].files[file] = {}
    }
  }

  _matchReset (match) {
    if (this.matches[match] && this.matches[match].files) {
      Object.keys(this.matches[match].files).forEach((file) => this._fileReset(match, file))
      this.matches[match].files = {}
    }

    if (this.matches[match].watcher) {
      this.matches[match].watcher.close()
      this.matches[match].watcher = null
    }
  }
}

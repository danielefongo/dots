const glob = require('glob')
const pm = require('picomatch')
const path = require('path')
const chokidar = require('chokidar')
const { createHash } = require('crypto')
const { readFileSync } = require('fs')
const event = {
  ADD: 'add',
  REMOVE: 'remove',
  CHANGE: 'change'
}

function md5 (file) {
  const buff = readFileSync(file)
  return createHash('md5').update(buff).digest('hex')
}

module.exports = class DotBlock {
  constructor () {
    this.matches = {}
    this.matchOpts = (data) => ({ dot: true, ignore: data.ignore, cwd: this.getBasePath(data.match), nodir: true })
  }

  on (matchAction) {
    this.matches[matchAction.match] = matchAction

    return this
  }

  files (match) {
    return Object.entries(this.matches)
      .filter(([it, _]) => it == match)
      .flatMap(([match, data]) => glob.globSync(match, this.matchOpts(data)).map((relativeFile) => this.toAbsolute(relativeFile, match)))
  }

  run () {
    Object.entries(this.matches).forEach(([match, data]) => {
      glob.globSync(match, this.matchOpts(data)).forEach((relativeFile) => {
        const file = this.toAbsolute(relativeFile, match)
        this._fileReset(match, file)
        this._fileAction(match, file)
      })
    })

    return this
  }

  watch () {
    Object.entries(this.matches).forEach(([match, data]) => {
      const watchPath = this.getBasePath(match)
      const matcher = pm(match, this.matchOpts(data))
      const action = (evt) => {
        return (file) => {
          const relativeFile = this.toRelative(file, match)
          if (!matcher(relativeFile)) return
          this._fileReset(match, file)
          if (evt == event.REMOVE) return
          this._fileAction(match, file)
        }
      }
      this.matches[match].watcher = chokidar.watch(watchPath)
        .on('add', action(event.ADD))
        .on('unlink', action(event.REMOVE))
        .on('change', action(event.CHANGE))
    })

    return this
  }

  stopWatch () {
    Object.keys(this.matches).forEach((match) => {
      this._matchReset(match)
    })

    return this
  }

  getBasePath (match) {
    const data = this.matches[match]
    return data.path || process.cwd()
  }

  toAbsolute (relativeFile, match) {
    return path.join(this.getBasePath(match), relativeFile)
  }

  toRelative (file, match) {
    return file.replace(this.getBasePath(match) + '/', '')
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

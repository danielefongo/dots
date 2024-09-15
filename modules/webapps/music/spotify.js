module.exports = class SpotifyMusic {
  getPosition() {
    let time = document.querySelector(
      '[data-testid="playback-position"]',
    )?.textContent;

    return this._convertToSeconds(time);
  }

  setPosition(seconds) {
    let duration = document.querySelector(
      '[data-testid="playback-duration"]',
    )?.textContent;

    let progressPercentage = seconds / this._convertToSeconds(duration);

    let element = document.querySelector(
      '[data-testid="progress-bar-background"]',
    );

    this._pointerClick(element, progressPercentage);

    window.webapp.sendMessage("music", { position: seconds });
  }

  getVolume() {
    let volumePercentage = document
      .querySelector('[data-testid="volume-bar"] [data-testid="progress-bar"]')
      ?.style.getPropertyValue("--progress-bar-transform");

    if (!volumePercentage) return null;

    return parseFloat(volumePercentage) / 100;
  }

  setVolume(volume) {
    let element = document.querySelector(
      '[data-testid="volume-bar"] [data-testid="progress-bar"]',
    );

    if (!element) return;

    this._pointerClick(element, volume);

    window.webapp.sendMessage("music", { volume });
  }

  getStatus() {
    let status = document.querySelector(
      '[data-testid="control-button-playpause"][aria-label="Pause"]',
    );

    if (status == null) return "Paused";
    return "Playing";
  }

  next() {
    document
      .querySelector('[data-testid="control-button-skip-forward"]')
      ?.click();
  }

  previous() {
    document.querySelector('[data-testid="control-button-skip-back"]')?.click();
  }

  play() {
    document
      .querySelector(
        '[data-testid="control-button-playpause"][aria-label="Play"]',
      )
      ?.click();
    window.webapp.sendMessage("music", { status: "Playing" });
  }

  pause() {
    document
      .querySelector(
        '[data-testid="control-button-playpause"][aria-label="Pause"]',
      )
      ?.click();
    window.webapp.sendMessage("music", { status: "Paused" });
  }

  getShuffle() {
    return (
      document
        .querySelector('[data-testid="control-button-shuffle"]')
        ?.getAttribute("aria-checked") === "true" || false
    );
  }

  async setShuffle(enabled) {
    let element = document.querySelector(
      '[data-testid="control-button-shuffle"]',
    );

    if (this.getShuffle() !== enabled) {
      element.click();
    }

    window.webapp.sendMessage("music", { shuffle: enabled });
  }

  getLoop() {
    let element = document.querySelector(
      '[data-testid="control-button-repeat"]',
    );
    if (!element) return "None";

    if (element.getAttribute("aria-checked") === "true") return "Playlist";
    if (element.getAttribute("aria-checked") === "mixed") return "Track";
    return "None";
  }

  async setLoop(status) {
    let element = document.querySelector(
      '[data-testid="control-button-repeat"]',
    );
    if (!element) return;

    while (this.getLoop() !== status) {
      element.click();
      await new Promise((resolve) => setTimeout(resolve, 200));
    }

    window.webapp.sendMessage("music", { loop: status });
  }

  _convertToSeconds(time) {
    if (!time) return NaN;
    let [m, s] = time.split(":").map(Number);
    return m * 60 + s;
  }

  _pointerClick(element, percentage) {
    let boundingRect = element.getBoundingClientRect();
    let evt = {
      bubbles: true,
      cancelable: true,
      clientX: boundingRect.left + boundingRect.width * percentage,
      clientY: boundingRect.top + boundingRect.height / 2,
      pointerType: "mouse",
    };

    element.dispatchEvent(new PointerEvent("pointerdown", evt));
    element.dispatchEvent(new PointerEvent("pointerup", evt));
  }
};

import { Controller } from "@hotwired/stimulus"
import { post } from '@rails/request.js'
import { useTransition } from "stimulus-use"
// Connects to data-controller="you-got-weather"
export default class extends Controller {
  connect() {

    useTransition(this, {
      element: this.element,
      enterActive: 'transition duration-1000',
      enterFrom: 'opacity-0 translate-x-6',
      enterTo: 'opacity-100 translate-x-0',
      leaveActive: 'transition duration-1000',
      leaveFrom: 'opacity-100 translate-x-0',
      leaveTo: 'opacity-0 translate-x-6',
    })

    if (!this.isOptedOut()) {
      this.fetchLocalWeather()
    }
  }

  isOptedOut() {
    return document.cookie.split(';').some(item => item.trim().startsWith('local_weather_opt_out='))
  }

  async fetchLocalWeather() {

    console.log("Fetching local weather")

    const response = await post("/local-weather", {
      responseKind: "turbo-stream"
    })
    if (response.ok)  {
      this.enter()
    } else {
      try {
        const errorMessage = await response.text
        console.error(`Preview Failed: ${errorMessage}`)
      } catch (e) {
        console.error(`Preview Failed: ${response.statusCode} - Unable to read error details: ${e}`)
      }
    }
  }

  async hide() {
    await this.leave()
    this.element.remove()
    this.setOptOutCookie()
  }

  setOptOutCookie() {
    const expirationDate = new Date()
    expirationDate.setTime(expirationDate.getTime() + 24 * 60 * 60 * 1000) // 24 hours from now
    document.cookie = `local_weather_opt_out=true; expires=${expirationDate.toUTCString()}; path=/`
  }
}
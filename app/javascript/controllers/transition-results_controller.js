import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

// Connects to data-controller="transition-results"
export default class extends Controller {
  connect() {
    console.log("Transition Results Controller Connected")
    useTransition(this, {
      element: this.element,
      enterActive: 'transition duration-1000',
      enterFrom: 'opacity-0',
      enterTo: 'opacity-100',
    })

    // Trigger the enter transition when connected
    this.enter()
  }
}
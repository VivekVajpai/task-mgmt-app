import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="task"
export default class extends Controller {
  static targets = ["form"]

  toggle(event) {
    event.preventDefault();
    this.formTarget.classList.toggle("hidden");
  }
  
  connect() {
  }
}

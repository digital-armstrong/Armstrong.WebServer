import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "server"]

  connect(){
    this.dataFromAppCable = [];
    window.addEventListener('updateServer', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.serverUpdate();
    });
  }

  disconnect(){
    window.removeEventListener("updateServer", this.serverUpdate);
  }

  serverUpdate() {
    this.dataFromAppCable.forEach(element => {
      const server = document.getElementById(element.dom_id);
      server.innerHTML = element.html
  });

  this.dataFromAppCable = [];
  }
}

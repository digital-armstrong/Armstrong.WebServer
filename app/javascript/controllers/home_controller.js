import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "server"]

  connect(){
    this.dataFromAppCable = [];
    btnClear = document.getElementById('btnClear');
    btnClear.addEventListener('click', (event) => {
      const terminal = document.getElementById('terminal');
      terminal.innerHTML = '';
    });
    window.addEventListener('updateServer', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.serverUpdate();
    });
    window.addEventListener('terminalUpdate', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.appendToTerminal();
    });
  }

  disconnect(){
    window.removeEventListener("updateServer");
    window.removeEventListener("terminalUpdate");
  }

  serverUpdate() {
    this.dataFromAppCable.forEach(element => {
      console.log(element)
      const server = document.getElementById(element.dom_id);
      server.innerHTML = element.html
    this.dataFromAppCable = [];
  });
  }
  appendToTerminal(){
    this.dataFromAppCable.forEach(element => {
      const terminal = document.getElementById('terminal');
      terminal.insertAdjacentHTML('beforeend', element.html);
      this.dataFromAppCable = [];
    });
  }
}

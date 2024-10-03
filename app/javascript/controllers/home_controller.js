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
    window.addEventListener('serverInvalidAnswer', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.toastUpServerInvalidAnswer();
    });
  }

  disconnect(){
    window.removeEventListener("updateServer");
    window.removeEventListener("serverInvalidAnswer");
  }

  serverUpdate() {
    this.dataFromAppCable.forEach(element => {
      console.log(element)
      const server = document.getElementById(element.dom_id);
      server.innerHTML = element.html
    this.dataFromAppCable = [];
  });
  }
  toastUpServerInvalidAnswer(){
    this.dataFromAppCable.forEach(element => {
      const terminal = document.getElementById('terminal');
      terminal.insertAdjacentHTML('beforeend', '<p>' + element.html + '</p>');
      this.dataFromAppCable = [];
    });
  }
}

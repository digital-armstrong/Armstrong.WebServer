import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["server"]

  connect(){
    this.dataFromAppCable = [];
    btnClear = document.getElementById('btnClear');
    btnClear.addEventListener('click', (event) => {
      const terminal = document.getElementById('terminal');
      terminal.innerHTML = '';
    });

    window.addEventListener('createServer', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.htmlBuilder()
    })
    window.addEventListener('updateServer', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.htmlBuilder(true)
    });
    window.addEventListener('terminalUpdate', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.htmlBuilder()
    });
  }

  disconnect(){
    window.removeEventListener("updateServer");
    window.removeEventListener("terminalUpdate");
    window.removeEventListener("createServer");
  }

  htmlBuilder(isReplace = false){
    this.dataFromAppCable.forEach(element => {
      const htmlElementForEdit = document.getElementById(element.htmlId)
      if (isReplace == true){
        htmlElementForEdit.innerHTML = element.html
      }
      else{
        htmlElementForEdit.insertAdjacentHTML('beforeend', element.html);
      }
    });
    this.dataFromAppCable = []
  }
}

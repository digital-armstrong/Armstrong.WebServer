import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["notification"]

  connect(){
    this.dataFromAppCable = [];

    window.addEventListener('notificationUpdate', (event) => {
      this.dataFromAppCable.push(event.detail);
      this.dataFromAppCable.forEach(element => {
        const htmlElementForEdit = document.getElementById('notification');
        htmlElementForEdit.innerHTML = element.html;
      });
      this.dataFromAppCable = [];

    });
  }

  disconnect(){
    window.removeEventListener("notificationUpdate");
  }
}

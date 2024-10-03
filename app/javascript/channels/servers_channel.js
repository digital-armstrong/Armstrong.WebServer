import consumer from "./consumer"

consumer.subscriptions.create("ServersChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const event = new CustomEvent('updateServer', { detail: data });
    window.dispatchEvent(event);
  }
});

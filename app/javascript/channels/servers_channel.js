import consumer from "./consumer"

consumer.subscriptions.create("ServersChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var event;
    switch (data.event_id) {
      case 1:
        event = new CustomEvent('updateServer', { detail: data });
        break;
      case 2:
        event = new CustomEvent('serverInvalidAnswer', { detail: data });
        break;
    }
    window.dispatchEvent(event);
  }
});

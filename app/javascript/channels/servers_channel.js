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
    console.log(data)
    switch (data.event_id) {
      case 'server_update':
        event = new CustomEvent('updateServer', { detail: data });
        break;
      case 'terminal_update':
        event = new CustomEvent('terminalUpdate', { detail: data });
        break;
    }
    window.dispatchEvent(event);
  }
});

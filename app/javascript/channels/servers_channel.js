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
    switch (data.eventId) {
      case 'server_update':
        event = new CustomEvent('updateServer', { detail: data });
        break;
      case 'server_create':
        event = new CustomEvent('createServer', { detail: data });
        break;
      case 'server_delete':
        event = new CustomEvent('serverDelete', { detail: data });
        break;
      case 'terminal_update':
        event = new CustomEvent('terminalUpdate', { detail: data });
        break;
    }
    window.dispatchEvent(event);
  }
});

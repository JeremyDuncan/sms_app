import consumer from "channels/consumer"

consumer.subscriptions.create("JobQueueChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const jobQueueElement = document.getElementById('job-queue');
    const messageType = data.message.includes('Started') ? 'start' : 'complete';
    jobQueueElement.insertAdjacentHTML('beforeend', `<pre class="job-message ${messageType}">${data.message}</pre>`);
  }
});

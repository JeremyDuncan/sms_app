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
    jobQueueElement.insertAdjacentHTML('beforeend', `<pre class="job-message">${data.message}</pre>`);
  }
});

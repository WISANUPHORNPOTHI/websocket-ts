import { WebSocketServer } from "ws";

const PORT = Number(process.env.PORT) || 3001;

const wss = new WebSocketServer({ port: PORT });

wss.on("connection", (ws, req) => {
  console.log("Client connected");

  ws.on("message", (message) => {
    wss.clients.forEach((client) => {
      if (client.readyState === client.OPEN) {
        client.send(message.toString());

      }
    });

  });


  ws.on("close", () => {
    console.log("Client disconnected");
  });
});

console.log("WebSocket running on port", PORT);

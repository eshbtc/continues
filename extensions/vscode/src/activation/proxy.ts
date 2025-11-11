import cors from "cors";
import express from "express";
import { http, https } from "follow-redirects";

const PROXY_PORT = 65433;
const app = express();

// Security: Disable X-Powered-By header
app.disable("x-powered-by");

app.use(cors());

// Allowed protocols for SSRF protection
const ALLOWED_PROTOCOLS = ["http:", "https:"];

// Optional: Add allowed hosts whitelist for additional security
// const ALLOWED_HOSTS = ["api.example.com", "localhost", "127.0.0.1"];

app.use((req, res, next) => {
  // Proxy the request
  const { origin, host, ...headers } = req.headers;
  const url = req.headers["x-continue-url"] as string;

  // SSRF Protection: Validate URL
  if (!url) {
    return res.status(400).json({ error: "Missing x-continue-url header" });
  }

  let parsedUrl: URL;
  try {
    parsedUrl = new URL(url);
  } catch (e) {
    return res.status(400).json({ error: "Invalid URL format" });
  }

  // SSRF Protection: Validate protocol
  if (!ALLOWED_PROTOCOLS.includes(parsedUrl.protocol)) {
    return res.status(400).json({
      error: `Protocol not allowed. Allowed protocols: ${ALLOWED_PROTOCOLS.join(", ")}`,
    });
  }

  // Optional: Add host whitelist check here if needed
  // if (ALLOWED_HOSTS && !ALLOWED_HOSTS.includes(parsedUrl.hostname)) {
  //   return res.status(400).json({ error: "Host not allowed" });
  // }

  const protocol = parsedUrl.protocol === "https:" ? https : http;
  const proxy = protocol.request(url, {
    method: req.method,
    headers: {
      ...headers,
      host: parsedUrl.host,
    },
  });

  proxy.on("response", (response) => {
    res.status(response.statusCode || 500);
    for (let i = 1; i < response.rawHeaders.length; i += 2) {
      if (
        response.rawHeaders[i - 1].toLowerCase() ===
        "access-control-allow-origin"
      ) {
        continue;
      }
      res.setHeader(response.rawHeaders[i - 1], response.rawHeaders[i]);
    }
    response.pipe(res);
  });

  proxy.on("error", (error) => {
    console.error(error);
    res.sendStatus(500);
  });

  req.pipe(proxy);
});

// http-middleware-proxy
// app.use("/", (req, res, next) => {
//   // Extract the target from the request URL
//   const target = req.headers["x-continue-url"] as string;
//   const { origin, ...headers } = req.headers;

//   // Create a new proxy middleware for this request
//   const proxy = createProxyMiddleware({
//     target,
//     ws: true,
//     headers: {
//       origin: "",
//     },
//   });

//   // Call the middleware
//   proxy(req, res, next);
// });

export function startProxy() {
  const server = app.listen(PROXY_PORT, () => {
    console.log(`Proxy server is running on port ${PROXY_PORT}`);
  });
  server.on("error", (e) => {
    // console.log("Proxy server already running on port 65433");
  });
}

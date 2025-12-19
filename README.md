# 🌌 Omada Webhook to Discord
An easy script for integrating Discord Webhooks with the Omada Controller. It allows sending logs from the controller to a selected Discord channel.

![Discord_gVcpXzaMEdDg.png](images/Discord_gVcpXzaMEdDg.png)
*ENABLE_DATA_CENSORING=true*

## Worth Knowing
✅ Discord @mentions for critical alerts (detected attack, errors, etc.)  
✅ [Middleware](middlewares/verifySecret.js) responsible for verifying the `shardSecret`.  
✅ Ability to enable censorship of sensitive data.  
✅ Ready [configuration](ecosystem.config.js) for [PM2](https://www.npmjs.com/package/pm2).  
✅ Built in [Node.js](https://nodejs.org) using the [Express.js](https://www.npmjs.com/package/express) framework.

## Cloning
```bash
git clone https://github.com/sefinek/Omada-Webhook-to-Discord.git
```

## Endpoint
After running this script, webhooks from your controller should be directed to this endpoint:
```
POST /discord/webhook
```

### Example
```
http://192.168.0.145:8080/discord/webhook
```

### Docker Compose
Run this container alongside your Omada Controller and reference it by container name in the Controller settings (```http://omada-webhook-to-discord:8080/discord/webhook```).
````
services:
  omada-webhook-to-discord:
    container_name: omada-webhook-to-discord
    image: ghcr.io/mdesdin/omada-webhook-to-discord:1
    build:
      context: .
      dockerfile: Dockerfile
    restart: unless-stopped

    # Environment variables
    env_file:
      - .env

    # Omada needs to reach this port
    # Only need to expose it if this container is not
    # on the same docker network as your omada controller
    #ports:
    #  - "8080:8080"

    # Security hardening (safe for this app)
    user: "1000:1000"   # node user inside node:20-alpine
    read_only: true
    cap_drop:
      - ALL

    # Writable tmpfs for Node.js
    tmpfs:
      - /tmp

    # Healthcheck mirrors Dockerfile (Compose overrides allowed)
    healthcheck:
      test: ["CMD", "nc", "-z", "127.0.0.1", "8080"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

    # Override the built-in .env (Optional)
    #volumes:
    #  - ./env/.env:/app/.env:ro
````

## MIT License
Copyright 2024-2025 © by [Sefinek](https://sefinek.net). All Rights Reserved.
# Mediacenter

This repository contains a set of Docker-based services that form a complete media center system. These services include Traefik, Redis, Sonarr, Radarr, Plex, and more, configured through a `docker-compose.yml` file.

## Key Features

- [**Traefik**](https://traefik.io): Reverse proxy with support for Let's Encrypt and Cloudflare DNS.
- [**Redis**](https://redis.io): In-memory database for data storage.
- [**Sonarr**](https://sonarr.tv): Automatic TV series downloads and management.
- [**Radarr**](https://radarr.video): Automatic movie downloads and management.
- [**Bazarr**](https://www.bazarr.media): Subtitle downloads and management.
- [**Prowlarr**](https://prowlarr.com): Indexer aggregator for Sonarr and Radarr.
- [**Plex**](https://www.plex.tv): Media server for streaming movies, TV shows, and more.
- [**Transmission**](https://transmissionbt.com): BitTorrent client for automated downloads.
- [**VPN Gateway (Gluetun)**](https://github.com/qdm12/gluetun): VPN connection to ensure privacy and security.

## Prerequisites

1. **Docker and Docker Compose** installed on your system.
2. Create a `.env` file in the project root based on the provided `.env_example` file:
   ```bash
   cp .env_example .env
   ```
   Edit the `.env` file to include your custom values.

## Project Structure

```plaintext
mediacenter/
├── docker-compose.yml
├── .env_example
├── .env
├── volumes/
│   ├── traefik/
│   ├── redis/
│   ├── sonarr/
│   ├── radarr/
│   ├── bazarr/
│   ├── prowlarr/
│   ├── plex/
│   ├── transmission/
│   └── vpn/
├── media/
│   ├── tvshows/
│   ├── movies/
│   ├── other_media/
│   └── downloads/
```

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/your_username/mediacenter.git
   cd mediacenter
   ```

2. Create and configure the `.env` file based on the `.env_example` file:

   ```bash
   cp .env_example .env
   ```

3. Create the necessary directories for volumes:

   ```bash
   mkdir -p volumes/traefik volumes/redis volumes/sonarr volumes/radarr \
      volumes/bazarr volumes/prowlarr volumes/plex volumes/transmission \
      volumes/vpn media/tvshows media/movies media/other_media downloads
   ```

4. Start the services:

   ```bash
   docker-compose up -d
   ```

5. Access the services using the configured subdomains:

   - Traefik Dashboard: `https://tf.your_domain`
   - Sonarr: `https://sr.your_domain`
   - Radarr: `https://rr.your_domain`
   - Plex: Accessible on your local network or via the Plex client.

## Notes

- Ensure the required ports are open on your server.
- SSL certificates are automatically generated with Let's Encrypt.
- You can adjust the values in the `docker-compose.yml` file according to your needs.

## Contributions

Contributions are welcome. If you want to add features or improve the configuration, create a fork of this repository and open a pull request.

## License

This project is licensed under the [MIT License](LICENSE).



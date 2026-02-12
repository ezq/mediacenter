# Mediacenter

Stack Docker para un centro de medios completo, con *arrs, Plex, descargas automáticas a través de VPN y proxy reverso con Let's Encrypt.

## Características

| Servicio | Descripción |
|----------|-------------|
| [**Traefik**](https://traefik.io) | Proxy reverso con Let's Encrypt y Cloudflare DNS |
| [**Cloudflare-DDNS**](https://github.com/favonia/cloudflare-ddns) | DNS dinámico para mantener subdominios apuntando a tu IP |
| [**Sonarr**](https://sonarr.tv) | Descargas automáticas de series de TV |
| [**Radarr**](https://radarr.video) | Descargas automáticas de películas |
| [**Prowlarr**](https://prowlarr.com) | Gestor de indexadores para Sonarr y Radarr |
| [**Bazarr**](https://www.bazarr.media) | Subtítulos automáticos |
| [**Plex**](https://www.plex.tv) | Servidor de medios para streaming |
| [**Transmission**](https://transmissionbt.com) | Cliente BitTorrent (através de VPN) |
| [**Unpackerr**](https://github.com/davidnewhall/unpackerr) | Descompresión automática de archivos descargados |
| [**FlareSolverr**](https://github.com/FlareSolverr/FlareSolverr) | Solucionador de Cloudflare para indexadores protegidos |
| [**VPN Gateway (Gluetun)**](https://github.com/qdm12/gluetun) | Puerta de enlace VPN (ProtonVPN) para Transmission |

## Requisitos previos

1. **Docker** y **Docker Compose** v2
2. Cuenta en **Cloudflare** y dominio configurado
3. Suscripción **ProtonVPN** (u otro proveedor compatible con Gluetun)

## Configuración

1. Copia el archivo de ejemplo y edítalo con tus valores:

   ```bash
   cp .env_example .env
   vim .env
   ```

2. Variables principales:
   - **Cloudflare**: `CF_DNS_API_TOKEN`, `CF_API_EMAIL`, `CF_API_KEY`
   - **Let's Encrypt**: `LE_EMAIL`
   - **Dominio**: `DOMAIN` (ej: `midominio.com`)
   - **VPN**: `OPENVPN_USER`, `OPENVPN_PASSWORD`, `VPN_COUNTRIES`
   - **Traefik**: `TF_BASIC_AUTH` (generar con `htpasswd -nb admin tu_password`)
   - **Unpackerr**: `SONARR_APIKEY`, `RADARR_APIKEY` (obtener desde cada app tras el primer arranque)

3. Crea los directorios necesarios:

   ```bash
   mkdir -p volumes/{traefik,sonarr,radarr,bazarr,prowlarr,plex,transmission,vpn,unpackerr} \
            media/{tvshows,movies,other_media,other_movies} \
            downloads/{TransmissionWatchFolder} \
            backups
   ```

## Uso

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/ezq/mediacenter.git
   cd mediacenter
   ```

2. Configurar `.env` como se indica arriba.

3. Levantar los servicios:

   ```bash
   docker compose up -d
   ```

4. Acceder a los servicios:

   | Subdominio | Servicio | Descripción |
   |------------|----------|-------------|
   | `sr.tu_dominio` | Sonarr | Administrar series de TV y descargas desde cualquier sitio |
   | `rr.tu_dominio` | Radarr | Administrar películas y colecciones desde cualquier sitio |

   Los subdominios `sr` (Sonarr) y `rr` (Radarr) permiten gestionar tu biblioteca de medios de forma remota con HTTPS. El resto de servicios se accede por IP y puerto:

   | Servicio | Acceso |
   |----------|--------|
   | Plex | Cliente Plex o `http://IP:32400` |
   | Prowlarr | `http://IP:9696` |
   | Bazarr | `http://IP:6767` |
   | Transmission | `http://IP:9091` |

## Estructura del proyecto

```plaintext
mediacenter/
├── compose.yml          # Orquestación principal
├── .env_example         # Plantilla de variables de entorno
├── .env                 # Tus credenciales (no versionado)
├── list.txt             # Usado por backup.sh
├── services/            # Definiciones por servicio
│   ├── traefik.yml
│   ├── cloudflare-ddns.yml
│   ├── sonarr.yml
│   ├── radarr.yml
│   ├── bazarr.yml
│   ├── prowlarr.yml
│   ├── plex.yml
│   ├── transmission.yml
│   ├── vpn-gateway.yml
│   ├── unpackerr.yml
│   └── flaresolverr.yml
├── scripts/
│   └── backup.sh        # Backup local y opcional a Google Drive
├── volumes/             # Datos persistentes
├── media/               # Contenido multimedia
├── downloads/           # Descargas
└── backups/             # Backups generados por backup.sh
```

## Script de backup

El script `scripts/backup.sh` crea copias de seguridad de la configuración y volúmenes:

- Genera un `.tar.gz` en `backups/`
- Mantiene solo los 3 backups más recientes
- Si tienes **rclone** con un remoto `gdrive` configurado, sincroniza esos backups a Google Drive

Ejemplo de uso:

```bash
./scripts/backup.sh
```

## Notas

- Transmission usa la red de Gluetun (VPN), por lo que todo el tráfico pasa por la VPN.
- Los certificados SSL se gestionan con Let's Encrypt y Cloudflare DNS.
- Cloudflare-DDNS mantiene los subdominios `sr` (Sonarr), `rr` (Radarr) y el dominio raíz apuntando a la IP pública del servidor.
- Plex usa `network_mode: host` para que el descubrimiento en la red local funcione correctamente.

## Contribuciones

Las contribuciones son bienvenidas. Abre un fork y un pull request si quieres mejorar la configuración o la documentación.

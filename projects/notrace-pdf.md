# NoTracePDF

Self-hosted, zero-trace, ephemeral PDF toolkit.

## Purpose

Privacy-focused PDF processing application. Like iLovePDF, but nothing is ever saved, logged, or traced — files exist only during processing and disappear forever after download.

## Key Principles

- **Zero persistence**: Files processed in-memory only, never written to disk
- **No traces**: No logging of filenames, IPs, file sizes, or timestamps
- **Self-hosted**: Runs on your own infrastructure (this Raspberry Pi)
- **No accounts**: No tracking, no sessions, no data collection
- **Ephemeral**: Files deleted immediately after download

## Features

42 PDF tools organized into categories:

- **Organize**: Merge, Split, Rotate
- **Compress**: Compress, Flatten, Remove metadata
- **Convert to PDF**: Images, Word, Excel, PowerPoint, HTML, URL, Text, Markdown, RTF
- **Convert from PDF**: Images, Word, Excel, PowerPoint
- **Security**: Password protect/remove, Redact text
- **Extract**: Text, Images, Pages, OCR
- **Watermark & Page Numbers**: Add watermarks, page numbers
- **Page Operations**: Crop, Scale, Resize
- **Advanced**: Batch process, Compare PDFs

### UI Features

- Dark mode (default)
- Live search bar
- Responsive design
- PDF preview
- Client-side processing for small files (<20MB)

## Access Model

- **Repository**: https://github.com/lorenzoromandini/NoTracePDF
- **Network**: Tailscale-only
- **Transport**: HTTP (no TLS required for internal use)
- **URL**: `http://raspberry-pi-4.tail2ce491.ts.net:8000` (when deployed)

## Tech Stack

- **Runtime**: Python (backend processing)
- **UI**: Web interface
- **Processing**: In-memory PDF manipulation
- **Container**: Docker

## Deployment Model

**Status**: Active - deployed via Docker Compose

**Configuration**:
- Runtime: Docker Compose
- Compose location: `/home/ubuntu/projects/NoTracePDF/docker-compose.yml` (for development)
- Planned production: `/srv/edge-lab/docker/notrace-pdf/`

**Quick Start**:
```bash
git clone https://github.com/lorenzoromandini/NoTracePDF.git
cd NoTracePDF
docker compose up -d
```

## Source Location

```
/home/ubuntu/projects/NoTracePDF/
├── app/                   # Application code
├── static/               # Static assets
├── templates/            # HTML templates
├── docker-compose.yml    # Docker deployment
├── Dockerfile           # Container definition
└── requirements.txt     # Python dependencies
```

## Environment

No environment variables required — the app is designed to work with zero configuration.

All processing happens in-memory with no persistence layer.

## Operational Notes

### Memory Considerations

- Large PDFs (>20MB) are processed server-side
- Ensure adequate RAM for concurrent processing
- Container memory limits should account for peak usage

### Security

- No authentication required by design
- Tailscale network provides access control
- No logs retained of processed files

## Development

Local development:
```bash
cd /home/ubuntu/projects/NoTracePDF
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

Or use Docker:
```bash
docker compose up -d
```

## Related

- [Calcetto Manager](./calcetto-app.md) - Another self-hosted project
- [Services](../services/) - Infrastructure services
- [Docker](../docker/) - Other Docker deployments

## Repository

https://github.com/lorenzoromandini/NoTracePDF

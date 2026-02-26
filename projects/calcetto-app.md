# Calcetto Manager

Self-hosted football match organization web application.

## Purpose

Calcetto Manager is a mobile-first web app for organizing football matches with friends. Track games, players, and statistics in a privacy-focused, self-hosted environment.

## Features

- **Club Management** - Create and manage clubs, add members with roles
- **Match Organization** - Schedule matches, set dates and locations
- **Live Match Tracking** - Real-time score updates during games
- **Player Statistics** - Track goals, assists, and performance metrics
- **Player Ratings** - Rate members after each match
- **Leaderboards** - Rank members across multiple statistics
- **Dark/Light Theme** - Automatic system detection + manual toggle
- **Multi-language** - Italian (default) and English support

## Access Model

- **Repository**: https://github.com/lorenzoromandini/CalcettoApp
- **Network**: Tailscale-only (when deployed)
- **Transport**: TLS enabled (when deployed)
- **URL**: `https://raspberry-pi-4.tail2ce491.ts.net:3000` (planned)

## Tech Stack

- **Frontend**: React 19 + Next.js 15 (App Router)
- **Styling**: Tailwind CSS 4.x + shadcn/ui components
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: NextAuth.js v5 with JWT sessions
- **i18n**: next-intl v4

## Deployment Model

**Status**: In active development, not yet deployed

**Planned deployment**:
- Runtime: Docker Compose
- Compose location: `/srv/edge-lab/docker/calcetto-app`
- Database: PostgreSQL container
- Reverse proxy: Traefik or similar

## Source Location

```
/home/ubuntu/projects/CalcettoApp/
├── app/                    # Next.js App Router
├── components/            # React components
├── prisma/                # Database schema
├── public/                # Static assets
├── lib/                   # Utilities and API routes
└── package.json
```

## Development

Local development:
```bash
cd /home/ubuntu/projects/CalcettoApp
npm install
npm run dev
```

## Dependencies

- Node.js 20+
- PostgreSQL (for local dev)
- Docker (for deployment)

## Database Schema

Key models:
- User
- Club / ClubMember / ClubInvite
- Match / Formation / FormationPosition
- Goal / PlayerRating

Run `npx prisma studio` to explore data.

## Notes

- Currently in development phase
- Database migrations managed via Prisma
- Authentication uses bcryptjs for password hashing
- Planned for Tailscale-only access (no public exposure)

## Related

- [NoTracePDF](./notrace-pdf.md) - Another self-hosted project
- [Services](../services/) - Infrastructure services
